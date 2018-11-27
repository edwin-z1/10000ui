//
//  AnimationSlider.swift
//  10000ui-swift
//
//  Created by blurryssky on 2018/5/1.
//  Copyright © 2018年 blurryssky. All rights reserved.
//

import UIKit

class AnimationSlider: UIControl {
    
    // MARK: - Public
    
    var thumbImage: UIImage! {
        didSet {
            guard thumbImage != nil else {
                return
            }
            thumbImgView.image = thumbImage
            thumbImgView.bounds.size = thumbImage.size
            
            setNeedsLayout()
        }
    }
    /// if the thumb image is too small, you can set this to extend the responds area
    var thumbExtendRespondsRadius: CGFloat = 0
    
    /// default 0.0. this value will be pinned to min/max
    var value: CGFloat = 0 {
        didSet {
            value = min(maximumValue, max(minimumValue, value))
            update()
        }
    }
    
    /// default 0.0. the current value may change if outside new min value
    var minimumValue: CGFloat = 0 {
        didSet {
            value = min(maximumValue, max(minimumValue, value))
        }
    }
    
    /// default 1.0. the current value may change if outside new max value
    var maximumValue: CGFloat = 1 {
        didSet {
            value = min(maximumValue, max(minimumValue, value))
        }
    }
    
    var minimunTrackTintColors = [#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)] {
        didSet {
            guard minimunTrackTintColors.count != 0 else {
                return
            }
            minimumGradientLayer.colors = minimunTrackTintColors.map({ $0.cgColor })
        }
    }
    
    var maximunTrackTintColors = [#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)] {
        didSet {
            guard maximunTrackTintColors.count != 0 else {
                return
            }
            maximumGradientLayer.colors = maximunTrackTintColors.map({ $0.cgColor })
        }
    }
    
    var lineWidth: CGFloat = 2 {
        didSet {
            minimumTrackLayer.lineWidth = lineWidth
            maximumTrackLayer.lineWidth = lineWidth
            setNeedsLayout()
        }
    }
    
    //MARK: Private
    
    fileprivate var lastValue: CGFloat = 0
    
    fileprivate var isAnimating = false {
        didSet {
            isEnabled = !isAnimating
        }
    }
    
    fileprivate lazy var positionAnimation: CABasicAnimation = {
        let position: CABasicAnimation = CABasicAnimation(keyPath: "position")
        position.fillMode = kCAFillModeForwards
        position.isRemovedOnCompletion = false
        return position
    }()
    
    fileprivate lazy var strokeEndAnimation: CABasicAnimation = {
        
        let strokeEnd: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.fillMode = kCAFillModeForwards
        strokeEnd.isRemovedOnCompletion = false
        strokeEnd.delegate = self
        return strokeEnd
    }()
    
    fileprivate lazy var thumbImgView: UIImageView = {
        return UIImageView()
    }()
    
    fileprivate lazy var minimumTrackLayer: CAShapeLayer = {
        let layer: CAShapeLayer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = self.lineWidth
        layer.strokeColor = UIColor.black.cgColor
        layer.strokeEnd = 0
        layer.lineCap = kCALineCapRound
        return layer
    }()
    
    fileprivate lazy var minimumGradientLayer: CAGradientLayer = {
        let layer: CAGradientLayer = CAGradientLayer()
        layer.colors = self.minimunTrackTintColors.map({ $0.cgColor })
        layer.mask = self.minimumTrackLayer
        return layer
    }()
    
    fileprivate lazy var maximumTrackLayer: CAShapeLayer = {
        let layer: CAShapeLayer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = self.lineWidth
        layer.strokeColor = UIColor.black.cgColor
        return layer
    }()
    
    fileprivate lazy var maximumGradientLayer: CAGradientLayer = {
        let layer: CAGradientLayer = CAGradientLayer()
        layer.colors = self.maximunTrackTintColors.map({ $0.cgColor })
        layer.mask = self.maximumTrackLayer
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        thumbImgView.center = CGPoint(x: 0, y: bounds.height/2)
        setupLayers()
        update()
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        return isInRespondsArea(withTouchLocation: touch.location(in: self))
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let touchLocation = touch.location(in: self)
        
        value = touchLocation.x/bounds.width * maximumValue
        return true
    }
}

extension AnimationSlider {
    
    func setValue(value: CGFloat, duration: TimeInterval) {
        
        guard isAnimating == false else {
            return
        }
        isAnimating = true
        
        let targetValue = min(maximumValue, max(minimumValue, value))
        
        positionAnimation.fromValue = thumbImgView.center
        positionAnimation.toValue = CGPoint(x: targetValue * bounds.width, y: bounds.height/2)
        positionAnimation.duration = duration
        thumbImgView.layer.add(positionAnimation, forKey: "position")
        
        strokeEndAnimation.fromValue = minimumTrackLayer.strokeEnd
        strokeEndAnimation.toValue = value
        strokeEndAnimation.duration = duration
        minimumTrackLayer.add(strokeEndAnimation, forKey: "stroke_end")
    }
    
    func increaseValueToMaximum(duration: TimeInterval) {
        setValue(value: 1, duration: duration)
    }
    
    func stopIncrese() {
        
        if let presentation = thumbImgView.layer.presentation() {
            value = presentation.position.x/bounds.width * maximumValue
        }
        thumbImgView.layer.removeAllAnimations()
        minimumTrackLayer.removeAllAnimations()
    }
}

fileprivate extension AnimationSlider {

    func setup(){

        layer.addSublayer(maximumGradientLayer)
        layer.addSublayer(minimumGradientLayer)
        addSubview(thumbImgView)
    }
    
    func setupLayers() {
        
        let path = UIBezierPath()
        path.move(to: .init(x: 0, y: bounds.height/2))
        path.addLine(to: .init(x: bounds.width, y: bounds.height/2))
        minimumTrackLayer.path = path.cgPath
        maximumTrackLayer.path = path.cgPath
        
        maximumGradientLayer.frame = bounds
        minimumGradientLayer.frame = bounds
        
        // 设置渐变色
        let gradientStartPoint = CGPoint(x: 0, y: bounds.height/2)
        let gradientEndPoint = CGPoint(x: bounds.width, y: bounds.height/2)
        maximumGradientLayer.startPoint = gradientStartPoint
        maximumGradientLayer.endPoint = gradientEndPoint
        
        minimumGradientLayer.startPoint = gradientStartPoint
        minimumGradientLayer.endPoint = gradientEndPoint
        
    }
    
    func update() {
        guard maximumValue > minimumValue else {
            return
        }
        if value != lastValue {
            sendActions(for: UIControlEvents.valueChanged)
        }
        lastValue = value
        
        // 设置thumb的位置
        thumbImgView.center.x = bounds.width * value

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        // 设置进度条位置
        minimumTrackLayer.strokeEnd = value
        
        CATransaction.commit()
    }
    
    func isInRespondsArea(withTouchLocation touchLocation: CGPoint) -> Bool {
        
        let dx = fabs(touchLocation.x - thumbImgView.center.x)
        let dy = fabs(touchLocation.y - thumbImgView.center.y)
        let dis = hypot(dx, dy)
        var respondsRadius = thumbExtendRespondsRadius
        if let thumbImage = thumbImage {
            respondsRadius += min(thumbImage.size.width, thumbImage.size.height)/2
        }
        return dis < respondsRadius
    }
}

extension AnimationSlider: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let presentation = thumbImgView.layer.presentation() {
            value = presentation.position.x/bounds.width * maximumValue
        }
        
        minimumTrackLayer.removeAllAnimations()
        thumbImgView.layer.removeAllAnimations()
        isAnimating = false
    }
}
