//
//  CircularRevealTransitionSampleViewController.swift
//  10000ui-swift
//
//  Created by 张亚东 on 02/11/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import UIKit

class CircularRevealTransitionSampleViewController: UIViewController, TopBarsAppearanceChangable {
    
    fileprivate var circularTransition: CircularRevealTransition {
        return navigationController!.bs.circularRevealTransition
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTopBarsAppearanceStyle(.clearBackground, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        circularTransition.disable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.bs.random(alpha: 0.5).cgColor, UIColor.bs.random(alpha: 0.5).cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        circularTransition.enable(navigationControllerDelegateProxy: self)
        
        let button = sender as! UIButton
        circularTransition.fromCenter = button.center
    }
}

extension CircularRevealTransitionSampleViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        print("willShow \(viewController)")
    }
}
