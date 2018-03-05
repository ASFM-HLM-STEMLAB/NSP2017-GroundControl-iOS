//
//  CommandViewController.swift
//  GroundControl
//
//  Created by Francisco Lobo on 2/27/18.
//  Copyright © 2018 Movic Technologies. All rights reserved.
//

import UIKit

class CommandViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cellMutePressed(_ sender: UIButton) {
        sender.setTitleColor(UIColor.white, for: .normal)
        SocketCenter.send(event: "TXC", data: ["cellmute"]) { (success, data) in
            self .displayResponseFromServer(forButton: sender, success: success)
        }
    }
    
    @IBAction func satMutePressed(_ sender: UIButton) {
        SocketCenter.send(event: "TXC", data: ["satmute"]) { (success, data) in
            self .displayResponseFromServer(forButton: sender, success: success)
        }
    }
    
    @IBAction func buzzerButtonPressed(_ sender: UIButton) {
        SocketCenter.send(event: "TXC", data: ["buzzeron"]) { (success, data) in
            self .displayResponseFromServer(forButton: sender, success: success)
        }
    }
    
    @IBAction func forceReportButtonPressed(_ sender: UIButton) {
        SocketCenter.send(event: "TXC", data: ["$$"]) { (success, data) in
            self .displayResponseFromServer(forButton: sender, success: success)
        }
    }
    
    @IBAction func chirpButtonPressed(_ sender: UIButton) {
        SocketCenter.send(event: "TXC", data: ["buzzerchirp"]) { (success, data) in
            self .displayResponseFromServer(forButton: sender, success: success)
        }
    }
    
    @IBAction func startClockButtonPressed(_ sender: UIButton) {
        SocketCenter.send(event: "TXC", data: ["timestart"]) { (success, data) in
            self .displayResponseFromServer(forButton: sender, success: success)
        }
    }
    
    @IBAction func stopClockButtonPressed(_ sender: UIButton) {
        SocketCenter.send(event: "TXC", data: ["timepause"]) { (success, data) in
            self .displayResponseFromServer(forButton: sender, success: success)
        }
    }
    
    @IBAction func setClockButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Set Time in Seconds (- for countdown)", message: "", preferredStyle: .alert)
        
        let setButton = UIAlertAction(title: "Continue", style: .default) { (action) in
            let timeInSeconds = alert.textFields![0] as UITextField
            let value = "timeset \(timeInSeconds.text ?? "0")"
            SocketCenter.send(event: "TXC", data: [value], onAck: nil)
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
        //####TODO [NEEDS SERVER SIDE IMPLEMENTATION FOR THE ACK]
//        if (success != true) {
//            sender.setTitleColor(UIColor.red, for: .normal)
//        } else {
//            sender.setTitleColor(UIColor.green, for: .normal)
//        }
    }
    
}
