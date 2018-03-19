//
//  TerminalViewController.swift
//  GroundControl
//
//  Created by Francisco Lobo on 3/12/18.
//  Copyright © 2018 Movic Technologies. All rights reserved.
//

import UIKit


class TerminalViewController: UIViewController, UITextFieldDelegate {
    
    enum LineKind {
        case normal
        case transmit
        case akn
        case report
        case other
        case error
    }
    
    
    @IBOutlet weak var terminalTextView: UITextView!
    
    @IBOutlet weak var sendButton: UIButton!
    let notificationCenter = NotificationCenter.default
    //    var keyboardSize: CGSize = CGSize.zero
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
    
    @IBOutlet weak var inputTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        notificationCenter.addObserver(forName:SocketCenter.newMessageNotification, object: nil, queue: nil) { (notification) in
            if let report = notification.userInfo?["report"] as? Report {
                //                self.addLineToMiniTerminal("REP: \(report.rawReport)")
                self.addLineToTerminal(line: report.rawReport, kind: .report)
            } else if let rawData = notification.userInfo?["payload"] as? String {
                self.addLineToTerminal(line: rawData, kind: .other)
                //                self.addLineToMiniTerminal("MSG: \(rawData)")
            }
        }
        
        notificationCenter.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: .UIKeyboardWillChangeFrame, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inputTextField.delegate = self
        bottomHeight.constant = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addLineToTerminal(line: "> Ready", kind: .normal)
        inputTextField .becomeFirstResponder()
    }
    
    @objc func keyboardWillChange(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            
            guard let keyboardSize =  (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
            }
            
            self.bottomHeight.constant = keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide() {
        self.bottomHeight.constant = 0
    }
    
    
    
    
    
    func addLineToMiniTerminal(_ line: String) {
        self.terminalTextView.text = self.terminalTextView.text + line + "\n"
        
        let textCount = self.terminalTextView.text.count
        
        guard textCount >= 1 else { return }
        DispatchQueue.main.async {
            self.terminalTextView.scrollRangeToVisible(NSMakeRange(textCount - 4, 4))
        }
        
    }
    
    
    func addLineToTerminal(line:String, kind:LineKind) {
        
        let atLine = NSMutableAttributedString(attributedString: self.terminalTextView.attributedText)
        
        var color = #colorLiteral(red: 0.7580124736, green: 0.3513534665, blue: 0.6502167583, alpha: 1)
        
        var font = UIFont.init(name: "AvenirNext-Regular", size: 17)!
        
        
        
        switch kind {
        case .normal:
            color = #colorLiteral(red: 0.7580124736, green: 0.3513534665, blue: 0.6502167583, alpha: 1)
        case .transmit:
            color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            font = UIFont(name: "AvenirNext-Medium", size: 17)!
        case .akn:
            color = #colorLiteral(red: 0.5786625743, green: 0.7849513888, blue: 0.4151180983, alpha: 1)
            font = UIFont(name: "AvenirNext-Medium", size: 17)!
        case .report:
            color = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        case .other:
            color = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        case .error:
            color = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            font = UIFont(name: "AvenirNext-Medium", size: 17)!
        }
        
        
        
        atLine.append(NSAttributedString(string: line + "\n", attributes: [
            .foregroundColor : color, .font : font
            ]))
        
        
        self.terminalTextView.attributedText = atLine
        
        let textCount = self.terminalTextView.text.count
        
        guard textCount >= 1 else { return }
        DispatchQueue.main.async {
            self.terminalTextView.scrollRangeToVisible(NSMakeRange(textCount - 4, 4))
        }
        
        
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        guard let command = self.inputTextField.text else {
            return
        }
        
        guard command.count > 0 else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        self.addLineToTerminal(line: "TXCA: \(command)", kind: .transmit)
        SocketCenter.send(event: "TXCA", data: [command]) { (success, data) in
            if data.count <= 0 {
                self.addLineToTerminal(line: "\(command) = \(data)", kind: .error)
            } else {
                self.addLineToTerminal(line: "\(command) = \(data)", kind: .akn)
            }
        }
        
        self.inputTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.sendButtonPressed(textField)
        
        return false
    }
    
    
    deinit { //Should not happen, but just in case we clear any weak refs.
        notificationCenter.removeObserver(self)
    }
    
}
