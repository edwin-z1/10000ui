//
//  LayerPercentDrivenInteractiveTransition.swift
//  10000ui-swift
//
//  Created by 张亚东 on 03/11/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import UIKit

class LayerPercentDrivenInteractiveTransition: NSObject {
    
    fileprivate(set) var percentComplete: CGFloat = 0
    
    init(transitionAnimator: UIViewControllerAnimatedTransitioning) {
        super.init()
        self.transitionAnimator = transitionAnimator
    }
    
    fileprivate weak var transitionAnimator: UIViewControllerAnimatedTransitioning!
    fileprivate weak var transitionContext: UIViewControllerContextTransitioning?
    fileprivate var pausedTime: CFTimeInterval = 0
    
    func update(_ percentComplete: CGFloat) {
        guard let transitionContext = transitionContext else { return }
        
        self.percentComplete = percentComplete
        
        transitionContext.updateInteractiveTransition(percentComplete)
        
        let duration = transitionAnimator.transitionDuration(using: transitionContext)
        let timeElapsed = duration * CFTimeInterval(percentComplete)
        transitionContext.containerView.layer.timeOffset = pausedTime + timeElapsed
    }
    
    /* 需要让layer做 reverse 动画到起始状态 但是下面的实现方法存在问题 [不能准确的停止在起始状态]
     
    func cancel() {
        
        transitionContext.cancelInteractiveTransition()
        
        let layer = transitionContext.containerView.layer
        layer.speed = -1.0
        layer.beginTime = CACurrentMediaTime()
        
        let duration = transitionAnimator.transitionDuration(using: transitionContext)
        let timeElapsed = duration * CFTimeInterval(percentComplete)
        DispatchQueue.main.asyncAfter(deadline: .now() + timeElapsed) {
            layer.speed = 1
        }
    }
     */
    
    func finish() {
        guard let transitionContext = transitionContext else { return }
        transitionContext.finishInteractiveTransition()
        resumeContainerLayer()
    }
}

fileprivate extension LayerPercentDrivenInteractiveTransition {
    
    // 把layer停下来 让手势来继续更新
    func pauseContainerLayer() {
        guard let transitionContext = transitionContext else { return }
        let layer = transitionContext.containerView.layer
        // 1.速度为0 让动画停止
        layer.speed = 0
        // 2.把时间偏移量设置到现在的时间 也就是当前layer是什么样 就定格成什么样
        pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.timeOffset = pausedTime
    }
    
    // 接着layer当前的状态 让动画持续到结束
    func resumeContainerLayer() {
        guard let transitionContext = transitionContext else { return }
        let layer = transitionContext.containerView.layer

        // 1.将开始时间偏移到现在的位置 让动画接着在停止的地方继续
        let pausedTime = layer.timeOffset
        let timeElapsed = CACurrentMediaTime() - pausedTime
        layer.beginTime = timeElapsed
        // 2.将时间偏移量还原为0
        layer.timeOffset = 0

        // 3.让动画继续动起来
        layer.speed = 1
        
        
        /* 下面是另一种实现方式
         
        let layer = transitionContext.containerView.layer
        let pausedTime = layer.timeOffset
        
        layer.speed = 1
        layer.timeOffset = 0
        
        print(layer.convertTime(CACurrentMediaTime(), from: nil))
        
        layer.beginTime = 0
        
        print(layer.convertTime(CACurrentMediaTime(), from: nil))
        
        let timeElapsed = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeElapsed
        
        print(layer.convertTime(CACurrentMediaTime(), from: nil))
        */
    }
}

extension LayerPercentDrivenInteractiveTransition: UIViewControllerInteractiveTransitioning {
    
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        percentComplete = 0
        transitionAnimator.animateTransition(using: transitionContext)
        pauseContainerLayer()
    }
    
    var completionSpeed: CGFloat {
        return 1 - percentComplete
    }
}
