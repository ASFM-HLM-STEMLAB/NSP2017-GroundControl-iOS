//
//  DashboardPage.swift
//  GroundControl
//
//  Created by Rodrigo Chousal on 2/9/18.
//  Copyright © 2018 Movic Technologies. All rights reserved.
//

import UIKit

class DashboardPage: UIView, UITextFieldDelegate {
    
    enum TransmitMode {
        case cellular
        case sattelite
    }
    
    var transmissionToggle = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    private var transmitMode = TransmitMode.cellular {
        didSet {
            if transmitMode == .cellular {
                self.transmissionToggle.setTitle("CELL", for: .normal)
            } else {
                self.transmissionToggle.setTitle("SAT", for: .normal)
            }
        }
    }
    
    var terminalEnabled = false
    var titleView: UIView = UIView()
    var pageTitle: String = ""
    var titleLabel: UILabel = UILabel()
    
    var terminalInput: UITextField?
    var terminalTextView: UITextView?
    
    init(frame: CGRect, pageTitle: String) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        self.pageTitle = pageTitle
        
        
        //        // Rounds top and bottom corners of dashboard page
        //        let path = UIBezierPath(roundedRect:bounds, byRoundingCorners:[.topLeft, .topRight, .bottomLeft, .bottomRight], cornerRadii: CGSize(width: 20, height:  20))
        //        let maskLayer = CAShapeLayer()
        //        maskLayer.path = path.cgPath
        //        layer.mask = maskLayer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: INFORMATION FUNCTIONS
    
    func setUp(withInfo info: [String : String]) {
        
        titleView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 0.12*frame.height)) // 12% of dashboard height
        titleView.backgroundColor = UIColor(red: 59/255, green: 49/255, blue: 49/255, alpha: 1.0)
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: titleView.frame.width, height: titleView.frame.height))
        titleLabel.text = pageTitle
        titleLabel.font = UIFont(name: "Avenir-Heavy", size: 20)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        titleView.addSubview(titleLabel)
        addSubview(titleView)
        
        if pageTitle == "COMMUNICATION TERMINAL" {
            print("Terminal Initiated...")
            setUpTerminal()
        }
        
        if pageTitle == "FLIGHT COMPUTER INTERNALS" || pageTitle == "FLIGHT COMPUTER EXTERNALS" {
            setUpInfo(info: info)
        } else if pageTitle == "COMMUNICATION TERMINAL" {
            print("Terminal Initiated...")
            setUpTerminal()
        } else if pageTitle == "ACTION COMMANDS" {
            setUpCommands()
        }
        
    }
    
    func setUpInfo(info:[String : String]) {
        var x : CGFloat = 0.0
        var y : CGFloat = titleLabel.frame.height
        let width = self.frame.width/2
        let  height = (self.frame.height - titleView.frame.height)/4
        
        var i = 0
        for (key, value) in info {
            
            // If even, then place on left side of dashboard.
            // We don't set y-value for right subsections because it is the same as left subsection.
            if (i % 2) == 0 {
                x = 0
                if i != 0 {
                    y += height
                }
            } else {
                x = width
            }
            
            let sectionView = DashboardSubsection(frame: CGRect(x: x, y: y, width: width, height: height))
            sectionView.title = key
            sectionView.info = value
            sectionView.updateLabels()
            
            self.addSubview(sectionView)
            
            i += 1
        }
    }
    
    // MARK: TERMINAL FUNCTIONS
    
    func setUpTerminal() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.terminalTextView = UITextView(frame: CGRect(x: 0, y: titleLabel.frame.height, width: self.frame.width, height: (self.frame.height - titleView.frame.height)*0.9))
        self.terminalInput = UITextField(frame: CGRect(x: 0, y: (titleLabel.frame.height + (terminalTextView?.frame.height)!), width: self.frame.width, height: (self.frame.height - titleView.frame.height)*0.1))
        
        if let input = self.terminalInput {
            
            input.delegate = self
            input.returnKeyType = .done
            input.font = UIFont(name: "Courier", size: 18)
            
            if let textView = self.terminalTextView {
                
                print("Setting Up Terminal!")
                
                textView.backgroundColor = .black
                textView.textColor = .white
                textView.font = input.font
                
                input.backgroundColor = .white
                input.textColor = .black
                
                addSubview(input)
                addSubview(textView)
            }
        }
    }
    
    @objc func keyboardWillHide() {
        frame.origin.y = 0
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        if let input = self.terminalInput {
            input.returnKeyType = .send
        }
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            frame.origin.y = -keyboardSize.height + 90
        }
    }
    
    func sendMessageToSocket(message:String) {
        addLineToTerminal("> " + message)
        SocketCenter.sendMessage(event: "TXC", data: [message])
    }
    
    public func addLineToTerminal(_ line:String) {
        
        if let terminal = terminalTextView {
            terminal.text = terminal.text + "\n" + line
            let bottom = terminal.contentSize.height - terminal.bounds.size.height
            terminal.setContentOffset(CGPoint(x: 0, y: bottom), animated: true)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        if let input = self.terminalInput?.text {
            sendMessageToSocket(message:input)
        }
        
        self.terminalInput?.text = ""
        self.terminalInput?.returnKeyType = .done
        
        return true
    }
    
    // MARK: COMMANDS FUNCTIONS
    
    func setUpCommands() {
        
        let width = self.frame.width/2
        let height = (self.frame.height - titleView.frame.height)/3
        
        let leftX: CGFloat = 0.0
        let rightX: CGFloat = self.frame.width/2
        
        let y1: CGFloat = titleLabel.frame.height
        let y2: CGFloat = height + y1
        let y3: CGFloat = height + y2
        
        transmissionToggle = UIButton(frame: CGRect(x: leftX, y: y1, width: width, height: height))
        let buzzerOn = UIButton(frame: CGRect(x: rightX, y: y1, width: width, height: height))
        let cMute = UIButton(frame: CGRect(x: leftX, y: y2, width: width, height: height))
        let sMute = UIButton(frame: CGRect(x: rightX, y: y2, width: width, height: height))
        let forceReport = UIButton(frame: CGRect(x: leftX, y: y3, width: width, height: height))
        
        transmissionToggle.setTitle("CELL", for: .normal)
        buzzerOn.setTitle("BUZZER", for: .normal)
        cMute.setTitle("CMUTE", for: .normal)
        sMute.setTitle("SMUTE", for: .normal)
        forceReport.setTitle("FORCE", for: .normal)
        
        transmissionToggle.addTarget(self, action: #selector(DashboardPage.transmitModeButtonPressed(_:)), for: .touchUpInside)
        buzzerOn.addTarget(self, action: #selector(DashboardPage.buzzerButtonPressed(_:)), for: .touchUpInside)
        cMute.addTarget(self, action: #selector(DashboardPage.cmuteButtonPressed(_:)), for: .touchUpInside)
        sMute.addTarget(self, action: #selector(DashboardPage.smuteButtonPressed(_:)), for: .touchUpInside)
        forceReport.addTarget(self, action: #selector(DashboardPage.forceReportButtonPressed(_:)), for: .touchUpInside)
        
        beautifyButton(button: transmissionToggle)
        beautifyButton(button: buzzerOn)
        beautifyButton(button: cMute)
        beautifyButton(button: sMute)
        beautifyButton(button: forceReport)
        
        addSubview(transmissionToggle)
        addSubview(buzzerOn)
        addSubview(cMute)
        addSubview(sMute)
        addSubview(forceReport)
        
    }
    
    func beautifyButton(button: UIButton) {
        button.backgroundColor = .white
        button.layer.borderColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0).cgColor
        button.layer.borderWidth = 0.3
        button.setTitleColor(.red, for: .normal)
    }
    
    @objc func transmitModeButtonPressed(_ sender: Any) {
        
        if transmitMode == .cellular {
            transmissionToggle.setTitle("CELL", for: .normal)
        } else {
            transmissionToggle.setTitle("SAT", for: .normal)
        }
    }
    
    @objc func buzzerButtonPressed(_ sender: Any) {
        sendMessageToSocket(message: "buzzeron")
        
    }
    
    @objc func cmuteButtonPressed(_ sender: Any) {
        sendMessageToSocket(message:"cellmute")
    }
    
    @objc func smuteButtonPressed(_ sender: Any) {
        sendMessageToSocket(message:"satmute")
    }
    
    @objc func forceReportButtonPressed(_ sender: Any) {
        if self.transmitMode == .cellular {
            sendMessageToSocket(message:"$$")
        } else {
            //TODO: Send it thru SAT not CELL
            sendMessageToSocket(message:"$$$")
        }
    }
    
}

