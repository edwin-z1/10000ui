//
//  CGPoint+bs.swift
//  BSCircleSlider
//
//  Created by 张亚东 on 16/5/28.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    
    func bs_angleFromNorth(withRelativePoint relativePoint: CGPoint) -> CGFloat {
        
        let angle = angleFromEast(withRelativePoint: relativePoint, clockwise: false) - .pi/2 * 3
        return angle.bs_circumPositiveValue
    }
    
    func bs_offset(angle: CGFloat, distance: CGFloat) -> CGPoint {
        return CGPoint(x: x + distance * cos(angle),
                       y: y + distance * sin(angle))
    }
}

fileprivate extension CGPoint {
    
    func angleFromEast(withRelativePoint relativePoint: CGPoint, clockwise: Bool = false) -> CGFloat {
        var v = CGPoint(x: relativePoint.x - x, y: relativePoint.y - y)
        
        let vmag = hypot(v.x, v.y)
        
        v.x /= vmag
        
        v.y /= vmag
        
        // the angle base on East (math coordinate)
        var angle = atan2(v.y, v.x)
        if clockwise {
            angle *= -1
        }
        return angle.bs_circumPositiveValue
    }
}

