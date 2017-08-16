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

extension NamespaceBox where Source: UIViewController {
    
    func setBackLeftItem(clickHandler:(() -> Void)?) {
        source.leftClickHandler = clickHandler
        source.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "arrow_left"), style: .plain, target: source, action: #selector(UIViewController.handleBackLeftItem(sender:)))
    }
    
    func setDismissLeftItem(dismissCompletion: (() -> Void)? )  {
        
        source.dismissCompletion = dismissCompletion
        source.navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .stop, target: source, action: #selector(UIViewController.handleDismissLeftItem(sender:)))
    }
    
    func setRightItem(title: String, clickHandler: (() -> Void)? )  {
        
        source.rightClickHandler = clickHandler
        source.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: title, style: .plain, target: source, action: #selector(UIViewController.handleRightItem(sender:)))
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
