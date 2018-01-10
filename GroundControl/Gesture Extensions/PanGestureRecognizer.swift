//
//  PanGestureRecognizer.swift
//  GroundControl
//
//  Created by Francisco Lobo on 1/10/18.
//  Copyright © 2018 Movic Technologies. All rights reserved.
//

import Foundation
import UIKit

public enum Direction: Int {
    case Up
    case Down
    case Left
    case Right
    
    public var isX: Bool { return self == .Left || self == .Right }
    public var isY: Bool { return !isX }
}

public extension UIPanGestureRecognizer {
    
    public var direction: Direction? {
        let vel = velocity(in: self.view)// velocityInView(view)
        let vertical = fabs(vel.y) > fabs(vel.x)
        switch (vertical, vel.x, vel.y) {
        case (true, _, let y) where y < 0: return .Up
        case (true, _, let y) where y > 0: return .Down
        case (false, let x, _) where x > 0: return .Right
        case (false, let x, _) where x < 0: return .Left
        default: return nil
        }
    }
}
