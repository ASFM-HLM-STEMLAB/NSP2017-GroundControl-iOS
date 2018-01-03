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
    
    @IBOutlet weak var reportInfoView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    
    // ======================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self;
        
        mapView.showsUserLocation = true
        if ownshipTrackingEnabled {
            mapView.userTrackingMode = .followWithHeading
        }
        
        subscribeForSystemNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hideDetails()
    }
    
    func subscribeForSystemNotifications() {
        notificationCenter.addObserver(forName:SocketCenter.newMessageNotification, object: nil, queue: nil) { (notification) in
            if var report = notification.userInfo?["report"] as? Report {
                report.index = self.reports.count
                self.addReport(report)
                self.updateLastReportTime()
            }
        }
        
        notificationCenter.addObserver(forName:SocketCenter.socketConnectedNotification, object: nil, queue: nil) { (notification) in
            self.reportDetailViewController?.setServerStatus(.connected)
            self.getAllReports()
        }
        
        notificationCenter.addObserver(forName:SocketCenter.socketDisconnectedNotification, object: nil, queue: nil) { (notification) in
            self.reportDetailViewController?.setServerStatus(.disconnected)
        }                
        
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
        }
    }
    
}


// ---------------------------------------------------
// MARK: InfoPanel Methods and animations
extension MapViewController {
    func showDetails() {
        self.view.layoutIfNeeded()
        
        let top = CGAffineTransform(translationX: 0, y: 0)
        infoViewShowed = true
        UIView.animate(withDuration: infoViewAnimationTime, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: [], animations: {
            self.reportInfoView.transform = top
            self.view.layoutIfNeeded()
            self.reportInfoView.updateConstraintsIfNeeded()
        }, completion: nil)
    }
    
    func hideDetails() {
        self.view.layoutIfNeeded()
        self.reportInfoView.updateConstraintsIfNeeded()
        let top = CGAffineTransform(translationX: 0, y: reportInfoView.bounds.height-40)
        infoViewShowed = false
        UIView.animate(withDuration: infoViewAnimationTime, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: [], animations: {
            self.reportInfoView.transform = top
            self.view.layoutIfNeeded()
            self.reportInfoView.updateConstraintsIfNeeded()
        }, completion: nil)
        
    }
}


// ---------------------------------------------------
// MARK: MKMapViewDelegate Methods
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
        updateDistanceLabel()
    }
}


// ---------------------------------------------------
// MARK: MAP Plotting Methods and Helpers
extension MapViewController {
    func addReport(_ report:Report) {
        reports.append(report)
        plotAppendReportsInMap()
        self.reportDetailViewController?.setMessageCount(reports.count)
        self.reportDetailViewController?.setReport(report)
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
        self.reports = [Report]()
        SocketCenter.getAllReports { (data) in
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
        if let lastTimeStamp = self.reports.last?.gpsTimeStamp {
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


