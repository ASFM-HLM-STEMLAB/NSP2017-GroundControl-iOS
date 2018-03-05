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
    
    @IBAction func cellMutePressed(_ sender: Any) {
        SocketCenter.send(event: "cellmute", data: ["buzzeron"], onAck: nil)
    }
    
    @IBAction func satMutePressed(_ sender: Any) {
        SocketCenter.send(event: "satmute", data: ["buzzeron"], onAck: nil)
    }
    
    @IBAction func buzzerButtonPressed(_ sender: Any) {
        SocketCenter.send(event: "TXC", data: ["buzzeron"], onAck: nil)
    }
    
    @IBAction func forceReportButtonPressed(_ sender: Any) {
        SocketCenter.send(event: "$$", data: ["buzzeron"], onAck: nil)
    }
    
    @IBAction func chirpButtonPressed(_ sender: Any) {
       SocketCenter.send(event: "TXC", data: ["buzzerchirp"], onAck: nil)
    }
    
    @IBAction func startClockButtonPressed(_ sender: Any) {
        SocketCenter.send(event: "TXC", data: ["timestart"], onAck: nil)
    }
    
    @IBAction func stopClockButtonPressed(_ sender: Any) {
        SocketCenter.send(event: "TXC", data: ["timepause"], onAck: nil)
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
    
}
