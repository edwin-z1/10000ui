//
//  PetalLayoutCircleAttributes.swift
//  10000ui-swift
//
//  Created by blurryssky on 2018/1/26.
//  Copyright © 2018年 blurryssky. All rights reserved.
//

import Foundation

struct PetalLayoutCircleAttributes {
    
    let index: Int
    let itemsCount: Int
    let maxItemsCount: Int
    let radius: CGFloat
    let angle: CGFloat
    
    var isFull: Bool {
        return itemsCount == maxItemsCount
    }
}
