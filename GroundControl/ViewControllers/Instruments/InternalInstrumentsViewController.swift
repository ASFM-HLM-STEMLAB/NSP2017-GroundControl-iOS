//
//  InternalInstrumentsViewController.swift
//  GroundControl
//
//  Created by Francisco Lobo on 2/26/18.
//  Copyright © 2018 Movic Technologies. All rights reserved.
//

import UIKit

//TIME,LAT,LON,ALT,SPEED,COURSE,SATS,HDOP,BATT,SAT,STAGE
//A= TimeStamp, Lat, Lon, Alt, Speed, HDG, GPS_SATS, GPS_PRECISION, BATTLVL, IRIDIUM_SATS, INT_TEMP, STAGE
//B= TimeStamp, Lat, Lon, Alt, ExtTemp, ExtHum, ExtPress

class InternalInstrumentsViewController: UIViewController, ReportRenderable {

    private var latestReport:Report?
    
    @IBOutlet weak var verticalSpeedIndicator: GraphicalIndicator!
    @IBOutlet weak var secondaryAltitudeLabel: UILabel!
    @IBOutlet weak var dataBeaconView: UIView!
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var iridiumSatsLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var secondarySpeedLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var batteryLabel: UILabel!
    @IBOutlet weak var gpsQualityLabel: UILabel!
    @IBOutlet weak var gpsSatsLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var battIndicator: GraphicalIndicator!
    @IBOutlet weak var hdopIndicator: GraphicalIndicator!
    
    @IBOutlet weak var altitudeChangeLabel: UILabel!
    let refreshTimeReportsEvery:TimeInterval = 1
    var refreshTimer:Timer?

    
    func setReport(_ report: Report) {
        guard report.reportType == .pulse else { return } //We only update on A message (PULSE)
        
        if let latestReport = latestReport {
            guard report.gpsTimeStamp > latestReport.gpsTimeStamp else {
                print("[InternalInstrumentsVC] New report is older than current")
                return
            }
            
            let altitudeChange = Report.altitudeGainPerSecond(oldestReport: latestReport, newestReport: report) * 60
            let metersPerMinute = altitudeChange *  0.3048
            verticalSpeedIndicator.value = Int(metersPerMinute)
            altitudeChangeLabel.text = "\(Int(metersPerMinute) ) mpm"
        }
        
        print("[InternalInstrumentsVC] Updated")
        
        self.altitudeLabel.text = "\(report.altitudeInMeters)m"
        self.secondaryAltitudeLabel.text = "\(report.altitude)ft"
        
        speedLabel.text = "\(report.speedInKilometersPerHour)kph"
        secondarySpeedLabel.text = "\(report.speed)kts"
        
        dataBeaconView.alpha = 1.0;
        headingLabel.text = "\(report.course)°"
        tempLabel.text = "\(report.internalTempC) °C"
        iridiumSatsLabel.text = "\(report.satModemSignal)"
        distanceLabel.text = "-"
        batteryLabel.text = "\(report.batteryLevel)%"
        gpsQualityLabel.text = "\(report.horizontalPrecision)"
        gpsSatsLabel.text  = "\(report.satellitesInView)"
        
        var sourceString = "Cellular"
        if report.originator == .satellite {
            sourceString = "Satellite"
        }
        
        sourceLabel.text = sourceString
        
        
        DispatchQueue.main.async {
            self.battIndicator.value = report.batteryLevel
            
            let inverseHDOP = (self.hdopIndicator.maxValue - report.horizontalPrecision)
            self.hdopIndicator.value = inverseHDOP
        }
        
        
        
        view.layer .removeAllAnimations()
        UIView.animate(withDuration: 50) {
            self.dataBeaconView.alpha = 0.0
        }
        
        latestReport = report
        updateLastReportTime()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataBeaconView.layer.cornerRadius = dataBeaconView.bounds.size.width / 2
        dataBeaconView.layer.shadowColor = UIColor.green.cgColor
        dataBeaconView.layer.shadowOffset = CGSize.zero
        dataBeaconView.layer.shadowRadius = 5
        dataBeaconView.layer.shadowOpacity = 1.0
        
        battIndicator.indicatorDirection = .horizontal
        battIndicator.indicatorType = .bar
        battIndicator.redRange = 0.0...20
        battIndicator.yellowRange = 21...40
        battIndicator.minimumIndication = 7
        
        hdopIndicator.indicatorDirection = .horizontal
        hdopIndicator.indicatorType = .bar
        hdopIndicator.minimumIndication = 7
        hdopIndicator.maxValue = 350

        verticalSpeedIndicator.indicatorDirection = .horizontal
        verticalSpeedIndicator.indicatorType = .needle
        verticalSpeedIndicator.minimumIndication = 1
        verticalSpeedIndicator.minValue = -700
        verticalSpeedIndicator.maxValue = 700
        
        
        hdopIndicator.redRange = 0...20 //501-2000 (1499)
        hdopIndicator.yellowRange = 21...50 // 300-500 (1500-1700)
//
        
        
        
        hdopIndicator.minimumIndication = 5
//        hdopIndicator.maxValue = 50
//        hdopIndicator.minValue = 1
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshTimer = Timer(timeInterval: refreshTimeReportsEvery, target: self, selector: #selector(updateLastReportTime), userInfo: [], repeats: true)
        RunLoop.main.add(refreshTimer!, forMode: RunLoopMode.commonModes)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        refreshTimer!.invalidate()
    }
    
    // ======================================================
    @objc func updateLastReportTime() {
        if let report = latestReport {
            self.timeAgoLabel.text = "[\(report.gpsTimeStamp.timeAgo().uppercased())]"
        }
    }
    
    func clearLatestReport() {
        self.latestReport = nil
    }

}
