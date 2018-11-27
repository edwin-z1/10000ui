//
//  VideoMenuCollectionCell.swift
//  kuso
//
//  Created by blurryssky on 2018/5/24.
//  Copyright © 2018年 momo. All rights reserved.
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
            label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).bs.convert(to: #colorLiteral(red: 0.9785258174, green: 0.3886677027, blue: 0.6425039768, alpha: 1), multiplier: ratio)
        }
    }
    
    @IBOutlet weak var label: UILabel!
    
}
