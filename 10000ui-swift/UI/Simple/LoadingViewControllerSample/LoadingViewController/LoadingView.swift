//
//  LoadingView.swift
//  10000ui-swift
//
//  Created by 张亚东 on 11/10/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    fileprivate lazy var indicatorLayer : CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        layer.position = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        layer.path = UIBezierPath(arcCenter: CGPoint(x: layer.bounds.width / 2, y: layer.bounds.height / 2), radius: layer.bounds.width / 2, startAngle: 0, endAngle: 2 * CGFloat.pi , clockwise: true).cgPath
        layer.lineWidth = 3
        layer.strokeColor = UIColor.lightGray.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeEnd = 0
        layer.strokeStart = 0
        return layer
    }()

    fileprivate lazy var strokeEndAnimation : CABasicAnimation = {
        let end = CABasicAnimation(keyPath: "strokeEnd")
        end.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        end.duration = 1
        end.fromValue = 0
        end.toValue = 0.95
        end.isRemovedOnCompletion = false
        end.fillMode = CAMediaTimingFillMode.forwards
        return end
    }()
    
    fileprivate lazy var strokeStartAnimation : CABasicAnimation = {
        let start = CABasicAnimation(keyPath: "strokeStart")
        start.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        start.duration = 1
        start.fromValue = 0
        start.toValue = 0.95
        start.beginTime = 1
        start.isRemovedOnCompletion = false
        start.fillMode = CAMediaTimingFillMode.forwards
        
        return start
    }()
    
    fileprivate lazy var animationGroup : CAAnimationGroup = {
        let group = CAAnimationGroup()
        group.animations = [self.strokeEndAnimation,self.strokeStartAnimation]
        group.repeatCount = HUGE
        group.duration = 2
        return group
    }()
    
    fileprivate lazy var rotateZAnimation : CABasicAnimation = {
        let rotateZ = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateZ.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        rotateZ.duration = 2
        rotateZ.fromValue = 0
        rotateZ.toValue = 2 * CGFloat.pi
        rotateZ.repeatCount = HUGE
        return rotateZ
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoadingView {
    
    func startAnimation() {
        indicatorLayer.add(animationGroup, forKey: "group")
        indicatorLayer.add(rotateZAnimation, forKey: "rotationZ")
    }
    
    func endAnimation() {
        indicatorLayer.removeAllAnimations()
    }
}

fileprivate extension LoadingView {
    
    func setup() {
        layer.addSublayer(indicatorLayer)
    }
}

