//
//  PetalLayoutSampleCollectionCell.swift
//  10000ui-swift
//
//  Created by blurryssky on 2018/1/25.
//  Copyright © 2018年 blurryssky. All rights reserved.
//

import UIKit

class PetalLayoutSampleCollectionCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.bs.random(alpha: 0.5)
    }
}
