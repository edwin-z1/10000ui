//
//  PopoverController.swift
//  10000ui-swift
//
//  Created by 张亚东 on 16/5/9.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

import UIKit

class PopoverController: UIViewController {

    typealias Animations = () -> Void
    typealias Completion = (Bool) -> Void
    var animationDuration: TimeInterval = 0.15
    var presentAnimations: Animations? = { }
    var dismissAnimations: Animations? = { }
    var presentCompletion: Completion? = { _ in }
    var dismissCompletion: Completion? = { _ in }
    
    var statusBarStyle: UIStatusBarStyle = .default
    var isStatusBarHidden: Bool = false
    
    var maskColor: UIColor? {
        didSet {
            maskView.backgroundColor = maskColor
        }
    }
    var isTapGestureEnabled: Bool = true {
        didSet {
            tap.isEnabled = isTapGestureEnabled
        }
    }

    fileprivate(set) var animating: Bool = false
    fileprivate(set) static var isAnyPresented = false
    fileprivate(set) var isPresented = false
    
    //UI
    fileprivate lazy var maskView: UIView = {
        let view: UIView = UIView(frame: self.view.bounds)
        view.backgroundColor = self.maskColor
        view.addGestureRecognizer(self.tap)
        return view
    }()

    fileprivate var lastWindow: UIWindow?
    fileprivate var targetWindow: UIWindow?
    
    //Gesture
    fileprivate lazy var tap: UITapGestureRecognizer = {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PopoverController.handleTap(_:)))
        return tap
    }()
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return statusBarStyle
    }
    
    override var prefersStatusBarHidden : Bool {
        return isStatusBarHidden
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.insertSubview(maskView, at: 0)
    }
    
    //MARK:Public
    
    @discardableResult
    func present() -> Bool {
        
        guard animating == false else {
            return false
        }
        animating = true
        isPresented = true
        PopoverController.isAnyPresented = true
        
        prepareForShow()
        
        UIView.animate(withDuration: animationDuration, animations: { [unowned self] in
            
            self.maskView.alpha = 1
            self.presentAnimations?()
            
            }, completion: { [unowned self] (finished: Bool) in
                
                self.animating = false
                self.presentCompletion?(finished)
        })
        return true
    }
    
    func dismiss() {
        guard animating == false else {
            return
        }
        animating = true
        
        UIView.animate(withDuration: animationDuration, animations: { [unowned self] in
            
            self.maskView.alpha = 0
            self.dismissAnimations?()
            
            }, completion: { [unowned self] (finished: Bool) in
                
                self.finishForDismiss()
                
                self.animating = false
                self.isPresented = false
                PopoverController.isAnyPresented = false
                self.dismissCompletion?(finished)
        })
    }
}

extension PopoverController {
    
    @objc func handleTap(_ tap: UITapGestureRecognizer) {
        dismiss()
    }
}

//MARK:Private
private extension PopoverController {
    
    func prepareForShow() {
        
        lastWindow = UIApplication.shared.keyWindow
        
        targetWindow = newAlertWindow()
        targetWindow?.makeKeyAndVisible()
        
        maskView.alpha = 0
    }
    
    func finishForDismiss() {
        targetWindow?.isHidden = true
        targetWindow?.rootViewController = nil
        targetWindow = nil
        
        lastWindow?.makeKeyAndVisible()
    }
    
    func newAlertWindow() -> UIWindow {
        let window = UIWindow(frame: self.view.bounds)
        window.windowLevel = UIWindowLevelAlert
        window.rootViewController = self
        
        return window
    }
}



