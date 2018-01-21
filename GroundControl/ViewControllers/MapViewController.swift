//
//  MapViewController.swift
//  GroundControl
//
//  Created by Francisco Lobo on 11/26/17.
//  Copyright © 2017 Movic Technologies. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

// ---------------------------------------------------
// MARK: UIViewController LifeCycle and Default Methods
class MapViewController: UIViewController  {    
    
    //SETTINGS
    let regionRadius: CLLocationDistance = 1000
    var ownshipTrackingEnabled = true
    let infoViewAnimationTime = 0.3
    let locationManager = CLLocationManager()
    
    //IVars
    var infoViewShowed = true
    var reports = [Report]()
    let notificationCenter = NotificationCenter.default
    var ownshipLine: MKPolyline?
    var reportDetailViewController:ReportInfoViewController?
    
    var drawingOwnShipPlot = false //Keep track of what we are rendering on the screen to select the type of line we are going to draw
    
    //IBOutlets (represent a view)
    @IBOutlet weak var reportInfoView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var infoButton: UIButton! //Used to open or close the extended ReportInfoView
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    
    @IBOutlet weak var onlineStatusLabel: UILabel!
    @IBOutlet weak var lastUpdatedGPSLabel: UILabel!
    
    // ======================================================
    override func viewDidLoad() {
        //Let's setup everything for the VC
        super.viewDidLoad()
        mapView.delegate = self;
        
        mapView.showsUserLocation = true
        if ownshipTrackingEnabled {
            mapView.userTrackingMode = .followWithHeading
        }
        
        //Only call this once for every instance of this VC
        subscribeForSystemNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.onlineStatusLabel.text = "CONNECTING..."
        self.onlineStatusLabel.textColor = UIColor(red: 0.9, green:0.71, blue:0.01, alpha:1)
        hideDetails()
        SocketCenter.connect()
        //iOS Devices need user permission for app to access device locations
        locationManager.requestAlwaysAuthorization()
    }
    
    func subscribeForSystemNotifications() {
        //Let's subscribe to events we care for this particular VC
        
        //Everytime we receive a new message we:
        notificationCenter.addObserver(forName:SocketCenter.newMessageNotification, object: nil, queue: nil) { (notification) in
            if var report = notification.userInfo?["report"] as? Report {
                report.index = self.reports.count
                //Add a report to the report array and show the details)
                self.addReport(report)
                self.updateLastReportTime()
            }
        }
        
        //Everytime we connect we change the connection label to let the user know we are connected.
        // AND WE GET ALL THE REPORTS in the history.
        notificationCenter.addObserver(forName:SocketCenter.socketConnectedNotification, object: nil, queue: nil) { (notification) in
            self.reportDetailViewController?.setServerStatus(.connected)
            self.onlineStatusLabel.text = "ONLINE"
            self.onlineStatusLabel.textColor = UIColor(red: 0.2, green:0.8, blue:0.2, alpha:1)
            self.getAllReports()
        }
        
        //When we disconnect we change the label to let the user know.
        notificationCenter.addObserver(forName:SocketCenter.socketDisconnectedNotification, object: nil, queue: nil) { (notification) in
            self.reportDetailViewController?.setServerStatus(.disconnected)
            self.onlineStatusLabel.text = "OFFLINE"
            self.onlineStatusLabel.textColor = UIColor(red: 1, green:0.2, blue:0.2, alpha:1)
        }
        
        
        //When we get a .response type of message we show it in the terminal as a raw string with a < to signify incoming.
        notificationCenter.addObserver(forName:SocketCenter.socketResponseNotification, object: nil, queue: nil) { (notification) in
            if let response = notification.userInfo?["response"] as? String {
                self.reportDetailViewController?.addLineToTerminal("< \(response)")
            }
        }
        
        
    }
    
    deinit { //Should not happen, but just in case we clear any weak refs.
        notificationCenter.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "reportDetailView") {
            reportDetailViewController = segue.destination as? ReportInfoViewController
            reportDetailViewController?.delegate = self
        }
    }
    
}


// ---------------------------------------------------
// MARK: InfoPanel Methods and animations
extension MapViewController {
    func showDetails() {  //Animate the ReportInfoView panel up.
        self.view.layoutIfNeeded()
        
        let top = CGAffineTransform(translationX: 0, y: 0)
        infoViewShowed = true
        UIView.animate(withDuration: infoViewAnimationTime, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: [], animations: {
            self.reportInfoView.transform = top
            self.view.layoutIfNeeded()
            self.reportInfoView.updateConstraintsIfNeeded()
        }, completion: nil)
    }
    
    func hideDetails() { //Animate the ReportInfoView panel down.
        self.view.layoutIfNeeded()
        self.reportInfoView.updateConstraintsIfNeeded()
        let top = CGAffineTransform(translationX: 0, y: reportInfoView.bounds.height-65)
        infoViewShowed = false
        UIView.animate(withDuration: infoViewAnimationTime, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: [], animations: {
            self.reportInfoView.transform = top
            self.view.layoutIfNeeded()
            self.reportInfoView.updateConstraintsIfNeeded()
        }, completion: nil)
    }
    
    func toggleDetails() {
        if infoViewShowed {
            self.hideDetails()
        } else {
            self.showDetails()
        }
    }
}


// ---------------------------------------------------
// MARK: MKMapViewDelegate Methods (Conforming to the delegate to allow us to show pins in the map)
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        if drawingOwnShipPlot == false {
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.alpha = 0.3
            polylineRenderer.lineWidth = 2.5
            polylineRenderer.lineDashPattern = [2,5]
        } else {
            polylineRenderer.strokeColor = UIColor.lightGray
            polylineRenderer.alpha = 0.5
            polylineRenderer.lineWidth = 0.5
        }
        return polylineRenderer        
    }
    
    func getAnnotationIdentifier(forReport report:Report) -> String {
        var annotationIdentifier = "PinDotBlue"
        
        if report == self.reports.last {
            switch report.missionStage
            {
            case .climb:
                annotationIdentifier = "PinCapsuleBalloon"
            case .descent:
                annotationIdentifier = "PinCapsuleParachute"
            case .recovery:
                annotationIdentifier = "PinCapsuleRecovery"
            case .ground:
                annotationIdentifier = "PinCapsuleParachute"
            case .unknown:
                annotationIdentifier = "PinCapsuleBalloon"
            }
        } else if report == self.reports.first {
            annotationIdentifier = "PinDotRed"
        }
        
        return annotationIdentifier
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        //Everytime the map is updated we call the following method to update our distance (device) to the capsule coord.
        updateDistanceLabel()
        updatePlotToOwnShip()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        
        guard let report = getReport(from: annotation) else {
            return nil
        }
        
        let annotationIdentifier = getAnnotationIdentifier(forReport: report)
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        annotationView?.collisionMode = .circle
        annotationView?.displayPriority = .defaultLow
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            let image = UIImage(named: annotationIdentifier)
            annotationView?.image = image
        } else {
            annotationView?.annotation = annotation
        }
        
        let transform = CGAffineTransform.init(scaleX: 0.4, y: 0.4)
        annotationView?.transform = transform
        annotationView?.canShowCallout = true
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        let transform = CGAffineTransform.init(scaleX: 0.4, y: 0.4)
        UIView.animate(withDuration: 0.2) {
            view.transform = transform
        }
        
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let transform = CGAffineTransform.init(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 0.2) {
            view.transform = transform
        }
        
        if let annotation = view.annotation {
            
            
            let idx = self.reports.index  { $0.mapAnnotation as MKAnnotation === annotation }
            if let index = idx {
                let report = reports[index]
                
                let formattedDistance = formatDistanceToMetric(from: calculateDistance(from: report.mapAnnotation))
                
                
                var kind = "Other"
                if (report.reportType == .pulse) {
                    kind = "Pulse"
                }
                
                var source = "Cell"
                if (report.originator == .satellite) {
                    source = "Sat"
                }
                
                
                let body = """
                Lat: \(report.latitude) - Lon: \(report.longitude)
                Alt: \(report.altitude) ft - Dis: \(formattedDistance)
                Hdg: \(report.course)° - Spd: \(report.speed) kts
                Typ: \(kind) - Ogn: \(source)
                """
                
                
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 1000, height: 0))
                label.numberOfLines = 0
                label.text = body
                view.detailCalloutAccessoryView = label
                label.sizeToFit()
                
            }
            
        }
        
        
        
    }
}


// ---------------------------------------------------
// MARK: MAP Plotting Methods and Helpers
extension MapViewController {
    func addReport(_ report:Report) {
        if report.reportType != .unknown {
            reports.append(report)
            
            sortReportList()
            reports = self.withoudDuplicates(from: reports)
            
            plotAppendReportsInMap()
            self.reportDetailViewController?.setMessageCount(reports.count)
            self.reportDetailViewController?.setReport(report)
        }
    }
    
    func plotAppendReportsInMap() {
        
        let annotations = reports.flatMap { (report) -> MapAnnotation? in
            if (report.coordinate.latitude == 0 || report.coordinate.longitude == 0) {
                return nil
            }
            
            return report.mapAnnotation
        }
        
        let coordinates = reports.flatMap { (report) -> CLLocationCoordinate2D? in
            if (report.coordinate.latitude == 0 || report.coordinate.longitude == 0) {
                return nil
            }
            return report.mapAnnotation.coordinate
        }
        
        if let newAnnotation = annotations.last {
            mapView.addAnnotation(newAnnotation)
        }
        
        if coordinates.count >= 2 {
            let lastPoint1 = coordinates[coordinates.count-1]
            let lastPoint2 = coordinates[coordinates.count-2]
            let polyline = MKPolyline(coordinates: [lastPoint1, lastPoint2], count: 2)
            self.mapView.add(polyline, level: .aboveRoads)
        }
        
        if reports.count > 1 {
            let lastTwoReports = reports.suffix(2)
            
            let oldLastAnnotationView = self.mapView.view(for: lastTwoReports.first!.mapAnnotation)
            let newLastAnnotationView = self.mapView.view(for: lastTwoReports.last!.mapAnnotation)
            
            oldLastAnnotationView?.image = UIImage(named:"PinDotBlue")
            newLastAnnotationView?.image = UIImage(named:getAnnotationIdentifier(forReport:lastTwoReports.last!))
        }
        
        if annotations.count >= 3 {
            mapView.showAnnotations(Array(annotations.suffix(3)), animated: true)
        } else {
            mapView.showAnnotations(annotations, animated: true)
        }
        updateDistanceLabel()
    }
    
    
    func plotReportsInMap() {
        //Remove all annotations from the map (pins) and redraw them all from the array and draw a line between them (dashed line)
        mapView.removeAnnotations(mapView.annotations)
        self.mapView.removeOverlays(mapView.overlays)
        
        sortReportList()
        reports = self.withoudDuplicates(from: reports)
        
        let annotations = reports.flatMap { (report) -> MapAnnotation? in
            if (report.coordinate.latitude == 0 || report.coordinate.longitude == 0) {
                return nil
            }
            return report.mapAnnotation
        }
        
        let coordinates = reports.flatMap { (report) -> CLLocationCoordinate2D? in
            if (report.coordinate.latitude == 0 || report.coordinate.longitude == 0) {
                return nil
            }
            return report.mapAnnotation.coordinate
        }
        
        mapView.addAnnotations(annotations)
        
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        self.mapView.add(polyline, level: .aboveRoads)
        
        mapView.showAnnotations(annotations, animated: true)
        updateDistanceLabel()
        updatePlotToOwnShip()
    }
    
    func updatePlotToOwnShip() {
        //jump
        if (self.reports.count > 0) {
            drawingOwnShipPlot = true
            if let ownShipLine = self.ownshipLine {
                mapView.remove(ownShipLine)
            }
            
            let coordinates = [self.reports.last!.coordinate, mapView.userLocation.coordinate]
            ownshipLine = MKPolyline(coordinates: coordinates, count: coordinates.count)
            mapView.add(ownshipLine!, level: .aboveRoads)
            drawingOwnShipPlot = false
        }
    }
    
    
    func getAllReports() {
        self.reports = [Report]() //Initialize the array with a blank one.
        
        SocketCenter.getAllReports { (data) in //Ask the SocketCenter singleton to get all past reports.
            if let reports = data as? [Report] {
                self.reports = reports
                self.sortReportList()
                self.reports = self.withoudDuplicates(from: reports)
                
                self.reportDetailViewController?.setMessageCount(reports.count)
                if let lastReport = reports.last {
                    self.reportDetailViewController?.setReport(lastReport)
                    if (lastReport.reportType != .pulse) {
                        for aReport in reports {
                            if aReport.reportType == .pulse {
                                self.reportDetailViewController?.setReport(aReport)
                            }
                        }
                    }
                }
                
                self.updateLastReportTime()
                self.plotReportsInMap()
            }
            
        }
    }
    
    func getReport(from annotation: MKAnnotation) -> Report? {
        let idx = self.reports.index  { $0.mapAnnotation as MKAnnotation === annotation }
        if let index = idx {
            let report = reports[index]
            return report
        }
        
        return nil
    }
    
    func sortReportList() {
        self.reports = self.reports.sorted(by: {
            if ($0.gpsTimeStamp < $1.gpsTimeStamp) {
                return true;
            }
            return false;
        })
    }
    
    func withoudDuplicates(from reports:[Report]) -> [Report] {
        var newReports = [Report]()
        
        for report in self.reports {
            if !newReports.contains(report) {
                newReports.append(report)
            }
        }
        
        return newReports
    }
    
    
    //Use math to calculate distance of device (GPS) to last report location.
    func calculateDistanceFromLastPoint() -> CLLocationDistance {
        if let lastAnnotation = self.reports.last?.mapAnnotation {
            return calculateDistance(from: lastAnnotation)
        }
        return 0
    }
    
    func calculateDistance(from mapAnnotation:MapAnnotation) -> CLLocationDistance {
        let l1 = self.mapView.userLocation.coordinate
        let l2 = mapAnnotation.coordinate
        let loc1 = CLLocation(latitude: l1.latitude, longitude: l1.longitude)
        let loc2 = CLLocation(latitude: l2.latitude, longitude: l2.longitude)
        let distance = loc2.distance(from: loc1)
        return distance
    }
    
    
    func formatDistanceToMetric(from meters: Double) -> String
    {
        var units = "m"
        var finalDistance = meters
        
        if meters >= 1000 {
            units = "km"
            finalDistance = meters / 1000
        }
        
        return String(format: "%.0f %@", finalDistance, units)
    }
    
    func updateDistanceLabel() {
        self.distanceLabel.text = formatDistanceToMetric(from: calculateDistanceFromLastPoint())
    }
    
    func updateLastReportTime() {
        if let lastTimeStamp =  self.reports.last?.serverTimeStamp {
            self.lastUpdatedLabel.text = "STS: \(lastTimeStamp.timeAgo().uppercased())"
        }
        
        if let lastTimeGPS =  self.reports.last?.gpsTimeStamp {
            self.lastUpdatedGPSLabel.text = "GTS: \(lastTimeGPS.toTimeReadableString())"
        }
    }
}


// ---------------------------------------------------
// MARK: IBActions (Buttons)
extension MapViewController {
    @IBAction func infoButtonPressed(_ sender: Any) {
        if (infoViewShowed) {
            hideDetails()
        } else {
            showDetails()
        }
    }
    
    @IBAction func allButtonPressed(_ sender: Any) {
        let annotations = reports.flatMap { (report) -> MapAnnotation? in
            if (report.coordinate.latitude == 0 || report.coordinate.longitude == 0) {
                return nil
            }
            
            return report.mapAnnotation
        }
        
        self.mapView.showAnnotations(annotations, animated: true)
    }
    
    @IBAction func meButtonPressed(_ sender: Any) {
        let region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, regionRadius, regionRadius)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func mapButtonPressed(_ sender: Any) {
        if mapView.mapType == .standard {
            mapView.mapType = .satellite
        } else {
            mapView.mapType = .standard
        }
    }
    
    @IBAction func reloadButtonPressed(_ sender: Any) {
        
        self.mapView.removeOverlays(self.mapView.overlays)
        self.mapView.removeAnnotations(self.mapView.annotations)
        getAllReports()
    }
    
}

extension MapViewController: ReportInfoDelegate {
    func shouldTogglePanelView() {
        toggleDetails()
    }
    
    func shouldHidePanelView() {
        hideDetails()
    }
    
    func shouldShowPanelView() {
        showDetails()
    }
}


