//
//  Adaptable.swift
//  10000ui-swift
//
//  Created by 张亚东 on 19/05/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import UIKit

protocol Adaptable {
    
    var adaptWidth: CGFloat { get }
    var adaptHeight: CGFloat { get }
}

extension Adaptable {
    
    fileprivate var widthFactor: CGFloat {
        return UIScreen.main.bounds.width/375
    }
    
    fileprivate var heightFactor: CGFloat {
        return UIScreen.main.bounds.height/677
    }
}

extension Int: Adaptable {
    var adaptWidth: CGFloat {
        return floor(CGFloat(self) * widthFactor)
    }
    var adaptHeight: CGFloat {
        return floor(CGFloat(self) * heightFactor)
    }
}

extension CGFloat: Adaptable {
    var adaptWidth: CGFloat {
        return floor(self * widthFactor)
    }
    var adaptHeight: CGFloat {
        return floor(self * heightFactor)
    }
}

