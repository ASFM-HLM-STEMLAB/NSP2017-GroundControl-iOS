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
    var reportDetailViewController:ReportInfoViewController?
    
    //IVars
    var infoViewShowed = true
    var reports = [Report]()
    let notificationCenter = NotificationCenter.default
    
    //IBOutlets (represent a view)
    @IBOutlet weak var reportInfoView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var infoButton: UIButton! //Used to open or close the extended ReportInfoView
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    
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
        hideDetails()
        SocketCenter.connect()
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
            self.getAllReports()
        }
        
        //When we disconnect we change the label to let the user know.
        notificationCenter.addObserver(forName:SocketCenter.socketDisconnectedNotification, object: nil, queue: nil) { (notification) in
            self.reportDetailViewController?.setServerStatus(.disconnected)
        }                
        
        //When we get a .response type of message we show it in the terminal as a raw string with a < to signify incoming.
        notificationCenter.addObserver(forName:SocketCenter.socketResponseNotification, object: nil, queue: nil) { (notification) in
            if let response = notification.userInfo?["response"] as? String {
                self.reportDetailViewController?.addLineToTerminal("< \(response)")
            }
        }
        
        
    }
    
    deinit {
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
        polylineRenderer.strokeColor = UIColor.blue
        polylineRenderer.alpha = 0.3
        polylineRenderer.lineWidth = 2
        polylineRenderer.lineDashPattern = [2,5]
        
        return polylineRenderer        
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        //Everytime the map is updated we call the following method to update our distance (device) to the capsule coord.
        updateDistanceLabel()
    }
}


// ---------------------------------------------------
// MARK: MAP Plotting Methods and Helpers
extension MapViewController {
    func addReport(_ report:Report) {        
        if report.reportType != .unknown {
            reports.append(report)
            plotAppendReportsInMap()
            self.reportDetailViewController?.setMessageCount(reports.count)
            self.reportDetailViewController?.setReport(report)
        }
    }
    
    func plotAppendReportsInMap() {
        
        let annotations = reports.map { (report) -> MapAnnotation in
            return report.mapAnnotation
        }
        
        let coordinates = reports.map { (report) -> CLLocationCoordinate2D in
            return report.mapAnnotation.coordinate
        }
        
        if let lastAnnotation = annotations.last {
            mapView.addAnnotation(lastAnnotation)
        }
        
        if coordinates.count >= 2 {
            let lastPoint1 = coordinates[coordinates.count-1]
            let lastPoint2 = coordinates[coordinates.count-2]
            let polyline = MKPolyline(coordinates: [lastPoint1, lastPoint2], count: 2)
            self.mapView.add(polyline, level: .aboveRoads)
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
        
        let annotations = reports.map { (report) -> MapAnnotation in
            return report.mapAnnotation
        }
        
        let coordinates = reports.map { (report) -> CLLocationCoordinate2D in
            return report.mapAnnotation.coordinate
        }
        
        mapView.addAnnotations(annotations)
        
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        self.mapView.add(polyline, level: .aboveRoads)
        
        
        mapView.showAnnotations(annotations, animated: true)
        updateDistanceLabel()
        
    }
    
    func getAllReports() {
        self.reports = [Report]() //Initialize the array with a blank one.
        SocketCenter.getAllReports { (data) in //Ask the SocketCenter singleton to get all past reports.
            if let reports = data as? [Report] {
                self.reports = reports
                self.plotReportsInMap()
                self.reportDetailViewController?.setMessageCount(reports.count)
                if let lastReport = reports.last {
                    self.reportDetailViewController?.setReport(lastReport)
                }
                self.updateLastReportTime()
            }
        }
    }
    
    //Use math to calculate distance of device (GPS) to last report location.
    func calculateDistanceFromLastPoint() -> CLLocationDistance {
        let l1 = self.mapView.userLocation.coordinate
        if let l2 = self.reports.last?.mapAnnotation.coordinate {
            let loc1 = CLLocation(latitude: l1.latitude, longitude: l1.longitude)
            let loc2 = CLLocation(latitude: l2.latitude, longitude: l2.longitude)
            let distance = loc2.distance(from: loc1)
            return distance
        }
        
        return 0
    }
    
    func updateDistanceLabel() {
        var units = "m"
        let distanceInMeters = calculateDistanceFromLastPoint()
        var finalDistance = distanceInMeters
        
        if distanceInMeters >= 1000 {
            units = "km"
            finalDistance = distanceInMeters / 1000
        }
        
        let labeltext = String(format: "%.0f %@", finalDistance, units)        
        self.distanceLabel.text = labeltext
    }
    
    func updateLastReportTime() {
        if let lastTimeStamp =  self.reports.last?.gpsTimeStamp {
            self.lastUpdatedLabel.text = lastTimeStamp.toReadableString()
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
        let annotations = reports.map { (report) -> MapAnnotation in
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
}


