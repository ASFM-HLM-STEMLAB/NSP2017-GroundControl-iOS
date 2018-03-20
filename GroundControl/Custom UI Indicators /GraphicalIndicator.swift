//
//  VerticalIndicator.swift
//  GroundControl
//
//  Created by Francisco Lobo on 11/28/17.
//  Copyright © 2017 Movic Technologies. All rights reserved.
//

import UIKit

//@IBDesignable
class GraphicalIndicator: UIView {
    
    enum IndicatorType {
        case bar
        case needle
    }
    
    enum IndicatorDirection {
        case vertical
        case horizontal
    }
    
    public var needleWidth:CGFloat = 3.0
    public var yellowRange = -2.0...(-1.0)
    public var redRange = -2.0...(-1.0)
    public var interpolateColor = true
    public var indicatorType:IndicatorType = .bar
    public var indicatorDirection:IndicatorDirection = .vertical
    public var transitionDuration = 0.3
    public var minimumIndication:CGFloat = 0.0
    public var indicatorColor = UIColor.green
    public var maxValue = 100
    public var minValue = 0
    private var _percent = 0
    
    var value: Int = 0 {
        didSet {
            
            let range = maxValue - minValue            
            let correctedStartValue = value - minValue
            let percentage = (correctedStartValue * 100) / range
            _percent = percentage
            setIndicatorValue(percent: percentage)
            
        }
    }
    
    private var indicatorView = UIView()
    
    override func awakeFromNib() {
        super .awakeFromNib()
        self.backgroundColor = UIColor.black
        
        indicatorView.frame = self.frame
        indicatorView.backgroundColor = indicatorColor
        indicatorView.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height:0)
        
        if indicatorType == .bar {
            indicatorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            indicatorView.translatesAutoresizingMaskIntoConstraints = true
        }
        
        self.addSubview(indicatorView)
    }
    
    override func layoutSubviews() {
        super .layoutSubviews()

    }
    
    private func setIndicatorValue(percent: Int) {
        var percent = CGFloat(percent)
        
        if percent > 100  { percent = 100 }
        
        if percent <= minimumIndication { percent = minimumIndication }
        
        
        let fillDiv:CGFloat = 100 / percent
        var newFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        if indicatorType == .bar {
            if indicatorDirection == .vertical {
                newFrame = CGRect(x: 0, y: frame.height - frame.height/fillDiv, width: frame.width, height: frame.height/fillDiv)
            }
            
            if indicatorDirection == .horizontal {
                newFrame = CGRect(x: 0, y: 0, width: (frame.width/fillDiv), height: frame.height)
            }
        }
        
        if indicatorType == .needle {
            if indicatorDirection == .vertical {
                newFrame = CGRect(x: 0, y: frame.height - frame.height/fillDiv, width: frame.width, height:needleWidth)
            }
            
            if indicatorDirection == .horizontal {
                newFrame = CGRect(x: (frame.width/fillDiv), y: 0, width: needleWidth, height: frame.height)
            }
        }
            
        
        UIView.animate(withDuration: transitionDuration, animations: {
            self.indicatorView.frame = newFrame
            if self.interpolateColor == true {
                if self.yellowRange.contains(Double(self._percent)) {
                    self.indicatorView.backgroundColor = UIColor.yellow
                } else if self.redRange.contains(Double(self._percent)) {
                   self.indicatorView.backgroundColor = UIColor.red
                } else {
                    self.indicatorView.backgroundColor = self.indicatorColor
                }
                
            }
        }) { (finished) in            
            if self.yellowRange.contains(Double(self._percent)) {
                self.indicatorView.backgroundColor = UIColor.yellow
            } else if self.redRange.contains(Double(self._percent)) {
                self.indicatorView.backgroundColor = UIColor.red
            } else {
                self.indicatorView.backgroundColor = self.indicatorColor
            }
        }
        }
    
    
    
}
