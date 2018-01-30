//
//  PetalLayout.swift
//  10000ui-swift
//
//  Created by blurryssky on 2018/1/24.
//  Copyright © 2018年 blurryssky. All rights reserved.
//

import UIKit

/// 一种围绕collection view center圆形排列的layout，通过itemSize和firstCircleItemInnerSpacing确定第一圈item的位置，通过itemSize和minimumInteritemSpacing计算item之间的间距，如过剩下的空间不够摆放一个了，新的item将被放置在新的外圈，可以通过设置isDivideEquallyWhenCircleFull让内圈的item均分剩余空间
class PetalLayout: UICollectionViewLayout {
    
    var itemSize = CGSize(width: 70, height: 70)
    
    /// 第一圈的item的圆周到中心点的最小距离
    var firstCircleItemInnerSpacing: CGFloat = 50
    
    /// default 0.0. means the start point is head straight to North
    var startAngleFromNorth: CGFloat = 0
    
    /// 是否顺时针
    var isClockwise = true
    
    /// 两个item的最大半径圆周之间的最小间距
    var minimumInteritemSpacing: CGFloat = 15
    
    /// 当一圈剩余的部分不够放下一个item的时候, 重新布局本圈的item, 让他们均分掉剩余部分的位置, 忽略`minimumInteritemSpacing`的值
    var isDivideInteritemSpacingEquallyWhenCircleFull = true
    
    var padding: CGFloat = 30
    
    var isAutoFocusEnabled = false
    
    fileprivate var circleAttributesArray = [PetalLayoutCircleAttributes]()
    fileprivate var layoutAttributesArray = [UICollectionViewLayoutAttributes]()
    
    fileprivate var indexPathToUpdate: [IndexPath] = []
    
    // MARK: - Layout
    
    override func prepare() {
        
        guard let itemsCount = collectionView?.numberOfItems(inSection: 0),
            // insert或者delete 还是需要更新的
            itemsCount != layoutAttributesArray.count else {
                return
        }
        updateAttributes()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributesArray = [UICollectionViewLayoutAttributes]()
        // Loop through the cache and look for items in the rect
        for attributes in layoutAttributesArray {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributesArray.append(attributes)
            }
        }
        return visibleLayoutAttributesArray
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributesArray[indexPath.row]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        let bounds = collectionView!.bounds
        if newBounds == bounds {
            return false
        } else {
            layoutAttributesArray.removeAll()
            circleAttributesArray.removeAll()
            return true
        }
    }
    
    // MARK: - Animations
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        for updateItem in updateItems {
            switch updateItem.updateAction {
            case .insert:
                if let after = updateItem.indexPathAfterUpdate {
                    indexPathToUpdate.append(after)
                }
            case .delete:
                if let before = updateItem.indexPathBeforeUpdate {
                    indexPathToUpdate.append(before)
                }
            case .move:
                if let before = updateItem.indexPathBeforeUpdate {
                    indexPathToUpdate.append(before)
                }
                if let after = updateItem.indexPathAfterUpdate {
                    indexPathToUpdate.append(after)
                }
            case .reload: fallthrough
            case .none: break
            }
        }
    }
    
    override func finalizeCollectionViewUpdates() {
        indexPathToUpdate.removeAll()
        if isAutoFocusEnabled, let cv = collectionView {
            let itemsCount = cv.numberOfItems(inSection: 0)
            if itemsCount > 1 {
                cv.scrollToItem(at: IndexPath(item: itemsCount - 1, section: 0), at: [.centeredHorizontally, .centeredVertically], animated: true)
            }
        }
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributesForUpdateItem(at:itemIndexPath)
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributesForUpdateItem(at:itemIndexPath)
    }
}

fileprivate extension PetalLayout {
    
    func updateAttributes() {

        circleAttributesArray.removeAll()
        layoutAttributesArray.removeAll()
        
        let itemsCount = collectionView!.numberOfItems(inSection: 0)
        recursionGetCircleAttributes(itemsCount: itemsCount, circleIndex: 0)
        
        var row = 0
        // for every circle
        for circleAttributes in circleAttributesArray {
            
            // for every item in a circle
            for itemIndex in 0..<circleAttributes.itemsCount {
                let center = centerInContentView.bs.offset(angleFromNorth: circleAttributes.angle * CGFloat(itemIndex) + startAngleFromNorth, distance: circleAttributes.radius, clockwise: isClockwise)
                
                let indexPath = IndexPath(item: row, section: 0)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.size = itemSize
                attributes.center = center
                attributes.alpha = 1
                
                layoutAttributesArray.append(attributes)
                
                row += 1
            }
        }
    }
    
    /// a recursion func, save the data to `circleAttributesArray`
    func recursionGetCircleAttributes(itemsCount: Int, circleIndex: Int) {
        
        // math magic
        let r = itemSize.width/2
        let a = r + minimumInteritemSpacing/2
        let b = firstCircleItemInnerSpacing + r + (2 * r + minimumInteritemSpacing) * CGFloat(circleIndex)
        var angle = asin(a/b) * 2
        let maxItemCount = Int(CGFloat.pi * 2/angle)
        let remainItemsCount = itemsCount - maxItemCount
        
        // divide equally if needed
        if remainItemsCount >= 0, isDivideInteritemSpacingEquallyWhenCircleFull {
            angle = CGFloat.pi * 2/CGFloat(maxItemCount)
        }
        
        let circleAttributes = PetalLayoutCircleAttributes(index: circleIndex, itemsCount: itemsCount - max(0, remainItemsCount), maxItemsCount: maxItemCount, radius: b, angle: angle)
        circleAttributesArray.append(circleAttributes)
        
        if remainItemsCount > 0 {
            recursionGetCircleAttributes(itemsCount: remainItemsCount, circleIndex: circleIndex + 1)
        }
    }
    
    var lastCircleItemOuterSpacing: CGFloat {
        if let lastCircleAttributes = circleAttributesArray.last {
            return lastCircleAttributes.radius + itemSize.width/2
        } else {
            return 0
        }
    }
    
    var contentWidth: CGFloat {
        let width = lastCircleItemOuterSpacing * 2 + padding * 2
        if let cv = collectionView {
            return max(width, cv.bounds.size.width)
        } else {
            return width
        }
    }
    
    var contentHeight: CGFloat {
        if let cv = collectionView {
            return max(contentWidth, cv.bounds.size.height)
        } else {
            return contentWidth
        }
    }
    
    var centerInContentView: CGPoint {
        return CGPoint(x: contentWidth/2, y: contentHeight/2)
    }
    
    func layoutAttributesForUpdateItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        if indexPathToUpdate.contains(indexPath) {
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.center = centerInContentView
            attributes.size = itemSize
            attributes.alpha = 0
            return attributes
        } else {
            return layoutAttributesArray[indexPath.row]
        }
    }
}

