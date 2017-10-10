//
//  SeparatorLabel.swift
//  10000ui-swift
//
//  Created by 张亚东 on 18/05/2017.
//  Copyright © 2017 Jumei. All rights reserved.
//

import UIKit

class SeparatorLabel: UILabel {
    
    @IBInspectable var separatorColor: UIColor?
    @IBInspectable var separatorWidth: CGFloat = 90
    @IBInspectable var spacing: CGFloat = 16
    @IBInspectable var lineWidth: CGFloat = 1

    override func drawText(in rect: CGRect) {
        
        let textRectForBounds = textRect(forBounds: rect, limitedToNumberOfLines: numberOfLines)
        //获得处理的上下文
        let context = UIGraphicsGetCurrentContext()
        //设置线条样式
        context?.setLineCap(.butt)
        //设置线条粗细宽度
        context?.setLineWidth(lineWidth)
        //设置颜色
        context?.setStrokeColor(separatorColor?.cgColor ?? textColor.cgColor)
        //开始一个起始路径
        context?.beginPath()
        //起始点
        context?.move(to: CGPoint(x: textRectForBounds.origin.x - spacing, y: rect.height/2))
        //设置下一个坐标点
        context?.addLine(to: CGPoint(x: textRectForBounds.origin.x - spacing - separatorWidth, y: rect.height/2))
        //起始点
        context?.move(to: CGPoint(x: textRectForBounds.origin.x + textRectForBounds.width + spacing, y: rect.height/2))
        //设置下一个坐标点
        context?.addLine(to: CGPoint(x: textRectForBounds.origin.x + textRectForBounds.width + spacing + separatorWidth, y: rect.height/2))
        //连接上面定义的坐标点
        context?.strokePath()
        
        super.drawText(in: rect)
    }
}
