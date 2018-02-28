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
    let regionRadius: CLLocationDistance = 1000 //Miles
    var ownshipTrackingEnabled = true //Show our position in map
    let infoViewAnimationTime = 0.3 //Seconds
    let refreshTimeReportsEvery:TimeInterval = 1 //seconds
    
    //IVars
    let locationManager = CLLocationManager()
    var infoViewShowed = true
    var reports = [Report]()
    let notificationCenter = NotificationCenter.default
    var ownshipLine: MKPolyline?
//    var reportDetailViewController:ReportInfoViewController?
    var dashboardViewController:DashboardViewController?
    var instrumentsPageController:InstrumentsContainerViewController?
    
    var refreshTimer:Timer?
    
    var drawingOwnShipPlot = false //Keep track of what we are rendering on the screen to select the type of line we are going to draw
    
    //IBOutlets (represent a view)
    @IBOutlet weak var reportInfoView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var infoButton: UIButton! //Used to open or close the extended ReportInfoView
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    
    @IBOutlet weak var onlineStatusLabel: UILabel!
    @IBOutlet weak var lastUpdatedGPSLabel: UILabel!
    
    @IBOutlet weak var missionTimerLabel: UILabel!
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
        
        refreshTimer = Timer(timeInterval: refreshTimeReportsEvery, target: self, selector: #selector(updateLastReportTime), userInfo: [], repeats: true)
        RunLoop.main.add(refreshTimer!, forMode: RunLoopMode.commonModes)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        refreshTimer!.invalidate()
    }
    
    func subscribeForSystemNotifications() {
        //Let's subscribe to events we care for this particular VC
        
        //Everytime we receive a new message we:
        notificationCenter.addObserver(forName:SocketCenter.newMessageNotification, object: nil, queue: nil) { (notification) in
            if var report = notification.userInfo?["report"] as? Report {
                report.index = self.reports.count
                //Add a report to the report array and show the details)
                self.addReportToMap(report: report)
//                self.reportDetailViewController?.setReport(report)
//                self.reportDetailViewController?.setMessageCount(self.reports.count)
            }
        }
        
        //Everytime we connect we change the connection label to let the user know we are connected.
        // AND WE GET ALL THE REPORTS in the history.
        notificationCenter.addObserver(forName:SocketCenter.socketConnectedNotification, object: nil, queue: nil) { (notification) in
            self.dashboardViewController?.setServerStatus(.connected)
            self.instrumentsPageController?.setConnectionStatus(.connected)
            self.onlineStatusLabel.text = "ONLINE"
            self.onlineStatusLabel.textColor = UIColor(red: 0.2, green:0.8, blue:0.2, alpha:1)
            self.missionTimerLabel.textColor = UIColor(red: 0.310, green: 0.447, blue: 0.788, alpha: 1.00)
            self.getAllReports()
        }
        
        //When we disconnect we change the label to let the user know.
        notificationCenter.addObserver(forName:SocketCenter.socketDisconnectedNotification, object: nil, queue: nil) { (notification) in
            self.dashboardViewController?.setServerStatus(.disconnected)
            self.instrumentsPageController?.setConnectionStatus(.disconnected)
            self.onlineStatusLabel.text = "OFFLINE"
            self.onlineStatusLabel.textColor = UIColor(red: 1, green:0.2, blue:0.2, alpha:1)
            self.missionTimerLabel.textColor = UIColor(red: 0.310, green: 0.447, blue: 0.788, alpha: 0.50)
        }
        
        //When we get a .response type of message we show it in the terminal as a raw string with a < to signify incoming.
        notificationCenter.addObserver(forName:SocketCenter.socketResponseNotification, object: nil, queue: nil) { (notification) in
            if let response = notification.userInfo?["response"] as? String {
                print("TERMINAL INCOMING: \(response)" )
//                self.reportDetailViewController?.addLineToTerminal("< \(response)")
            }
        }
        
        notificationCenter.addObserver(forName:SocketCenter.timeSyncNotification, object: nil, queue: nil) { (notification) in
            if let time = notification.userInfo?["time"] as? Time {
               self.missionTimerLabel.text = time.timeString
            }
        }
    }
    
    deinit { //Should not happen, but just in case we clear any weak refs.
        notificationCenter.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "dashboardSegue") {
            dashboardViewController = segue.destination as? DashboardViewController
            dashboardViewController?.delegate = self
        }
        
        if (segue.identifier == "instrumentsSegue") {
            instrumentsPageController = segue.destination as? InstrumentsContainerViewController
            instrumentsPageController?.panelViewDelegate = self
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
        focusOnAllReportsOnMap()
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
    
    @IBAction func moreButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Login to continue", message: "", preferredStyle: .alert)
        
        let authenticateButton = UIAlertAction(title: "Continue", style: .default) { (action) in
            let usernameTextField = alert.textFields![0] as UITextField
            let passwordTextField = alert.textFields![1] as UITextField
            
            if usernameTextField.text == "me" && passwordTextField.text == "too" {
                self.instrumentsPageController?.allowRestrictedArea()
            }
            
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Username"
        }
        
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        
        alert.addAction(authenticateButton)
        alert.addAction(cancelButton)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func reloadButtonPressed(_ sender: Any) {
        getAllReports()
    }
    
}


extension MapViewController: PanelViewDelegate {
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

//Helpers
extension MapViewController {
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
    
    @objc func updateLastReportTime() {
        
        if let lastTimeStamp =  self.reports.last?.serverTimeStamp {
            self.lastUpdatedLabel.text = "STS: \(lastTimeStamp.toTimeReadableString()) [\(lastTimeStamp.timeAgo().uppercased())]"
        }
        
        if let lastTimeGPS =  self.reports.last?.gpsTimeStamp {
            self.lastUpdatedGPSLabel.text = "GTS: \(lastTimeGPS.toTimeReadableString()) [\(lastTimeGPS.timeAgo().uppercased())]"
        }
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
}







