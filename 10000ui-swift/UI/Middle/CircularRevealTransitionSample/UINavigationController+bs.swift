//
//  UINavigationController+bs.swift
//  10000ui-swift
//
//  Created by 张亚东 on 07/11/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//


fileprivate struct AssociatedObjectKeys {
    static var circularRevealTransition = "circularRevealTransition"
}

extension NamespaceBox where Source: UINavigationController {
    
    var circularRevealTransition: CircularRevealTransition {
        return source.circularRevealTransition
    }
}

fileprivate extension UINavigationController {
    
    var circularRevealTransition: CircularRevealTransition! {
        set {
            objc_setAssociatedObject(self, &AssociatedObjectKeys.circularRevealTransition, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let transition = objc_getAssociatedObject(self, &AssociatedObjectKeys.circularRevealTransition) as? CircularRevealTransition {
                return transition
            } else {
                let transition = CircularRevealTransition(navigationController: self)
                objc_setAssociatedObject(self, &AssociatedObjectKeys.circularRevealTransition, transition, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return transition
            }
        }
    }
}
