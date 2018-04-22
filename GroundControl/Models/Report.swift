//
//  Report.swift
//  GroundControl
//
//  Created by Francisco Lobo on 11/26/17.
//  Copyright © 2017 Movic Technologies. All rights reserved.
//

import Foundation
import MapKit


// The capsule will transmit report messages either from a cellular model source or a sattelite modem source, this message will be delivered to a server (movic.io for now), so that the server will collect all data regardless if this app is connected or not, so the server is always listening for this messages 24x7. Anytime the capsule transmit the server will receive and store in a database. At the same time if there is client (an app like this one) connected to the server [see SocketCenter] it will notify the connected apps of the latest messages.
//
//
//
// In summary, everytime an app (this app) connects to the server, the server will transmit a bunch of past messages [history] to the app so the app can plot old messages too. And from that moment on, the server will notify of any new messages in push fashion (no need to keep polling the server for new data, as soon as the server gets messages it will push that message to all ground station app clients like this one. [See SocketCenter.swift for more info.

// Technical details of the capsule message as of Jan 2018.
// The message the capsule sends to the server has the following format:
//      SAMPLE:
//      cell,S,024145,25.6428,-100.3589,2114,0,98,5,158,9,0,G
//      cell,X,205759,25.6596,-100.4477,2113
//
//      The server adds some more information (timestamping according to the server time) and stores it
//      and sends it to the app in the following raw format:
//            2017-11-28T07:37:53.808Z | cel,S,073751,25.6428,-100.3588,2084,0,204,6,116,8,0,C
//            2017-11-28T07:38:09.443Z | cel,X,073806,25.6428,-100.3588,2084
//       This are the values:
//            |--   SERVER TIMESTAMP --||-- THIS DATA COMES FROM THE CAPSULE -----------------|
//                                        source, kind of msg (S) , timestamp, lat, lon, alt
//                                        source, kind of msg (X) , timestamp, lat, lon, alt, speed, course, gps sats, horizontal prec
//                                             battery level, sat signal, internal temp.
//
// This protocol messages can evolve and the server app and this app should evolve accordingly!
//String(gpsParser.location.lat(), 4) + "," +
//    String(gpsParser.location.lng(), 4) + "," +
//    String(gpsParser.altitude.feet(),0) + "," +
//    String(gpsParser.speed.knots(),0) + "," +
//    String(gpsParser.course.deg(),0) + "," +
//    String(gpsParser.satellites.value()) + "," +
//    String(gpsParser.hdop.value()) +  "," +
//    String(batteryLevel/10,0) +  "," +
//    String(satcomSignal) +  "," +
//    String(internalTempC,0) +  "," +
//    missionStageShortString();


// Report MODEL
//ENUMS
enum Originator {
    case satellite
    case cellular
    case radio
    case unknown
}

enum ReportKind {
    case pulse
    case telemetry
    case unknown
}

enum MissionStage {
    case ground
    case climb
    case descent
    case recovery
    case unknown
    
    func stringValue() -> String {
        switch self {
        case .ground:
            return "Ground"
        case .climb:
            return "Climb"
        case .descent:
            return "Descent"
        case .recovery:
            return "Recovery"
        case .unknown:
            return "Unknown"
        }
    }
}

// Comform MapAnnotation to MKAnnotation protocol for mapkit annotations (pins, and position shown in map).
class MapAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
}

// Report model struct
// Every message gathered from the server [capsule] will be a Report
struct Report  {
    //    TODO: use Optionals to validate data.    
    let gpsTimeStamp:Date
    let serverTimeStamp:Date
    let rawReport:String
    var originator:Originator = .unknown
    var reportType:ReportKind = .unknown
    var index:Int = -1
    
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    var altitude:Int = 0
    
    var course:Int = 0
    var speed:Int = 0
    var satellitesInView:Int = 0
    var horizontalPrecision:Int = 0
    var batteryLevel:Int = 0
    var satModemSignal:Int = 0
    var internalTempC:Int = 0
    var missionStage:MissionStage = .unknown
    
    var altitudeInMeters:Int {
        get {
           return Int(Float(self.altitude) *  0.3048)
        }
    }
    
    var speedInKilometersPerHour: Int {
        get {
            return Int(Float(self.speed) *  1.852)
        }
    }
    
//    var mapAnnotationTitle:String = ""
//    var mapAnnotationSubTitle:String = ""
    private var _mapAnnotation = MapAnnotation()
}


extension Report { // To Map Coordinate for use in the MKMAp (to make a report show on the map)
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    var mapAnnotation: MapAnnotation {
        get {
            if self.originator == .cellular {
                _mapAnnotation.title = String(format: "       CELL MSG - IDX: %i", index)
            } else {
                _mapAnnotation.title = String(format: "       SAT MSG - IDX: %i", index)
            }
            _mapAnnotation.coordinate = coordinate
            return _mapAnnotation
        }
    }
}

extension Report {
    func isLocationSame(as latitude: Double, longitude: Double) -> Bool {
        if self.latitude == latitude && self.longitude == latitude {
            return true
        }
        return false
    }
}

extension Report {
    static func sortReportsByAge(from array: [Report]) -> [Report] {
        let sortedArray = array.sorted(by: {
            if ($0.gpsTimeStamp < $1.gpsTimeStamp) {
                return true;
            }
            return false;
        })
        
        return sortedArray
    }
}

extension Report: Hashable
{
    var hashValue: Int {
        return Int(self.latitude + self.longitude + gpsTimeStamp.timeIntervalSince1970)
    }
    
    static func ==(lhs: Report, rhs: Report) -> Bool {
        
        if (lhs.missionStage == rhs.missionStage)  &&  (lhs.reportType == rhs.reportType) && (lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude) && (lhs.gpsTimeStamp == rhs.gpsTimeStamp) {
            return true
        }
        

        return false
    }
}
//          This extension will provide an initializer to parse or assign all values to appropriate fields in the model.
extension Report {
    init(rawString:String) {
        rawReport = rawString
        
        let validateTS = rawString.components(separatedBy: "|")
        let validateDT = rawString.components(separatedBy: ",")
        
        if validateTS.count < 2 || validateDT.count < 5  {
            gpsTimeStamp = Date(timeIntervalSince1970: 0)
            serverTimeStamp = Date(timeIntervalSince1970: 0)
            originator  = .unknown
            reportType = .unknown
            longitude = 0.0
            latitude = 0.0
            altitude = -1
            return
        }
        
        
        
        let dataFields = rawString.components(separatedBy: "|")[1]
        let serverTimeStampString = rawString.components(separatedBy: "|")[0]
        
        //Parse the server timestamp
        if let serverTime = Date.fromServerString(serverTimeStampString) {
            serverTimeStamp = serverTime
        } else {
            print("[Report] Invalid server timestamp format. Falling back to current time")
            serverTimeStamp = Date(timeIntervalSince1970:0)
        }
        
        //Originator
        let originatorRaw = dataFields.components(separatedBy: ",")[0].trimmingCharacters(in: .whitespaces)
        if originatorRaw == "cel" {
            originator = .cellular
        }
        if originatorRaw == "sat" {
            originator = .satellite
        }
        if originatorRaw == "rad" {
            originator = .radio
        }
        
        //Report Kind [See Capsule SourceCode for values]
        if dataFields.components(separatedBy: ",")[1] == "A" {
            reportType = .pulse
        }
        if dataFields.components(separatedBy: ",")[1] == "B" {
            reportType = .telemetry
        }
        
        let gpsTimeStampString = dataFields.components(separatedBy: ",")[2]
        gpsTimeStamp = Date.fromGPSString(gpsTimeStampString)        
        
        let rawLat = dataFields.components(separatedBy: ",")[3]
        let rawLon = dataFields.components(separatedBy: ",")[4]
        let rawAlt = dataFields.components(separatedBy: ",")[5]
        
        latitude = Double(rawLat) ?? 0.0
        longitude = Double(rawLon) ?? 0.0
        altitude = Int(rawAlt) ?? 0
        
        //Assign data for .pulse type
        if (reportType == .pulse) {
            speed = Int(dataFields.components(separatedBy: ",")[6]) ?? 0
            course = Int(dataFields.components(separatedBy: ",")[7]) ?? 0
            satellitesInView = Int(dataFields.components(separatedBy: ",")[8]) ?? 0
            horizontalPrecision = Int(dataFields.components(separatedBy: ",")[9]) ?? 0
            batteryLevel =  Int(dataFields.components(separatedBy: ",")[10]) ?? 0
            satModemSignal =  Int(dataFields.components(separatedBy: ",")[11]) ?? 0
            internalTempC =  Int(dataFields.components(separatedBy: ",")[12]) ?? 0
            
            print("-------VARIABLES INCOMING---------")
            print(speed)
            print(course)
            print(horizontalPrecision)
            print(satellitesInView)
            print(batteryLevel)
            print(satModemSignal)
            print(internalTempC)
            
            
            let rawMissionStage = dataFields.components(separatedBy: ",")[13]
            switch rawMissionStage {
            case "G":
                missionStage = .ground
            case "C":
                missionStage = .climb
            case "D":
                missionStage = .descent
            case "R":
                missionStage = .recovery
            default:
                missionStage = .unknown
            }
        }
        
        //Computed Assignments
        _mapAnnotation.subtitle = gpsTimeStamp.toTimeReadableString()
        _mapAnnotation.coordinate = coordinate        
    }
}


extension Report {
    func annotationIdentifierForStage() -> String {
        var annotationIdentifier = "PinDotBlue"
        
        
        switch self.missionStage
        {
        case .climb:
            annotationIdentifier = "PinCapsuleBalloon"
        case .descent:
            annotationIdentifier = "PinCapsuleParachute"
        case .recovery:
            annotationIdentifier = "PinCapsuleRecovery"
        case .ground:
            annotationIdentifier = "PinCapsuleGround"
        case .unknown:
            annotationIdentifier = "PinCapsuleBalloon"
        }
        
        return annotationIdentifier
    }
    
    static func altitudeGainPerSecond(oldestReport: Report, newestReport: Report) -> Double {
        let timeChange = newestReport.gpsTimeStamp.timeIntervalSince1970 - oldestReport.gpsTimeStamp.timeIntervalSince1970        
        let altitudeChange = Double(newestReport.altitude) - Double(oldestReport.altitude)
        let altitudePerPeriod = altitudeChange / timeChange
        return altitudePerPeriod
    }
}

//This extension to Date type will convert from GPS raw timestamp to something we can use in iOS
extension Date {
    static func fromGPSString(_ gpsTime: String) -> Date {
        //Format transmitted: DDMMHHMMSS
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMHHmmss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") as TimeZone?
        
        if let date = dateFormatter.date(from: String(gpsTime)) {
            let calendar = Calendar.current
            var dateComponents: DateComponents? = calendar.dateComponents([.hour, .minute, .second, .month, .day, .year], from: date)
            
            dateComponents?.year =  calendar.component(.year, from: Date())
            
            return calendar.date(from: dateComponents!)!;
        } else {
            return Date(timeIntervalSince1970:0)
        }
    }
    
    static func fromServerString(_ serverTime: String) -> Date? {
        let trimmedIsoString = serverTime.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        let isoFormatter = ISO8601DateFormatter()
        let date = isoFormatter.date(from: trimmedIsoString)
        return date
    }
    
    func toDateTimeReadableString() -> String {
        let stringFormatter = DateFormatter()
        stringFormatter.dateFormat = "MMM d, h:mm a"
        let dateString = stringFormatter.string(from: self)
        return dateString
    }
    
     func toTimeReadableString() -> String {
            let stringFormatter = DateFormatter()
            stringFormatter.dateFormat = "HH:mm:ss"
            let dateString = stringFormatter.string(from: self)
            return dateString
    }
    
}


