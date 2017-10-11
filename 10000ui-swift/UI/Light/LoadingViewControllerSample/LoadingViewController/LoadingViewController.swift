//
//  LoadingViewController.swift
//  10000ui-swift
//
//  Created by 张亚东 on 11/10/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import UIKit

class LoadingViewController: PopoverController {

    static let shared = LoadingViewController()
    
    fileprivate var loadingView: LoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingView = LoadingView(frame: view.bounds)
        view.addSubview(loadingView)

        loadingView.alpha = 0

        // override
        isTapGestureEnabled = false
        maskColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        presentAnimations = { [weak self] in
            self?.loadingView.alpha = 1
            self?.loadingView.startAnimation()
        }
        dismissAnimations = { [weak self] in
            self?.loadingView.alpha = 0
        }
        dismissCompletion = { [weak self] _ in
            self?.loadingView.endAnimation()
        }
    }
    
    static func show() {
        shared.present()
    }
    
    static func hide() {
        shared.dismiss()
    }
}
