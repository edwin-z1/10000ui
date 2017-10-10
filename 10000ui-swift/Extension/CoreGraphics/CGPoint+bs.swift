//
//  CGPoint+bs.swift
//  CircleSlider
//
//  Created by 张亚东 on 16/5/28.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

import CoreGraphics

extension CGPoint: Namespace {}

extension NamespaceBox where Source == CGPoint {
    
    func angleFromEast(withRelativePoint relativePoint: CGPoint, clockwise: Bool = false) -> CGFloat {
        var v = CGPoint(x: relativePoint.x - source.x, y: relativePoint.y - source.y)
        
        let vmag = hypot(v.x, v.y)
        
        v.x /= vmag
        
        v.y /= vmag
        
        // the angle base on East (math coordinate)
        var angle = atan2(v.y, v.x)
        if clockwise {
            angle *= -1
        }
        return angle.bs.circumPositiveValue
    }
    
    func angleFromNorth(withRelativePoint relativePoint: CGPoint, clockwise: Bool = false) -> CGFloat {
        
        let angle = angleFromEast(withRelativePoint: relativePoint, clockwise: clockwise) - .pi/2 * 3
        return angle.bs.circumPositiveValue
    }
    
    func offset(angle: CGFloat, distance: CGFloat) -> CGPoint {
        return CGPoint(x: source.x + distance * cos(angle),
                       y: source.y + distance * sin(angle))
    }
}

