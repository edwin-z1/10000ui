//
//  CGFloat+bs.swift
//  BSCircleSliderSample
//
//  Created by 张亚东 on 09/08/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import CoreGraphics

extension CGFloat {
    
    var bs_circumPositiveValue: CGFloat {
        var value = self
        if value < 0 {
            value += .pi * 2
            return value.bs_circumPositiveValue
        } else if value > .pi * 2 {
            value -= .pi * 2
            return value.bs_circumPositiveValue
        } else {
            return value
        }
    }
}
