//
//  ReportInfoViewController.swift
//  GroundControl
//
//  Created by Francisco Lobo on 11/26/17.
//  Copyright © 2017 Movic Technologies. All rights reserved.
//

import UIKit


//This VIEWCONTROLLER will show a REPORT and control data TO THE SERVER

// TODO:
// Abstract responsability in multiple controllers [NO MASSIVE VIEW CONTROLLER]!!

protocol ReportInfoDelegate {
    func shouldTogglePanelView()
}

class ReportInfoViewController: UIViewController {
    enum TransmitMode {
        case cellular
        case sattelite
    }
    
    @IBOutlet weak var transmitModeButton: UIButton!
    @IBOutlet weak var serverStatusLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var transmitModeSwitch: UIButton!
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var networkMessageCountLabel: UILabel!
    @IBOutlet weak var battLevelLabel: UILabel!
    @IBOutlet weak var internalTempLabel: UILabel!
    @IBOutlet weak var sonarDistanceLabel: UILabel!
    @IBOutlet weak var gpsSignalLabel: UILabel!
    @IBOutlet weak var satcomSignalLabel: UILabel!
    @IBOutlet weak var terminalInput: UITextField!
    @IBOutlet weak var terminalTextView: UITextView!
    @IBOutlet weak var tempIndicator: GraphicalIndicator!
    @IBOutlet weak var climbIndicator: GraphicalIndicator!
    @IBOutlet weak var battIndicator: GraphicalIndicator!
    
    
    private var previousAltitude:Int = 0
    var delegate: ReportInfoDelegate?
    
    private var transmitMode = TransmitMode.cellular {
        didSet {
            if transmitMode == .cellular {
                self.transmitModeButton.setTitle("CELL", for: .normal)
            } else {
                self.transmitModeButton.setTitle("SAT", for: .normal)
            }
        }
    }
 
    
    enum ServerConnectionStatus {
        case connected
        case disconnected
    }
    
    override func viewDidLoad() {
        //Set initial parameters to instruments (indicators and labels)
        super.viewDidLoad()
        climbIndicator.indicatorDirection = .vertical
        climbIndicator.indicatorType = .needle
        
        tempIndicator.indicatorType = .needle
        tempIndicator.indicatorDirection = .horizontal
        tempIndicator.redRange = 0...48
        tempIndicator.yellowRange = 48...52
        
        battIndicator.indicatorDirection = .horizontal
        battIndicator.indicatorType = .bar
        battIndicator.yellowRange = 0.0...0.0
        battIndicator.redRange = 0.0...20
        
        battIndicator.minimumIndication = 7
        climbIndicator.minimumIndication = 1
        climbIndicator.minValue = -3000
        climbIndicator.maxValue = 3000
        tempIndicator.minimumIndication = 1
        tempIndicator.minValue =  -110 //DegC
        tempIndicator.maxValue =  70 //DegC
        
        
        climbIndicator.indicatorColor = UIColor.white
        tempIndicator.indicatorColor = UIColor.white
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
        
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.terminalInput.isFirstResponder {
                self.view.frame.origin.y = -keyboardSize.height
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        
        battIndicator.value = 0
        climbIndicator.value = 50
        tempIndicator.value = 50
    }

    
    func sendMessageToSocket(message:String) {
        addLineToTerminal("> " + message)
        SocketCenter.sendMessage(event: "TXC", data: [message])
    }
}


extension ReportInfoViewController {
    @IBAction func transmitModeButtonPressed(_ sender: Any) {
        if transmitMode == .cellular {
            self.transmitMode = .sattelite
        } else {
            self.transmitMode = .cellular
        }
    }
    
    @IBAction func buzzerButtonPressed(_ sender: Any) {
        sendMessageToSocket(message: "buzzeron")
        
    }
    
    @IBAction func sendLineButtonPressed(_ sender: Any) {
        if let input = self.terminalInput.text {
            sendMessageToSocket(message:input)
        }
    }
    
    @IBAction func cmuteButtonPressed(_ sender: Any) {
           sendMessageToSocket(message:"cellmute")
    }
    @IBAction func heatButtonPressed(_ sender: Any) {
    }
    @IBAction func smuteButtonPressed(_ sender: Any) {
        sendMessageToSocket(message:"satmute")
    }
    
    @IBAction func hideButtonToggle(_ sender: Any) {
        delegate?.shouldTogglePanelView()
    }
    
}


extension ReportInfoViewController {
    public func setReport(_ report:Report) {
        altitudeLabel.text = String(report.altitude)
        print("RAW: \(report.rawReport)")
        print("RT: \(report.reportType)")
        
        if (report.reportType == .pulse) {
            speedLabel.text = String(report.speed)
            courseLabel.text = "\(report.course)°"
            battLevelLabel.text = "\(report.batteryLevel * 10)%"
            internalTempLabel.text = "\(report.internalTempC)°C"
            sonarDistanceLabel.text = "-"
            gpsSignalLabel.text = "\(report.horizontalPrecision)"
            satcomSignalLabel.text = "\(report.satModemSignal)"
            
            self.battIndicator.value = report.batteryLevel * 10
            self.tempIndicator.value = report.internalTempC
            
            if (previousAltitude == 0) {
                previousAltitude = report.altitude
            }
            climbIndicator.value = report.altitude - previousAltitude
            previousAltitude = report.altitude
        }
    }
    
    public func addLineToTerminal(_ line:String) {
        terminalTextView.text = self.terminalTextView.text + "\n" + line        
        let bottom = self.terminalTextView.contentSize.height - self.terminalTextView.bounds.size.height
        self.terminalTextView.setContentOffset(CGPoint(x: 0, y: bottom), animated: true)
    }
    
    public func setServerStatus(_ serverStatus:ServerConnectionStatus) {
        switch serverStatus {
        case .connected:
                serverStatusLabel.textColor = UIColor(red: 228/255, green: 255/255, blue: 101/255, alpha: 1)
                serverStatusLabel.text = "ONLINE"
        case .disconnected:
                serverStatusLabel.textColor = UIColor(red: 209/255, green: 88/255, blue: 23/255, alpha: 1)
                serverStatusLabel.text = "OFFLINE"
        }
    }
    
    public func setMessageCount(_ count:Int) {
        networkMessageCountLabel.text =  "\(count) ✉️"
    }
    
}
