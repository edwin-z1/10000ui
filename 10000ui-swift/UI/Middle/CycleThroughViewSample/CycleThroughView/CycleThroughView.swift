//
//  CycleThroughView.swift
//  10000ui-swift
//
//  Created by 张亚东 on 16/5/4.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

import UIKit

class CycleThroughView: UIView {
    
    var imageDidSelectedClousure: ((Int) -> Void)?
    
    @objc weak var zoomForScrollView: UIScrollView? {
        didSet {
            if let _ = oldValue {
                removeObserver(self, forKeyPath: "zoomForScrollView.contentOffset")
            }
            if let _ = zoomForScrollView {
                addObserver(self, forKeyPath: "zoomForScrollView.contentOffset", options: .new, context: nil)
            }
        }
    }
    
    var imageUrlStrings: [String] = [] {
        didSet {
            
            isUseLocalImage = false
            
            pageControl.numberOfPages = imageUrlStrings.count
            
            if imageUrlStrings.count <= 1 {
                pageControl.isHidden = true
            } else {
                pageControl.isHidden = false
                
                imageUrlStrings.insert(imageUrlStrings.last!, at: 0)
                imageUrlStrings.insert(imageUrlStrings[1], at: imageUrlStrings.count)
                
                DispatchQueue.main.async {
                    self.collectionView.scrollToItem(at: [0, 1], at: .centeredHorizontally, animated: false)
                }
            }
            collectionView.reloadData()
            
            restartTimer()
        }
    }
    
    var placeholderImage: UIImage?
    
    /// set images, can't cycle play when images == 1
    var images: [UIImage] = [] {
        didSet {
            
            isUseLocalImage = true
            
            pageControl.numberOfPages = images.count
            
            if images.count <= 1 {
                pageControl.isHidden = true
            } else {
                pageControl.isHidden = false
                
                images.insert(images.last!, at: 0)
                images.insert(images[1], at: images.count)
                
                DispatchQueue.main.async {
                    self.collectionView.scrollToItem(at: [0, 1], at: .centeredHorizontally, animated: false)
                }
            }
            collectionView.reloadData()
            
            restartTimer()
        }
    }
    
    /// set timeinterval to start cycle play, 0 = stop, default is 0
    var scrollTimeInterval: TimeInterval = 0
    
    lazy var pageControl: UIPageControl = {
        return UIPageControl()
    }()
    
    fileprivate var isUseLocalImage = false
    fileprivate var timer: Timer?
    
    fileprivate lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        return flowLayout
    }()

    fileprivate lazy var collectionView: UICollectionView = {
        
        let collection: UICollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: self.flowLayout)
        collection.dataSource = self
        collection.delegate = self
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        collection.register(CycleThroughCollectionCell.self, forCellWithReuseIdentifier: "CycleThroughCollectionCell")
        collection.backgroundColor = UIColor.clear
        return collection
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        flowLayout.itemSize = bounds.size
        flowLayout.estimatedItemSize = bounds.size
        collectionView.frame = bounds
        pageControl.center = CGPoint(x: bounds.size.width/2, y: bounds.size.height - 12)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "zoomForScrollView.contentOffset",
            let offset = change?[.newKey] as? CGPoint else {
                return
        }
        // avoid cell is covered after zoom
        let index = Int(collectionView.contentOffset.x/collectionView.bs.width)
        if let cell = collectionView.cellForItem(at: [0, index]) {
            collectionView.bringSubview(toFront: cell)
        }
        
        let insetTop = zoomForScrollView!.contentInset.top
        if offset.y < -insetTop {
            bs.origin.y = offset.y
            bs.height = -offset.y
            
            endTimer()
        } else {
            bs.origin.y = -insetTop
            bs.height = insetTop
            
            restartTimer()
        }
    }
    
}

extension CycleThroughView {
    
    func clean() {
        endTimer()
        if let _ = zoomForScrollView {
            removeObserver(self, forKeyPath: "zoomForScrollView.contentOffset")
        }
    }
}

fileprivate extension CycleThroughView {
    
    func setup() {
        addSubview(collectionView)
        addSubview(pageControl)
    }
    
    func restartTimer() {

        let itemsCount = collectionView.numberOfItems(inSection: 0)
        if itemsCount > 1 {
            endTimer()
            
            if scrollTimeInterval > 0 {
                timer = Timer.scheduledTimer(timeInterval: scrollTimeInterval, target: self, selector: #selector(handleTimer(timer:)), userInfo: nil, repeats: true)
            }
        }
    }

    func endTimer() {
        timer?.invalidate()
        timer = nil
    }

    @objc func handleTimer(timer: Timer) {
        let offsetX = collectionView.contentOffset.x
        let width = collectionView.bounds.size.width
        let index = Int(offsetX/width)
        
        collectionView.scrollToItem(at: [0, index + 1], at: .centeredHorizontally, animated: true)
    }
}

extension CycleThroughView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !isUseLocalImage {
            return imageUrlStrings.count
        } else {
            return images.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CycleThroughCollectionCell", for: indexPath) as! CycleThroughCollectionCell
        if !isUseLocalImage {
            cell.imageUrlString = imageUrlStrings[indexPath.row]
            cell.placeholderImage = placeholderImage
        } else {
            cell.image = images[indexPath.row]
        }
        return cell
    }
}

extension CycleThroughView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var index = indexPath.row - 1
        if pageControl.isHidden {
            index += 1
        }
        imageDidSelectedClousure?(index)
    }
}

extension CycleThroughView: UIScrollViewDelegate {
    
    private func adjustImagePosition() {
        
        let offsetX = collectionView.contentOffset.x
        let width = collectionView.bounds.size.width
        let index = offsetX/width
        
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        if index >= CGFloat(itemsCount - 1) {
            collectionView.scrollToItem(at: [0 ,1], at: .centeredHorizontally, animated: false)
        } else if index < 1 {
            collectionView.scrollToItem(at: [0, itemsCount - 2], at: .centeredHorizontally, animated: false)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        endTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        adjustImagePosition()
        restartTimer()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        adjustImagePosition()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !pageControl.isHidden else {
            return
        }
        
        layoutIfNeeded()
        let offsetX = collectionView.contentOffset.x
        let width = collectionView.bounds.size.width
        let floatIndex = Float(offsetX/width)
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        
        pageControl.currentPage = Int(round(floatIndex)) - 1
        
        let a = Float(0.5)
        let b = Float(itemsCount - 2) + a
        
        if floatIndex >= b {
            pageControl.currentPage = 0
        } else if floatIndex <= a {
            pageControl.currentPage = itemsCount - 2
        }
    }
}

