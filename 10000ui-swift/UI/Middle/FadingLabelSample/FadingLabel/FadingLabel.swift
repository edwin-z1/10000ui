//
//  FadingLabel.swift
//  10000ui-swift
//
//  Created by 张亚东 on 25/10/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import UIKit

enum FadingType {
    case `in`
    case out
}

enum FadingMode {
    case order(eachCharacterDuration: CFTimeInterval)
    
    case random(totalDuration: CFTimeInterval, strategy: FadingMode.RandomStrategy)
    enum RandomStrategy {
        /// 每次刷新所有字符, 字符串较长时可能会产生卡顿
        case all
        /// 每次更新部分字符, 不会产生卡顿, 但每次更新可能不会连续更新同一个字符
        case partly(maxCount: Int)
    }
}

class FadingLabel: UILabel {
    
    fileprivate(set) var isAnimating = false
    fileprivate var displayLink: CADisplayLink!
    fileprivate var fadingType: FadingType!
    fileprivate var fadingMode: FadingMode!
    fileprivate var startTime: CFTimeInterval!
    
    // for FadingMode.random use
    fileprivate var eachCharacterDurations: [CFTimeInterval] = []
    
    override var text: String? {
        set {
            if let text = newValue {
                attributedText = NSAttributedString(string: text)
            } else {
                super.text = nil
            }
        }
        get {
            return attributedText?.string
        }
    }
    
    override var attributedText: NSAttributedString? {
        set {
            super.attributedText = newAttributedStringWithTextColorAlpha0(newValue)
        }
        get {
            return super.attributedText
        }
    }
}

extension FadingLabel {
    
    func fade(mode: FadingMode, type: FadingType) {
        
        guard let attributedText = attributedText, !isAnimating else { return }
        
        isAnimating = true
        
        fadingType = type
        fadingMode = mode
        
        if case let .random(totalDuration, _) = fadingMode! {
            eachCharacterDurations.removeAll()
            (0..<attributedText.length).forEach({ _ in
                let eachCharacterDuration = randomDoubleDivideBy(double: totalDuration)
                eachCharacterDurations.append(eachCharacterDuration)
            })
        }
        
        startTime = CACurrentMediaTime()
        displayLink = CADisplayLink(target: self, selector: #selector(handleDisplayLink))
        displayLink.add(to: .current, forMode: .commonModes)
    }
}

fileprivate extension FadingLabel {

    func newAttributedStringWithTextColorAlpha0(_ attributedText: NSAttributedString?) -> NSMutableAttributedString? {
        guard let attributedText = attributedText else { return nil }
        
        let mutableAttributedText = attributedText.mutableCopy() as! NSMutableAttributedString
        
        mutableAttributedText.enumerateAttribute(.foregroundColor, in: .init(location: 0, length: mutableAttributedText.length), options: .longestEffectiveRangeNotRequired) { (value, range, stop) in
            var attributes: [NSAttributedStringKey: UIColor] = [.foregroundColor: textColor.withAlphaComponent(0)]
            if let color = value as? UIColor {
                attributes = [.foregroundColor : color.withAlphaComponent(0)]
            }
            mutableAttributedText.setAttributes(attributes, range: range)
        }
        return mutableAttributedText
    }
    
    func randomDoubleDivideBy(double: Double) -> Double {
        // 默认保留两位小数 所以缩放100 两位小数里最小的是0.01
        let multiplied = UInt32(double * 100)
        let remainder = max(0.01, Double(arc4random()%multiplied))
        let divisor = remainder/100
        
        return divisor
    }
    
    @objc func handleDisplayLink() {
        
        switch fadingMode! {
        case let .order(eachCharacterDuration):
            handleDisplayLinkFadeModeOrder(eachCharacterDuration: eachCharacterDuration)
        case let .random(totalDuration, strategy):
            switch strategy {
            case .all:
                handleDisplayLinkFadeModeRandomWithStrategyAll(totalDuration: totalDuration)
            case let .partly(maxCount):
                handleDisplayLinkFadeModeRandomWithStrategyPartly(maxCount: maxCount)
            }
        }
    }
    
    func handleDisplayLinkFadeModeOrder(eachCharacterDuration: CFTimeInterval) {

        let attributedLength = attributedText!.length
        let effectedLength = max(floor(Double(attributedLength) * 0.1), 5)
        let averageDelay = eachCharacterDuration/effectedLength
        
        let elapsedTime = CACurrentMediaTime() - startTime
        
        var mAttributedText = attributedText!.mutableCopy() as! NSMutableAttributedString
        var isFinished = false
        
        for index in (0..<mAttributedText.length) {
            let delay = averageDelay * CFTimeInterval(index)
            let percentage = getConvertedPercentage(percentage: (elapsedTime - delay)/eachCharacterDuration)
            modifyAttributedStringTextColor(&mAttributedText, textIndex: index, textColorPercentage: CGFloat(percentage))
            
            if index == attributedLength - 1 {
                switch fadingType! {
                case .in:
                    isFinished = percentage == 1
                case .out:
                    isFinished = percentage == 0
                }
            }
        }
        super.attributedText = mAttributedText
        
        if isFinished {
            isAnimating = false
            displayLink.invalidate()
        }
    }
    
    func handleDisplayLinkFadeModeRandomWithStrategyAll(totalDuration: CFTimeInterval) {

        let elapsedTime = CACurrentMediaTime() - startTime
        
        var mAttributedText = attributedText!.mutableCopy() as! NSMutableAttributedString
        
        for index in (0..<mAttributedText.length) {
            let eachCharacterDuration = eachCharacterDurations[index]
            let percentage = getConvertedPercentage(percentage: elapsedTime/eachCharacterDuration)
            modifyAttributedStringTextColor(&mAttributedText, textIndex: index, textColorPercentage: CGFloat(percentage))
        }
        super.attributedText = mAttributedText
        
        if elapsedTime > totalDuration {
            isAnimating = false
            displayLink.invalidate()
        }
    }
    
    func handleDisplayLinkFadeModeRandomWithStrategyPartly(maxCount: Int) {
        
        let elapsedTime = CACurrentMediaTime() - startTime
        
        var mAttributedText = attributedText!.mutableCopy() as! NSMutableAttributedString
        
        // 随机取出最多50个需要更新的character index 如果一次性更新所有的character 数量过多时会掉帧
        let updateIndex = getUpdateIndexes(maxCount: maxCount)
        
        let isFinished = updateIndex.count == 0
        guard !isFinished else {
            isAnimating = false
            displayLink.invalidate()
            return
        }
        
        for index in updateIndex {
            let eachCharacterDuration = eachCharacterDurations[index]
            let percentage = getConvertedPercentage(percentage: elapsedTime/eachCharacterDuration)
            modifyAttributedStringTextColor(&mAttributedText, textIndex: index, textColorPercentage: CGFloat(percentage))
        }
        super.attributedText = mAttributedText
    }
    
    func getUpdateIndexes(maxCount: Int) -> [Int] {
        let attributedLength = attributedText!.length
        let filter: (Int) -> Bool = {
            let color = self.attributedText!.attributes(at: $0, effectiveRange: nil)[.foregroundColor] as! UIColor
            let alpha = color.cgColor.alpha
            var targetAlpha: CGFloat = 1
            if self.fadingType == .out {
                targetAlpha = 0
            }
            return alpha != targetAlpha
        }
        
        var allIndexes = (0..<attributedLength).map { $0 }.filter(filter)
        
        var indexes: [Int] = []
        while indexes.count < maxCount,
            allIndexes.count != 0 {
                let randomIndex = Int(arc4random())%(allIndexes.count)
                let random = allIndexes.remove(at: randomIndex)
                indexes.append(random)
        }

        return indexes
    }
    
    func getConvertedPercentage(percentage: Double) -> Double {
        var percentage = min(1, max(0, percentage))
        if fadingType == .out {
            percentage = 1 - percentage
        }
        return percentage
    }
    
    func modifyAttributedStringTextColor(_ attributedString: inout NSMutableAttributedString, textIndex index: Int, textColorPercentage percentage: CGFloat) {
        
        let color = attributedString.attributes(at: index, effectiveRange: nil)[.foregroundColor] as! UIColor
        let range = NSRange(location: index, length: 1)
        let attributes: [NSAttributedStringKey: UIColor] = [.foregroundColor: color.withAlphaComponent(percentage)]
        attributedString.setAttributes(attributes, range: range)
    }
}

