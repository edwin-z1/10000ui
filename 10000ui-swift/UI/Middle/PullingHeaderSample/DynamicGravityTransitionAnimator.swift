//
//  DynamicGravityTransitionAnimator.swift
//  10000ui-swift
//
//  Created by blurryssky on 2018/2/26.
//  Copyright © 2018年 blurryssky. All rights reserved.
//

import Foundation

class DynamicGravityTransitionAnimator: NSObject {
    
    var isPresent = true
    var dynamicAnimator: UIDynamicAnimator!
    weak var transitionContext: UIViewControllerContextTransitioning!
}

extension DynamicGravityTransitionAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        if isPresent {
            presentAnimation()
        } else {
            dismissAnimation()
        }
    }
    
    func presentAnimation() {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        containerView.addSubview(toView)
        toView.bs.origin = .init(x: 0, y: -toView.bs.height)
        
        let dynamicAnimator = UIDynamicAnimator(referenceView: containerView)
        dynamicAnimator.delegate = self
        self.dynamicAnimator = dynamicAnimator
        
        let gravity = UIGravityBehavior(items: [toView])
        gravity.magnitude = 3
        dynamicAnimator.addBehavior(gravity)
        
        let collision = UICollisionBehavior(items: [toView])
        collision.collisionMode = .boundaries
        let height = containerView.bs.height + 1.5
        collision.addBoundary(withIdentifier: "bottom" as NSCopying,
                              from: .init(x: containerView.bs.origin.x, y: height),
                              to: .init(x: containerView.bs.width, y: height))
        dynamicAnimator.addBehavior(collision)
    }
    
    func dismissAnimation() {
        var gravity: UIGravityBehavior?
        var collision: UICollisionBehavior?
        for behavior in dynamicAnimator.behaviors {
            if behavior is UIGravityBehavior {
                gravity = behavior as? UIGravityBehavior
            }
            if behavior is UICollisionBehavior {
                collision = behavior as? UICollisionBehavior
            }
        }
        let existGravity = gravity!
        let existCollision = collision!
        
        existGravity.magnitude = 5
        existCollision.removeBoundary(withIdentifier: "bottom" as NSCopying)
        
        let containerView = transitionContext.containerView
        let height = containerView.bs.height * 2 + 1.5
        existCollision.addBoundary(withIdentifier: "new_bottom" as NSCopying,
                                   from: .init(x: containerView.bs.origin.x, y: height),
                                   to: .init(x: containerView.bs.width, y: height))
    }
}

extension DynamicGravityTransitionAnimator: UIDynamicAnimatorDelegate {
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        if !isPresent {
            dynamicAnimator.removeAllBehaviors()
        }
        transitionContext.completeTransition(true)
    }
}


