//
//  PopoverController.swift
//  10000ui-swift
//
//  Created by 张亚东 on 16/5/9.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {

    typealias Animations = () -> Void
    typealias Completion = (Bool) -> Void
    var animationDuration: TimeInterval = 0.15
    var presentAnimations: Animations?
    var dismissAnimations: Animations?
    var presentCompletion: Completion?
    var dismissCompletion: Completion?
    
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
    
    //UI
    fileprivate lazy var maskView: UIView = {
        let view: UIView = UIView(frame: self.view.bounds)
        view.backgroundColor = self.maskColor
        view.addGestureRecognizer(self.tap)
        return view
    }()

    fileprivate var lastWindow: UIWindow?
    fileprivate var currentWindow: UIWindow?
    
    //Gesture
    fileprivate lazy var tap: UITapGestureRecognizer = {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PopoverViewController.handleTap(_:)))
        return tap
    }()
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return statusBarStyle
    }
    
    override var prefersStatusBarHidden : Bool {
        return isStatusBarHidden
    }
    
    deinit {
        print("\(description) deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.insertSubview(maskView, at: 0)
    }
    
}

fileprivate extension PopoverViewController {
    
    func prepareForShow() {
        
        PopoverViewController.isAnyPresented = true
        
        lastWindow = UIApplication.shared.keyWindow
        
        currentWindow = newAlertWindow()
        currentWindow?.makeKeyAndVisible()
        
        maskView.alpha = 0
    }
    
    func finishForDismiss() {
        PopoverViewController.isAnyPresented = false
        
        currentWindow?.isHidden = true
        currentWindow?.rootViewController = nil
        currentWindow = nil
        
        lastWindow?.makeKeyAndVisible()
    }
    
    func newAlertWindow() -> UIWindow {
        let window = UIWindow(frame: self.view.bounds)
        window.windowLevel = UIWindowLevelAlert
        window.rootViewController = self
        
        return window
    }
    
    @objc func handleTap(_ tap: UITapGestureRecognizer) {
        dismiss()
    }
    
}

// MARK: - Public
extension PopoverViewController {
    
    @discardableResult
    func present() -> Bool {
        
        guard !animating,
            !PopoverViewController.isAnyPresented else {
                return false
        }
        animating = true
        
        prepareForShow()
        
        UIView.animate(withDuration: animationDuration, animations: {
            
            self.maskView.alpha = 1
            self.presentAnimations?()
            
            }, completion: { (finished: Bool) in
                
                self.animating = false
                self.presentCompletion?(finished)
        })
        return true
    }
    
    func dismiss() {
        guard !animating else {
            return
        }
        animating = true
        
        UIView.animate(withDuration: animationDuration, animations: {
            
            self.maskView.alpha = 0
            self.dismissAnimations?()
            
            }, completion: { (finished: Bool) in
                
                self.animating = false
                
                self.dismissCompletion?(finished)
                self.finishForDismiss()
        })
        
    }
}



