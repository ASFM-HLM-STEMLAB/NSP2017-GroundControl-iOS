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
    var externalsPage = DashboardPage(frame: CGRect(x: 0, y: 0, width: 0, height: 0), pageTitle: "FLIGHT COMPUTER EXTERNALS")
    var terminalPage = DashboardPage(frame: CGRect(x: 0, y: 0, width: 0, height: 0), pageTitle: "COMMUNICATION TERMINAL")
    var commandsPage = DashboardPage(frame: CGRect(x: 0, y: 0, width: 0, height: 0), pageTitle: "ACTION COMMANDS")
    var pageNumber = 1
    
    var notebookView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftSwipeRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        self.view.addGestureRecognizer(leftSwipeRecognizer)
        leftSwipeRecognizer.direction = .left
        
        let rightSwipeRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        self.view.addGestureRecognizer(rightSwipeRecognizer)
        rightSwipeRecognizer.direction = .right

        let x = view.frame.width*0.03
        let y = toggleDashboardButton.frame.height + x
        let width = view.frame.width - (2*x)
        let height = 510 - (toggleDashboardButton.frame.height + capsuleStateView.frame.height + 2*x) // FIXME: 510 should be superview's height!! For later, incorporate all views into storyboard for auto-layout.
        
        internalsPage.frame = CGRect(x: 0, y: 0, width: width, height: height)
        externalsPage.frame = CGRect(x: (width + 2*x), y: 0, width: width, height: height)
        terminalPage.frame = CGRect(x: externalsPage.frame.origin.x + (width + 2*x), y: y, width: width, height: height)
        commandsPage.frame = CGRect(x: terminalPage.frame.origin.x + (width + 2*x), y: y, width: width, height: height)
        
        notebookView.frame = CGRect(x: x, y: y, width: self.view.frame.width*4, height: height)
        notebookView.addSubview(internalsPage)
        notebookView.addSubview(externalsPage)
        notebookView.addSubview(terminalPage)
        notebookView.addSubview(commandsPage)
        
        view.addSubview(notebookView)
        
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
            
            let internalsInfo = ["Altitude" : altitude,
                        "Speed" : speed,
                        "Battery" : battery,
                        "Temperature" : temperature,
                        "GPS Quantity" : gps,
                        "Satellite Modem Signal" : sat,
                        "Course" : course,
                        "Sonar Distance" : sonar]
            
            internalsPage.setUp(withInfo: internalsInfo)
            externalsPage.setUp(withInfo: internalsInfo)
            terminalPage.setUp(withInfo: internalsInfo)
            commandsPage.setUp(withInfo: internalsInfo)
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
    
    // MARK: - UIGestureRecognizer + Delegate
    
    @objc func handleSwipe(gestureRecognizer: UISwipeGestureRecognizer) {
        
        let animationDuration = 1.0
        let delay = 0.0
        let damping: CGFloat = 0.5
        let initialSpringVelocity: CGFloat = 0.4
        
        if gestureRecognizer.direction == .left && self.pageNumber != 4 {
            
            let left = CGAffineTransform(translationX: -(CGFloat(pageNumber)*self.view.frame.width), y: 0)
            UIView.animate(withDuration: animationDuration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: initialSpringVelocity, options: [], animations: {
                self.notebookView.transform = left
                self.view.layoutIfNeeded()
                self.notebookView.updateConstraintsIfNeeded()
                
                self.pageNumber += 1
                
            }, completion: nil)
            
            print("Swiped Left! Page number now \(pageNumber)")
            
        } else if gestureRecognizer.direction == .right && self.pageNumber != 1 {
            
            let right = CGAffineTransform(translationX: -(CGFloat(pageNumber-2)*self.view.frame.width), y: 0)
            UIView.animate(withDuration: animationDuration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: initialSpringVelocity, options: [], animations: {
                self.notebookView.transform = right
                self.view.layoutIfNeeded()
                self.notebookView.updateConstraintsIfNeeded()
                
                self.pageNumber -= 1
                
            }, completion: nil)
            
            print("Swiped Right! Page number now \(pageNumber)")
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func toggleDashboard(_ sender: Any) {
        delegate?.shouldTogglePanelView()
        if toggleDashboardButton.titleLabel?.text == "SHOW DASHBOARD" {
            toggleDashboardButton.setTitle("HIDE DASHBOARD", for: .normal)
        } else {
            toggleDashboardButton.setTitle("SHOW DASHBOARD", for: .normal)
        }
    }
    
}
