//
//  MapViewInstrumentExtensions.swift
//  GroundControl
//
//  Created by Francisco Lobo on 2/13/18.
//  Copyright © 2018 Movic Technologies. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

// ---------------------------------------------------
// MARK: InfoPanel Methods and animations
extension MapViewController {
    func showDetails() {  //Animate the ReportInfoView panel up.
        self.view.layoutIfNeeded()
        
        let top = CGAffineTransform(translationX: 0, y: 0)
        infoViewShowed = true
        UIView.animate(withDuration: infoViewAnimationTime, delay: 0, options: [.curveEaseIn], animations: {
            self.reportInfoView.transform = top
            self.view.layoutIfNeeded()
            self.reportInfoView.updateConstraintsIfNeeded()
        }, completion: nil)
    }
    
    func hideDetails() { //Animate the ReportInfoView panel down.
        self.view.layoutIfNeeded()
        self.reportInfoView.updateConstraintsIfNeeded()
        let top = CGAffineTransform(translationX: 0, y: reportInfoView.bounds.height-65)
        infoViewShowed = false
        UIView.animate(withDuration: infoViewAnimationTime, delay: 0, options: [.curveEaseIn], animations: {
            self.reportInfoView.transform = top
            self.view.layoutIfNeeded()
            self.reportInfoView.updateConstraintsIfNeeded()
        }, completion: nil)
    }
    
    func toggleDetails() {
        if infoViewShowed {
            self.hideDetails()
        } else {
            self.showDetails()
        }
    }
    
}
