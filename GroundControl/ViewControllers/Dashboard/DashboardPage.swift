//
//  DashboardPage.swift
//  GroundControl
//
//  Created by Rodrigo Chousal on 2/9/18.
//  Copyright © 2018 Movic Technologies. All rights reserved.
//

import UIKit

class DashboardPage: UIView, UITextFieldDelegate {
    
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
    
    func setUpTerminal() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.terminalTextView = UITextView(frame: CGRect(x: 0, y: titleLabel.frame.height, width: self.frame.width, height: (self.frame.height - titleView.frame.height)*0.9))
        self.terminalInput = UITextField(frame: CGRect(x: 0, y: (titleLabel.frame.height + (terminalTextView?.frame.height)!), width: self.frame.width, height: (self.frame.height - titleView.frame.height)*0.1))
        
        if let input = self.terminalInput {
            
            input.delegate = self
            
            if let textView = self.terminalTextView {
                
                print("Setting Up Terminal!")
                
                textView.backgroundColor = .black
                textView.textColor = .white
                
                input.backgroundColor = .white
                input.textColor = .black
                
                addSubview(input)
                addSubview(textView)
            }
        }
    }
    
    // MARK: TERMINAL FUNCTIONS
    
    @objc func keyboardWillHide() {
        frame.origin.y = 0
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            frame.origin.y = -keyboardSize.height
            //            if (self.terminalInput.isFirstResponder) {
            //                frame.origin.y = -keyboardSize.height
            //            }
        }
    }
    
    func sendMessageToSocket(message:String) {
        // addLineToTerminal("> " + message)
        SocketCenter.sendMessage(event: "TXC", data: [message])
    }
    
    //    @IBAction func sendLineButtonPressed(_ sender: Any) {
    //        if let input = self.terminalInput.text {
    //            sendMessageToSocket(message:input)
    //        }
    //    }
    
    //    public func addLineToTerminal(_ line:String) {
    //        terminalTextView.text = self.terminalTextView.text + "\n" + line
    //        let bottom = self.terminalTextView.contentSize.height - self.terminalTextView.bounds.size.height
    //        self.terminalTextView.setContentOffset(CGPoint(x: 0, y: bottom), animated: true)
    //    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("SHOULD HIDE KEYBOARD!")
        textField.resignFirstResponder()
        return true
    }
    
}

