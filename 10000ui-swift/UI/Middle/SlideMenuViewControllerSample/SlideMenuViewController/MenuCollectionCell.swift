//
//  VideoMenuCollectionCell.swift
//  kuso
//
//  Created by blurryssky on 2018/5/24.
//  Copyright © 2018年 blurryssky. All rights reserved.
//

import UIKit

class MenuCollectionCell: UICollectionViewCell {
    
    var menuText: String! {
        didSet {
            label.text = menuText
        }
    }
    
    var ratio: CGFloat! {
        didSet {
            label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6).bs.convert(to: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), multiplier: ratio)
        }
    }
    
    @IBOutlet weak var label: UILabel!
    
}
