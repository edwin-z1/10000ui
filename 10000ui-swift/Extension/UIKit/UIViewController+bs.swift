//
//  UIViewController+bs.swift
//  10000ui-swift
//
//  Created by 张亚东 on 11/08/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import UIKit

fileprivate struct AssociatedObjectKeys {
    static var dismissCompletion = "dismissCompletion"
    static var leftClickHandler = "leftClickHandler"
    static var rightClickHandler = "rightClickHandler"
}

extension NamespaceBox where T: UIViewController {
    
    func setBackLeftItem(clickHandler:(() -> Void)?) {
        base.leftClickHandler = clickHandler
        base.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "arrow_left"), style: .plain, target: base, action: #selector(UIViewController.handleBackLeftItem(sender:)))
    }
    
    func setDismissLeftItem(dismissCompletion: (() -> Void)? )  {
        
        base.dismissCompletion = dismissCompletion
        base.navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .stop, target: base, action: #selector(UIViewController.handleDismissLeftItem(sender:)))
    }
    
    func setRightItem(title: String, clickHandler: (() -> Void)? )  {
        
        base.rightClickHandler = clickHandler
        base.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: title, style: .plain, target: base, action: #selector(UIViewController.handleRightItem(sender:)))
    }
}

fileprivate extension UIViewController {
    
    var leftClickHandler: (() -> Void)? {
        set {
            objc_setAssociatedObject(self, &AssociatedObjectKeys.leftClickHandler, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectKeys.leftClickHandler) as? (() -> Void)
        }
    }
    
    @objc func handleBackLeftItem(sender: UIBarButtonItem) {
        leftClickHandler?()
    }
    
    var dismissCompletion: (() -> Void)? {
        set {
            objc_setAssociatedObject(self, &AssociatedObjectKeys.dismissCompletion, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectKeys.dismissCompletion) as? (() -> Void)
        }
    }
    
    @objc func handleDismissLeftItem(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: self.dismissCompletion)
    }
    
    var rightClickHandler: (() -> Void)? {
        set {
            objc_setAssociatedObject(self, &AssociatedObjectKeys.rightClickHandler, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectKeys.rightClickHandler) as? (() -> Void)
        }
    }
    
    @objc func handleRightItem(sender: UIBarButtonItem) {
        rightClickHandler?()
    }
}

extension NamespaceBox where T: UIViewController {
    
    static func instantiateFromStoryboard(name: String, bundle: Bundle? = nil, identifier: String = T.bs.string) -> T {
        return UIStoryboard(name: name, bundle: bundle).instantiateViewController(withIdentifier: identifier) as! T
    }
}

extension NamespaceBox where T: UIViewController {
    
    var topPresentedVC: UIViewController {
        if let presentedVC = base.presentedViewController {
            return presentedVC.bs.topPresentedVC
        } else {
            return base
        }
    }
    
    var rootParentVC: UIViewController {
        if let parentVC = base.parent, !parentVC.isKind(of: UINavigationController.self) {
            return parentVC.bs.rootParentVC
        } else {
            return base
        }
    }
    
    var visibleViewController: UIViewController? {
        
        if let presented = base.presentedViewController {
            return presented.bs.visibleViewController
        } else if let tabBar = base as? UITabBarController {
            return tabBar.selectedViewController?.bs.visibleViewController
        } else if let navi = base as? UINavigationController {
            return navi.visibleViewController?.bs.visibleViewController
        } else {
            return base
        }
    }
    
    var parentViewController: UIViewController? {
        
        if let parent = base.parent,
            parent != base.presentingViewController,
            !parent.isKind(of: UITabBarController.self),
            !parent.isKind(of: UINavigationController.self) {
            return parent.bs.parentViewController
        } else {
            return base
        }
    }
}
