//
//  Time.swift
//  GroundControl
//
//  Created by Francisco Lobo on 2/14/18.
//  Copyright © 2018 Movic Technologies. All rights reserved.
//

//Used to store mission stopwatch-timer values.

import Foundation

struct Time {
    var epoch:TimeInterval
    let hour:UInt
    let minute:UInt
    let second:UInt
    var negative:Bool {
        get {
            if (epoch < 0) { return true }
            return false
        }
    }
    var timeString:String {
        get {
            let sign = negative ? "-" : ""
            return "\(sign)\(self.intToDblDigitStr(hour)):\(self.intToDblDigitStr(minute)):\(self.intToDblDigitStr(second))"
        }
    }
    
    init(epoch: TimeInterval) {
        print("Epoch: \(epoch)")
        self.epoch = epoch
        let intEpoch = UInt(abs(epoch))
        
        hour = intEpoch / 3600
        minute = (intEpoch % 3600) / 60
        second = (intEpoch % 3600) % 60
    }
    
    private func intToDblDigitStr(_ unit: UInt) -> String {
        return unit < 10 ? "0\(unit)" : "\(unit)"
    }
    
}
