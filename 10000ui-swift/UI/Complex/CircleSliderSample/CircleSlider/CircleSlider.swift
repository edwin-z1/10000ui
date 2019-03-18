//
//  CircleSlider.swift
//  10000ui-swift
//
//  Created by 张亚东 on 16/5/25.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

import UIKit

class CircleSlider: UIControl {

    // MARK: - Public
    
    /// cannot set more than maxRadius, maxRadius depends on bounds and thumb image
    var radius: CGFloat = 0 {
        didSet {
            guard radius != oldValue else {
                return
            }
            setNeedsLayout()
        }
    }
    
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
    
    
    /// default 0.0. means the start point is head straight to North
    var startAngleFromNorth: CGFloat = 0 {
        didSet {
            setupPath()
            value = min(maximumValue, max(minimumValue, value))
        }
    }
    
    /// default 2pi. means a complete circle
    var circumAngle = CGFloat.pi * 2 {
        didSet {
            setupPath()
            value = min(maximumValue, max(minimumValue, value))
        }
    }
    
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
    
    fileprivate lazy var pathAnimation: CAKeyframeAnimation = {
        let path: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")
        path.duration = 0.25
        path.fillMode = CAMediaTimingFillMode.forwards
        path.isRemovedOnCompletion = false
        path.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        path.calculationMode = CAAnimationCalculationMode.paced
        return path
    }()
    
    fileprivate lazy var strokeEndAnimation: CABasicAnimation = {
        
        let strokeEnd: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.duration = 0.25
        strokeEnd.fillMode = CAMediaTimingFillMode.forwards
        strokeEnd.isRemovedOnCompletion = false
        strokeEnd.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
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
        layer.lineCap = CAShapeLayerLineCap.round
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
        
        radius = min(maxRadius, max(0, radius))
        
        setupPath()
        maximumGradientLayer.frame = bounds
        minimumGradientLayer.frame = bounds
        update()
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        return isInRespondsArea(withTouchLocation: touch.location(in: self))
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let touchLocation = touch.location(in: self)
        
        let fixedThumbCurrentAngle = (centerInBounds.bs.angleFromNorth(withRelativePoint: thumbImgView.center) - startAngleFromNorth).bs.circumPositiveValue
        let fixedTouchLocationAngle = (centerInBounds.bs.angleFromNorth(withRelativePoint: touchLocation) - startAngleFromNorth).bs.circumPositiveValue
        
        let absAngle = abs(fixedTouchLocationAngle - fixedThumbCurrentAngle)
        guard absAngle <= .pi/4 else {
            return true
        }
        
        let fraction = fixedTouchLocationAngle / circumAngle
        value = getPinnedValue(withFraction: fraction)
        return true
    }
}

extension CircleSlider {
    
    func setValue(value: CGFloat, animated: Bool) {
        
        if animated == false {
            self.value = value
            
        } else {
            
            guard isAnimating == false else {
                return
            }
            isAnimating = true
            
            let targetValue = min(maximumValue, max(minimumValue, value))
            
            let fromFraction = getPinnedFraction(withValue: self.value)
            let toFraction = getPinnedFraction(withValue: targetValue)
            
            strokeEndAnimation.fromValue = fromFraction
            strokeEndAnimation.toValue = toFraction
            minimumTrackLayer.add(strokeEndAnimation, forKey: "stroke_end")
            
            var path = getCirclePath(fromFraction: fromFraction, toFraction: toFraction)
            if self.value > targetValue {
                path = getCirclePath(fromFraction: fromFraction, toFraction: toFraction, clockwise: false)
            }
            pathAnimation.path = path.cgPath
            thumbImgView.layer.add(pathAnimation, forKey: "position")
        }
    }
}

fileprivate extension CircleSlider {
    
    var centerInBounds: CGPoint {
        return CGPoint(x: bounds.width/2, y: bounds.height/2)
    }
    
    var maxRadius: CGFloat {
        var radius = min(bounds.width, bounds.height)/2
        
        if let thumbImage = thumbImage {
            radius -= max(max(thumbImage.size.width, thumbImage.size.height), lineWidth)/2
        } else {
            radius -= lineWidth/2
        }
        
        return radius
    }
    
    func setup(){
        
        radius = maxRadius
        layer.addSublayer(maximumGradientLayer)
        layer.addSublayer(minimumGradientLayer)
        addSubview(thumbImgView)
    }
    
    func setupPath() {
        let path = getCirclePath()
        minimumTrackLayer.path = path.cgPath
        maximumTrackLayer.path = path.cgPath
    }
    
    func update() {
        guard maximumValue > minimumValue else {
            return
        }
        if value != lastValue {
            sendActions(for: UIControl.Event.valueChanged)
        }
        lastValue = value
        
        let fraction = getPinnedFraction(withValue: value)
        
        // 设置thumb的位置
        let angle = getAngle(withFraction: fraction)
        let thumbCenter = centerInBounds.bs.offset(angleFromEast: angle, distance: radius)
        thumbImgView.center = thumbCenter

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        // 设置进度条位置
        minimumTrackLayer.strokeEnd = CGFloat(fraction)
        
        // 设置渐变色
        let startAngle = startAngleFromNorth - .pi/2 
        let thumbStartPoint = centerInBounds.bs.offset(angleFromEast: startAngle, distance: radius)
        let symmetryPoint = centerInBounds.bs.offset(angleFromEast: (startAngle + .pi).bs.circumPositiveValue, distance: radius)
        
        let gradientStartPoint = CGPoint(x: thumbStartPoint.x/bounds.width, y: thumbStartPoint.y/bounds.height)
        let gradientEndPoint = CGPoint(x: symmetryPoint.x/bounds.width, y: symmetryPoint.y/bounds.height)
        maximumGradientLayer.startPoint = gradientStartPoint
        maximumGradientLayer.endPoint = gradientEndPoint
        
        minimumGradientLayer.startPoint = gradientStartPoint
        minimumGradientLayer.endPoint = gradientEndPoint
        
        CATransaction.commit()
    }
    
    func getAngle(withFraction fraction: CGFloat) -> CGFloat {
        return fraction * circumAngle - .pi/2 + startAngleFromNorth
    }
    
    func getPinnedFraction(withValue value: CGFloat) -> CGFloat {
        return (value - minimumValue)/(maximumValue - minimumValue)
    }
    
    func getPinnedValue(withFraction fraction: CGFloat) -> CGFloat {
        return fraction*(maximumValue - minimumValue) + minimumValue
    }
    
    func getCirclePath(fromFraction: CGFloat = 0, toFraction: CGFloat = 1, clockwise: Bool = true) -> UIBezierPath {
        
        let startAngle = getAngle(withFraction: fromFraction)
        let endAngle = getAngle(withFraction: toFraction)
        
        let path = UIBezierPath()
        path.addArc(withCenter: centerInBounds, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        return path
    }
    
    func isInRespondsArea(withTouchLocation touchLocation: CGPoint) -> Bool {
        
        let dx = abs(touchLocation.x - thumbImgView.center.x)
        let dy = abs(touchLocation.y - thumbImgView.center.y)
        let dis = hypot(dx, dy)
        var respondsRadius = thumbExtendRespondsRadius
        if let thumbImage = thumbImage {
            respondsRadius += min(thumbImage.size.width, thumbImage.size.height)/2
        }
        return dis < respondsRadius
    }
}

extension CircleSlider: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        value = getPinnedValue(withFraction: strokeEndAnimation.toValue as! CGFloat)
        
        minimumTrackLayer.removeAllAnimations()
        thumbImgView.layer.removeAllAnimations()
        isAnimating = false
    }
}
