//
//  CGFloat+bs.swift
//  BSCircleSliderSample
//
//  Created by 张亚东 on 09/08/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import CoreGraphics

extension CGFloat: Namespace {}

extension NamespaceBox where T == CGFloat {
    
    var circumPositiveValue: CGFloat {
        var value = base
        if value < 0 {
            value += .pi * 2
            return value.bs.circumPositiveValue
        } else if value > .pi * 2 {
            value -= .pi * 2
            return value.bs.circumPositiveValue
        } else {
            return value
        }
    }
}

