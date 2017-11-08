//
//  CircularRevealTransition.swift
//  10000ui-swift
//
//  Created by 张亚东 on 02/11/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import UIKit

class CircularRevealTransition: NSObject {
    
    var fromCenter: CGPoint = .zero {
        didSet {
            animator.fromCenter = fromCenter
            
            let topViewControllerIndex = navigationController.viewControllers.count - 1
            interactiveController?.fromCenterDict[topViewControllerIndex] = fromCenter
        }
    }

    weak var navigationControllerDelegateProxy: UINavigationControllerDelegate?
    
    init(navigationController: UINavigationController) {
        super.init()
        self.navigationController = navigationController
    }
    
    fileprivate weak var navigationController: UINavigationController!
    
    fileprivate let animator = CircularRevealTransitionAnimator()
    fileprivate var interactiveController: CircularRevealTransitionInteractiveController?
    
    // forwarding

    override func responds(to aSelector: Selector!) -> Bool {
        if super.responds(to: aSelector) {
            return true
        } else if navigationControllerDelegateProxy?.responds(to: aSelector) ?? false {
            return true
        } else {
            return false
        }
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if navigationControllerDelegateProxy?.responds(to: aSelector) ?? false {
            return navigationControllerDelegateProxy
        } else {
            return nil
        }
    }
}

extension CircularRevealTransition {
    
    func enable(navigationControllerDelegateProxy: UINavigationControllerDelegate? = nil) {
        navigationController.delegate = self
        enableInteractivePop()
        self.navigationControllerDelegateProxy = navigationControllerDelegateProxy
    }
    
    func disable() {
        navigationController.delegate = navigationControllerDelegateProxy ?? nil
        disableInteractivePop()
    }
    
    func enableInteractivePop() {
        interactiveController = CircularRevealTransitionInteractiveController(transitionAnimator: animator)
        interactiveController!.enableInteractivePop(onNaivigationController: navigationController)
    }
    
    func disableInteractivePop() {
        interactiveController?.disableInteractivePop()
        interactiveController = nil
    }
}

extension CircularRevealTransition: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.operation = operation
        return animator
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveController?.interactiveTransition
    }
}

