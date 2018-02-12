//
//  DashboardViewController.swift
//  GroundControl
//
//  Created by Rodrigo Chousal on 2/9/18.
//  Copyright © 2018 Movic Technologies. All rights reserved.
//

import UIKit

protocol DashboardDelegate {
    func shouldTogglePanelView()
    func shouldShowPanelView()
    func shouldHidePanelView()
}

class DashboardViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var toggleDashboardButton: UIButton!
    @IBOutlet weak var capsuleStateView: UIView!
    @IBOutlet weak var serverStatusLabel: UILabel!
    
    var report: Report = Report(rawString: "")
    var delegate: DashboardDelegate?
    
    enum ServerConnectionStatus {
        case connected
        case disconnected
    }
    
    var internalsPage = DashboardPage(frame: CGRect(x: 0, y: 0, width: 0, height: 0), pageTitle: "FLIGHT COMPUTER INTERNALS")
    // var externalsPage = DashboardPage(frame: CGRect(x: 0, y: 0, width: 0, height: 0), pageTitle: "FLIGHT COMPUTER EXTERNALS")
    // var terminalPage = DashboardPage(frame: CGRect(x: 0, y: 0, width: 0, height: 0), pageTitle: "COMMUNICATION TERMINAL")
    // var commandsPage = DashboardPage(frame: CGRect(x: 0, y: 0, width: 0, height: 0), pageTitle: "ACTION COMMANDS")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let x = view.frame.width*0.03
        let y = toggleDashboardButton.frame.height + x
        let width = view.frame.width - (2*x)
        let height = 510 - (toggleDashboardButton.frame.height + capsuleStateView.frame.height + 2*x) // FIXME: 510 should be superview's height!! For later, incorporate all views into storyboard for auto-layout.
        
        internalsPage.frame = CGRect(x: x, y: y, width: width, height: height)
        // externalsPage.frame = CGRect(x: x, y: y, width: width, height: height)
        // terminalPage.frame = CGRect(x: x, y: y, width: width, height: height)
        // commandsPage.frame = CGRect(x: x, y: y, width: width, height: height)
        
        view.addSubview(internalsPage)
        
        capsuleStateView.frame = CGRect(x: 0.0, y: 510.0, width: view.frame.width, height: capsuleStateView.frame.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - PUBLIC FUNCTIONS
    
    public func setReport(_ incomingReport: Report) {
        report = incomingReport
        
        print("RAW: \(report.rawReport)")
        print("RT: \(report.reportType)")
        
        if (report.reportType == .pulse) {
            
            let altitude = String(report.altitude)
            let speed = String(report.speed)
            let battery = String(report.batteryLevel)
            let temperature = String(report.internalTempC)
            let gps = String(report.horizontalPrecision)
            let sat = String(report.satModemSignal)
            let course = String(report.course)
            let sonar = "-"
            
            let info = ["Altitude" : altitude,
                        "Speed" : speed,
                        "Battery" : battery,
                        "Temperature" : temperature,
                        "GPS Quantity" : gps,
                        "Satellite Modem Signal" : sat,
                        "Course" : course,
                        "Sonar Distance" : sonar]
            
            internalsPage.setUp(withInfo: info)
        }
    }
    
    public func setServerStatus(_ serverStatus: ServerConnectionStatus) {
        switch serverStatus {
        case .connected:
            capsuleStateView.backgroundColor = UIColor(red: 122/255, green: 229/255, blue: 124/255, alpha: 1.0)
            serverStatusLabel.text = "CAPSULE ONLINE"
        case .disconnected:
            capsuleStateView.backgroundColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
            serverStatusLabel.text = "CAPSULE OFFLINE"
        }
    }
    
    public func setMessageCount(_ count:Int) {
        // Need to insert label, reference it and change to this value
        // networkMessageCountLabel.text =  "\(count) ✉️"
    }
    
    // MARK: - UITextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("SHOULD HIDE KEYBOARD!")
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func toggleDashboard(_ sender: Any) {
        delegate?.shouldTogglePanelView()
        if toggleDashboardButton.titleLabel?.text == "SHOW DASHBOARD" {
            toggleDashboardButton.setTitle("HIDE DASHBOARD", for: .normal)
        } else {
            toggleDashboardButton.setTitle("SHOW DASHBOARD", for: .normal)
        }
    }
    
}
