//
//  CircularRevealTransitionAnimator.swift
//  10000ui-swift
//
//  Created by 张亚东 on 06/11/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import UIKit

class CircularRevealTransitionAnimator: NSObject {

    var fromCenter: CGPoint = .zero
    var operation: UINavigationController.Operation = .push {
        didSet {
            let smallCirclePath = UIBezierPath(arcCenter: fromCenter, radius: 1, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true).cgPath
            let bigCirclePath = UIBezierPath(arcCenter: fromCenter, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true).cgPath
            switch operation {
            case .pop:
                fromPath = bigCirclePath
                toPath = smallCirclePath
            default:
                fromPath = smallCirclePath
                toPath = bigCirclePath
            }
        }
    }
    fileprivate(set) weak var transitionContext: UIViewControllerContextTransitioning?
    
    fileprivate var fromPath: CGPath!
    fileprivate var toPath: CGPath!
    
    fileprivate var radius: CGFloat {
        let screenSize = UIScreen.main.bounds.size
        let w = screenSize.width
        let h = screenSize.height
        
        let left = fromCenter.x
        let right = w - left
        let top = fromCenter.y
        let bottom = h - top
        
        let maxH = max(left, right)
        let maxV = max(top, bottom)
        
        let r = sqrt(pow(maxH, 2) + pow(maxV, 2))
        return r
    }
    
}

extension CircularRevealTransitionAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        
        let maskLayer = CAShapeLayer()

        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        switch operation {
        case .push:
            toView.layer.mask = maskLayer
            containerView.addSubview(toView)
        case .pop:
            let fromView = transitionContext.view(forKey: .from)!
            fromView.layer.mask = maskLayer
            containerView.insertSubview(toView, belowSubview: fromView)
        default:
            return
        }
        
        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = fromPath
        maskLayerAnimation.toValue = toPath
        maskLayerAnimation.duration = transitionDuration(using: transitionContext)
        maskLayerAnimation.delegate = self
        maskLayerAnimation.fillMode = CAMediaTimingFillMode.both;
        maskLayerAnimation.isRemovedOnCompletion = false
        maskLayerAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        maskLayerAnimation.setValue(transitionContext, forKey: "transitionContext")
        maskLayer.add(maskLayerAnimation, forKey: "path")
    }
}

extension CircularRevealTransitionAnimator: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let transitionContext = anim.value(forKey: "transitionContext") as! UIViewControllerContextTransitioning
        
        switch operation {
        case .pop:
            let fromView = transitionContext.view(forKey: .from)!
            fromView.layer.mask = nil
        default:
            let toView = transitionContext.view(forKey: .to)!
            toView.layer.mask = nil
        }
        
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
}
