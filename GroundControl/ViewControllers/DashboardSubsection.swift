//
//  DashboardSubsection.swift
//  GroundControl
//
//  Created by Rodrigo Chousal on 2/9/18.
//  Copyright © 2018 Movic Technologies. All rights reserved.
//

import UIKit

class DashboardSubsection: UIView {

    var title: String
    var info: String
    
    var titleLabel: UILabel
    var infoLabel: UILabel
    
    override init(frame: CGRect) {
        
        title = String()
        info = String()
        titleLabel = UILabel()
        infoLabel = UILabel()
        
        super.init(frame : frame)
        
        title = "Title"
        info = "Info"
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: (0.22 * frame.height), width: frame.width, height: 20.0)) // FIXME: Height is wrong
        titleLabel.text = title
        titleLabel.textAlignment = .center
        
        infoLabel = UILabel(frame: CGRect(x: 0, y: (0.39 * frame.height), width: frame.width, height: 20.0)) // FIXME: Height is wrong
        infoLabel.text = info
        infoLabel.textAlignment = .center
        
        addSubview(titleLabel)
        addSubview(infoLabel)
    }
    
    // Use updateLabels after setting title and info variables as Strings so it is reflected in view
    func updateLabels() {
        titleLabel.text = title
        infoLabel.text = info
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
