//
//  CommandViewController.swift
//  GroundControl
//
//  Created by Francisco Lobo on 2/27/18.
//  Copyright © 2018 Movic Technologies. All rights reserved.
//

import UIKit

class CommandViewController: UIViewController {

    @IBOutlet weak var miniTerminalTextView: UITextView!
    let notificationCenter = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()

        notificationCenter.addObserver(forName:SocketCenter.newMessageNotification, object: nil, queue: nil) { (notification) in
            if let report = notification.userInfo?["report"] as? Report {
                self.addLineToMiniTerminal("REP: \(report.rawReport)")
            } else if let rawData = notification.userInfo?["payload"] as? String {
                self.addLineToMiniTerminal("MSG: \(rawData)")
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cellMutePressed(_ sender: UIButton) {
        addLineToMiniTerminal("> TXCA: cellmute")
        SocketCenter.send(event: "TXCA", data: ["cellmute"]) { (success, data) in
            self .displayResponseFromServer(forButton: sender, success: success)
            self.addLineToMiniTerminal("AK: \(data)")
        }
    }
    
    @IBAction func satMutePressed(_ sender: UIButton) {
        addLineToMiniTerminal("TXCA: satmute")
        SocketCenter.send(event: "TXCA", data: ["satmute"]) { (success, data) in
            self .displayResponseFromServer(forButton: sender, success: success)
            self.addLineToMiniTerminal("AK: \(data)")
        }
    }
    
    @IBAction func buzzerButtonPressed(_ sender: UIButton) {
        addLineToMiniTerminal("TXCA: buzzeron")
        SocketCenter.send(event: "TXCA", data: ["buzzeron"]) { (success, data) in
            self .displayResponseFromServer(forButton: sender, success: success)
            self.addLineToMiniTerminal("AK: \(data)")
        }
    }
    
    @IBAction func forceReportButtonPressed(_ sender: UIButton) {
        addLineToMiniTerminal("TXCA: $$")
        SocketCenter.send(event: "TXCA", data: ["$$"]) { (success, data) in
            self .displayResponseFromServer(forButton: sender, success: success)
            self.addLineToMiniTerminal("AK: \(data)")
        }
    }
    
    @IBAction func chirpButtonPressed(_ sender: UIButton) {
        addLineToMiniTerminal("TXCA: buzzerchirp")
        SocketCenter.send(event: "TXCA", data: ["buzzerchirp"]) { (success, data) in
            self .displayResponseFromServer(forButton: sender, success: success)
            self.addLineToMiniTerminal("AK: \(data)")
        }
    }
    
    @IBAction func startClockButtonPressed(_ sender: UIButton) {
        addLineToMiniTerminal("TXCA: timestart")
        SocketCenter.send(event: "TXCA", data: ["timestart"]) { (success, data) in
            self .displayResponseFromServer(forButton: sender, success: success)
            self.addLineToMiniTerminal("AK: \(data)")
        }
    }
    
    @IBAction func stopClockButtonPressed(_ sender: UIButton) {
        addLineToMiniTerminal("TXCA: timepause")
        SocketCenter.send(event: "TXCA", data: ["timepause"]) { (success, data) in
            self .displayResponseFromServer(forButton: sender, success: success)
            self.addLineToMiniTerminal("AK: \(data)")
        }
    }
    
    @IBAction func setClockButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Set Time in Seconds (- for countdown)", message: "", preferredStyle: .alert)
        
        let setButton = UIAlertAction(title: "Continue", style: .default) { (action) in
            let timeInSeconds = alert.textFields![0] as UITextField
            let value = "timeset \(timeInSeconds.text ?? "0")"
            self.addLineToMiniTerminal("TXCA: \(value)")
            SocketCenter.send(event: "TXCA", data: [value]) { (success, data) in
                self .displayResponseFromServer(forButton: sender, success: success)
                self.addLineToMiniTerminal("AK: \(data)")
            }
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Seconds"
        }
        
        alert.addAction(setButton)
        alert.addAction(cancelButton)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func terminalButtonPressed(_ sender: Any) {
        
    }
    
    func displayResponseFromServer(forButton sender: UIButton, success:Bool) {
        if (success != true) {
            sender.setTitleColor(UIColor.red, for: .normal)
        } else {
            sender.setTitleColor(UIColor.green, for: .normal)
        }
        
        clearColorForButton(button: sender)
    }
    
    func clearColorForButton(button sender: UIButton) {
        let when = DispatchTime.now() + 10
        DispatchQueue.main.asyncAfter(deadline: when) {
         sender.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    func addLineToMiniTerminal(_ line: String) {
        self.miniTerminalTextView.text = self.miniTerminalTextView.text + line + "\n"
        
//        let bottom = self.miniTerminalTextView.contentSize.height - self.miniTerminalTextView.bounds.size.height
//        self.miniTerminalTextView.setContentOffset(CGPoint(x: 0, y: bottom), animated: f)
//
        let textCount = self.miniTerminalTextView.text.count

        guard textCount >= 1 else { return }
        DispatchQueue.main.async {
                self.miniTerminalTextView.scrollRangeToVisible(NSMakeRange(textCount - 4, 4))
        }
        
    }
    
    deinit { //Should not happen, but just in case we clear any weak refs.
        notificationCenter.removeObserver(self)
    }
    
}
