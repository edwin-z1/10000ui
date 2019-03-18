//
//  UIView+BSExt.swift
//  10000ui-swift
//
//  Created by 张亚东 on 16/4/25.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

import UIKit

extension NamespaceBox where T: UIView {
    
    var origin: CGPoint {
        set {
            base.frame = CGRect(origin: newValue, size: base.frame.size)
        }
        get {
            return base.frame.origin
        }
    }
    
    var size: CGSize {
        set {
            base.frame = CGRect(origin: base.frame.origin, size: newValue)
        }
        get {
            return base.frame.size
        }
    }
    
    var x: CGFloat {
        set {
            base.frame = CGRect(origin: CGPoint(x: newValue, y: base.frame.origin.y), size: base.frame.size)
        }
        get {
            return base.frame.origin.x
        }
    }
    
    var y: CGFloat {
        set {
            base.frame = CGRect(origin: CGPoint(x: base.frame.origin.x, y: newValue), size: base.frame.size)
        }
        get {
            return base.frame.origin.y
        }
    }
    
    var centerX: CGFloat {
        set {
            base.center = CGPoint(x: newValue, y: centerY)
        }
        get {
            return base.center.x
        }
    }
    
    var centerY: CGFloat {
        set {
            base.center = CGPoint(x: centerX, y: newValue)
        }
        get {
            return base.center.y
        }
    }
    
    var width: CGFloat {
        set {
            base.frame = CGRect(origin: base.frame.origin, size: CGSize(width: newValue, height: base.frame.size.height))
        }
        get {
            return base.frame.size.width
        }
    }
    
    var height: CGFloat {
        set {
            base.frame = CGRect(origin: base.frame.origin, size: CGSize(width: base.frame.size.width, height: newValue))
        }
        get {
            return base.frame.size.height
        }
    }
    
}

extension UIView {
    
    static func instantiateFromNib() -> UIView? {
        return Bundle.main.loadNibNamed(String(describing: self.self), owner: nil, options: nil)?.first as? UIView
    }
}




