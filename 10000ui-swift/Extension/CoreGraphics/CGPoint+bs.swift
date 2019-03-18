//
//  CGPoint+bs.swift
//  CircleSlider
//
//  Created by 张亚东 on 16/5/28.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

import CoreGraphics

extension CGPoint: Namespace {}

extension NamespaceBox where T == CGPoint {
    
    func angleFromEast(withRelativePoint relativePoint: CGPoint, clockwise: Bool = false) -> CGFloat {
        var v = CGPoint(x: relativePoint.x - base.x, y: relativePoint.y - base.y)
        
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
    
    func offset(angleFromEast angle: CGFloat, distance: CGFloat, clockwise: Bool = true) -> CGPoint {
        let offsetX = distance * cos(angle)
        let offsetY = distance * sin(angle)
        var y: CGFloat = 0
        if clockwise {
            y = base.y + offsetY
        } else {
            y = base.y - offsetY
        }
        return CGPoint(x: base.x + offsetX,
                       y: y)
    }
    
    func offset(angleFromNorth angle: CGFloat, distance: CGFloat, clockwise: Bool = true) -> CGPoint {
        let offsetX = distance * sin(angle)
        let offsetY = distance * cos(angle)
        var x: CGFloat = 0
        if clockwise {
            x = base.x + offsetX
        } else {
            x = base.x - offsetX
        }
        return CGPoint(x: x,
                       y: base.y - offsetY)
    }
}

