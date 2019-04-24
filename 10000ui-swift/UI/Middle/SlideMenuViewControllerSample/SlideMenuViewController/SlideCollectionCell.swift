//
//  SlideCollectionCell.swift
//  Kuso
//
//  Created by blurryssky on 2018/7/26.
//  Copyright © 2018年 blurryssky. All rights reserved.
//

import UIKit

import SnapKit

class SlideCollectionCell: UICollectionViewCell {
    
    var viewController: UIViewController? {
        didSet {
            add()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        remove()
    }
    
    func add() {
        guard let vc = viewController else {
            return
        }
        contentView.addSubview(vc.view)
        vc.view.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    func remove() {
        viewController?.willMove(toParent: nil)
        viewController?.view.removeFromSuperview()
        viewController?.removeFromParent()
    }
}

