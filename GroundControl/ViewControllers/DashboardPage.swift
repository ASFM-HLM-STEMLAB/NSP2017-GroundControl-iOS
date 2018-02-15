//
//  DashboardPage.swift
//  GroundControl
//
//  Created by Rodrigo Chousal on 2/9/18.
//  Copyright © 2018 Movic Technologies. All rights reserved.
//

import UIKit

class DashboardPage: UIView {
    
    var terminalEnabled = false
    var titleView: UIView = UIView()
    var pageTitle: String = ""
    
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
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: titleView.frame.width, height: titleView.frame.height))
        titleLabel.text = pageTitle
        titleLabel.font = UIFont(name: "Avenir-Heavy", size: 20)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        titleView.addSubview(titleLabel)
        addSubview(titleView)
        
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
    
    func enableTerminal() {
        // TODO: Show functioning terminal
    }

}
