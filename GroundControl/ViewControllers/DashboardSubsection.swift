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
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: 0.5*frame.height))
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.baselineAdjustment = .alignCenters
        titleLabel.font = UIFont(name: "Avenir-Heavy", size: 15)
        
        infoLabel = UILabel(frame: CGRect(x: 0, y: (0.2 * frame.height), width: frame.width, height: frame.height))
        infoLabel.text = info
        infoLabel.textAlignment = .center
        infoLabel.baselineAdjustment = .alignCenters
        infoLabel.font = UIFont(name: "Avenir-Heavy", size: 35)
        
        addSubview(titleLabel)
        addSubview(infoLabel)
        
        backgroundColor = .white
        layer.borderColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0).cgColor
        layer.borderWidth = 0.3
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
