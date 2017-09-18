//
//  BSCalendarDayCollectionReusableView.swift
//  blurryssky
//
//  Created by 张亚东 on 16/4/27.
//  Copyright © 2016年 doyen. All rights reserved.
//

import UIKit

public enum BSCalendarViewSeparatorStyle {
    case relativeMargin(margin: CGFloat)
    case none
}

class BSCalendarDayCollectionReusableHeaderView: UICollectionReusableView {
    
    var separatorStyle: BSCalendarViewSeparatorStyle = .relativeMargin(margin: 5) {
        didSet {
            layoutIfNeeded()
        }
    }
    
    lazy var lineLayer: CAShapeLayer = {
        let lineLayer = CAShapeLayer()
        lineLayer.lineWidth = 1/UIScreen.main.scale
        return lineLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(lineLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let path = UIBezierPath()
        
        switch separatorStyle {
        case .relativeMargin(let margin):
            path.move(to: CGPoint(x: margin, y: bs.height/2))
            path.addLine(to: CGPoint(x: bs.width - margin * 2, y: bs.height/2))
        case .none:
            break
        }

        lineLayer.path = path.cgPath;
    }
}
