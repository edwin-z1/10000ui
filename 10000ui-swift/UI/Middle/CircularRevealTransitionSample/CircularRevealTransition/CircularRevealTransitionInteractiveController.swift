//
//  CircularRevealTransitionInteractiveController.swift
//  10000ui-swift
//
//  Created by 张亚东 on 06/11/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import UIKit

class CircularRevealTransitionInteractiveController: NSObject {

    /// 用于记录以前转场用的fromCenter 在返回手势开始的时候去取正确的fromCenter 保证连续手势pop的时候显示正确
    var fromCenterDict: [Int: CGPoint] = [:]
    
    fileprivate(set) var interactiveTransition: LayerPercentDrivenInteractiveTransition?
    
    init(transitionAnimator: CircularRevealTransitionAnimator) {
        super.init()
        self.transitionAnimator = transitionAnimator
    }
    
    fileprivate weak var transitionAnimator: CircularRevealTransitionAnimator!
    fileprivate weak var navigationController: UINavigationController!
    fileprivate var pan: UIPanGestureRecognizer?
}

extension CircularRevealTransitionInteractiveController {
    
    func enableInteractivePop(onNaivigationController navigationController: UINavigationController) {
        self.navigationController = navigationController
        pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        navigationController.view.addGestureRecognizer(pan!)
    }
    
    func disableInteractivePop() {
        if let pan = pan {
            navigationController.view.removeGestureRecognizer(pan)
        }
    }
}

fileprivate extension CircularRevealTransitionInteractiveController {

    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        switch gestureRecognizer.state {
        case .began:
            let isInteractive = transitionAnimator.transitionContext?.isInteractive
            guard isInteractive ?? true else {
                // 防止连续滑动造成nested pop
                gestureRecognizer.isEnabled = false
                gestureRecognizer.isEnabled = true
                interactiveTransition = nil
                return
            }
            let topViewControllerIndex = navigationController.viewControllers.count - 2
            if let fromCenter = fromCenterDict[topViewControllerIndex] {
                transitionAnimator.fromCenter = fromCenter
            }
            interactiveTransition = LayerPercentDrivenInteractiveTransition(transitionAnimator: transitionAnimator)
            navigationController.popViewController(animated: true)
        case .changed:
            let translation = gestureRecognizer.translation(in: gestureRecognizer.view)
            let percentComplete = getPercentComplete(withTranslation: translation)
            interactiveTransition?.update(percentComplete)
        default:
            interactiveTransition?.finish()
            interactiveTransition = nil
        }
    }
    
    func getPercentComplete(withTranslation translation: CGPoint) -> CGFloat {
        let bounds = navigationController.view.bounds
        let xPercentComplete = fabsf(Float(translation.x/bounds.width))
        let yPercentComplete = fabsf(Float(translation.y/bounds.height))
        return CGFloat(max(xPercentComplete, yPercentComplete))
    }
}
