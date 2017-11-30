//
//  RectFillLabel.swift
//  10000ui-swift
//
//  Created by 张亚东 on 30/11/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import UIKit

class RectFillLabel: UILabel {
    
    var progress: Float = 0 {
        didSet {
            progress = max(0, min(1, progress))
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1).setFill()

        let rect = CGRect(origin: .zero, size: .init(width: bounds.width * CGFloat(progress), height: bounds.height))
        UIBezierPath(rect: rect).fill(with: .sourceIn, alpha: 1)
//        UIRectFillUsingBlendMode(rect, .sourceIn)
    }
}
