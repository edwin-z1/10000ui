//
//  UICollectionViewFlowLayout+NameBox.swift
//  kuso
//
//  Created by blurryssky on 2018/6/14.
//  Copyright © 2018年 blurryssky. All rights reserved.
//

import Foundation

extension NamespaceBox where T: UICollectionView {
    
    func caculateItemWidth(hCount: Int) -> CGFloat {
        
        let layout = base.collectionViewLayout as! UICollectionViewFlowLayout
        let hInsets = layout.sectionInset.left + layout.sectionInset.right
        let hSpacing = CGFloat(hCount - 1) * layout.minimumInteritemSpacing
        let itemWidth = CGFloat(floor((base.bs.width - hInsets - hSpacing)/CGFloat(hCount)))
        
        return itemWidth
    }
    
    func caculateInteritemSpacing(hCount: Int) -> CGFloat {
        
        let layout = base.collectionViewLayout as! UICollectionViewFlowLayout
        let hInsets = layout.sectionInset.left + layout.sectionInset.right
        let itemWidth = layout.itemSize.width
        let totalWidth = base.bs.width - hInsets - itemWidth * CGFloat(hCount)
        let interitemSpacing = CGFloat(floor(totalWidth/CGFloat(hCount - 1)))
        return interitemSpacing
    }
}
