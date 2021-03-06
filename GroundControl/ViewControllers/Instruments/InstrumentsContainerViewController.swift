//
//  InstrumentsContainerViewController.swift
//  GroundControl
//
//  Created by Francisco Lobo on 2/27/18.
//  Copyright © 2018 Movic Technologies. All rights reserved.
//

import UIKit

enum ServerConnectionStatus {
    case connected
    case disconnected
}

class InstrumentsContainerViewController: UIViewController, ReportRenderable, PanelViewDelegate {
    @IBOutlet weak var stageLabel: UILabel!
    @IBOutlet weak var controlBar: UIView!
    var initialPanCenter = CGPoint()
    var panelViewDelegate:PanelViewDelegate?
    
    
    private var pageController: InstrumentsPageController?
    @IBOutlet weak var statusBar: UIView!
    
    @IBOutlet weak var messageCountLabel: UILabel!
    @IBOutlet weak var onlineStatusLabel: UILabel!
    
    func setReport(_ report: Report) {
        if let pageController = pageController {
            pageController.setReport(report)
            self.stageLabel.text = "\(report.missionStage.stringValue().uppercased())"
        }
    }
    
    func allowRestrictedArea() {
        pageController?.allowRestrictedArea()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {        
        if segue.identifier == "pageViewSegue" {
            pageController = segue.destination as? InstrumentsPageController
            pageController?.panelViewDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        self.view.addGestureRecognizer(panRecognizer)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        tapRecognizer.numberOfTapsRequired = 1
        self.controlBar.addGestureRecognizer(tapRecognizer)
        
        let idTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(idDidTap))
        idTapRecognizer.numberOfTapsRequired = 4
        self.statusBar.addGestureRecognizer(idTapRecognizer)
        
    }
    
    
    @objc func didPan(_ gesture: UIPanGestureRecognizer) {
        let piece = gesture.view!
        let translation = gesture.translation(in: piece.superview)
        
        if gesture.state == .began { // Store pan init pos
            self.initialPanCenter = piece.center
        }
        
        if gesture.state != .cancelled && gesture.state != .ended {
            // Add the X and Y translation to the view's original position.
            let newCenter = CGPoint(x: initialPanCenter.x, y: initialPanCenter.y + translation.y)
            piece.center = newCenter
            if let dir = gesture.direction {
                if dir == .Up && translation.y < -120 {
                    gesture.isEnabled = false
                    panelViewDelegate?.shouldShowPanelView()
                    
                }
                if dir == .Down  && translation.y > 120 {
                    gesture.isEnabled = false
                    panelViewDelegate?.shouldHidePanelView()
                }
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                piece.center = self.initialPanCenter
            })
            gesture.isEnabled = true
        }
    }

    @objc func didTap(_ gesture: UITapGestureRecognizer) {
        shouldTogglePanelView()
    }
    
    @objc func idDidTap(_ gesture: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Login to continue", message: "", preferredStyle: .alert)
        
        let authenticateButton = UIAlertAction(title: "Continue", style: .default) { (action) in
            let usernameTextField = alert.textFields![0] as UITextField
            let passwordTextField = alert.textFields![1] as UITextField
            
            if usernameTextField.text == "me" && passwordTextField.text == "too" {
                self.pageController?.allowRestrictedArea()
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
    

    func setMessageCount(_ messages: Int) {
        self.messageCountLabel.text = "✉️ \(messages)"
    }
    
    func setConnectionStatus(_ status: ServerConnectionStatus) {
        switch status {
        case .connected:
            self.onlineStatusLabel.text = "ONLINE"
            view.layer.removeAllAnimations()
            UIView.animate(withDuration: 1.0, animations: {
                self.statusBar.backgroundColor = UIColor.black
            })
            
        case .disconnected:
            self.onlineStatusLabel.text = "OFFLINE"
            view.layer.removeAllAnimations()
            UIView.animate(withDuration: 1.0, animations: {
                self.statusBar.backgroundColor = UIColor(red: 0.829,
                                                         green: 0.289,
                                                         blue: 0.342,
                                                         alpha: 1.00)
            })
        }
    }
    
    func clearLatestReport() {
        pageController?.clearLatestReport()
    }
}

extension InstrumentsContainerViewController {
    func shouldShowPanelView() {
        self.panelViewDelegate?.shouldShowPanelView()
    }

    func shouldTogglePanelView() {
        self.panelViewDelegate?.shouldTogglePanelView()
    }

    func shouldHidePanelView() {
        self.panelViewDelegate?.shouldHidePanelView()
    }
}
