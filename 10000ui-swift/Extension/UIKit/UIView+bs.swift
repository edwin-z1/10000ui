//
//  UIView+BSExt.swift
//  10000ui-swift
//
//  Created by 张亚东 on 16/4/25.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

import UIKit

extension NamespaceBox where Source: UIView {
    
    var origin: CGPoint {
        set {
            source.frame = CGRect(origin: newValue, size: source.frame.size)
        }
        get {
            return source.frame.origin
        }
    }
    
    var size: CGSize {
        set {
            source.frame = CGRect(origin: source.frame.origin, size: newValue)
        }
        get {
            return source.frame.size
        }
    }
    
    var x: CGFloat {
        set {
            source.frame = CGRect(origin: CGPoint(x: newValue, y: source.frame.origin.y), size: source.frame.size)
        }
        get {
            return source.frame.origin.x
        }
    }
    
    var y: CGFloat {
        set {
            source.frame = CGRect(origin: CGPoint(x: source.frame.origin.x, y: newValue), size: source.frame.size)
        }
        get {
            return source.frame.origin.y
        }
    }
    
    var centerX: CGFloat {
        set {
            source.center = CGPoint(x: newValue, y: centerY)
        }
        get {
            return source.center.x
        }
    }
    
    var centerY: CGFloat {
        set {
            source.center = CGPoint(x: centerX, y: newValue)
        }
        get {
            return source.center.y
        }
    }
    
    var width: CGFloat {
        set {
            source.frame = CGRect(origin: source.frame.origin, size: CGSize(width: newValue, height: source.frame.size.height))
        }
        get {
            return source.frame.size.width
        }
    }
    
    var height: CGFloat {
        set {
            source.frame = CGRect(origin: source.frame.origin, size: CGSize(width: source.frame.size.width, height: newValue))
        }
        get {
            return source.frame.size.height
        }
    }
}




