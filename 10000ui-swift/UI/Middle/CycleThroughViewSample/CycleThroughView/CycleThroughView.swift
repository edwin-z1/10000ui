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
                observation?.invalidate()
            }
            if let zoomForScrollView = zoomForScrollView {
                observation = zoomForScrollView.observe(\.contentOffset, options: .new, changeHandler: { [weak self] (_, change) in
                    if let offset = change.newValue {
                        self?.handleObserveContentOffset(offset)
                    }
                })
            }
        }
    }
    
    var imageUrlStrings: [String] = [] {
        didSet {
            
            isUseImages = false
            
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
            
            startTimer()
        }
    }
    
    var placeholderImage: UIImage?
    
    /// set images, can't cycle play when images == 1
    var images: [UIImage] = [] {
        didSet {
            
            isUseImages = true
            
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
            
            startTimer()
        }
    }
    
    /// set timeinterval to start cycle play, 0 = stop, default is 0
    var scrollTimeInterval: TimeInterval = 0
    
    lazy var pageControl: UIPageControl = {
        return UIPageControl()
    }()
    
    fileprivate var observation: NSKeyValueObservation?
    fileprivate var isUseImages = false
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
}

extension CycleThroughView {
    
    func clean() {
        endTimer()
        observation?.invalidate()
    }
}

fileprivate extension CycleThroughView {
    
    func setup() {
        addSubview(collectionView)
        addSubview(pageControl)
    }
    
    func handleObserveContentOffset(_ offset: CGPoint) {
        // avoid central cell is covered by nearby cell after zoom
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
            
            startTimer()
        }
    }
    
    func startTimer() {
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        guard scrollTimeInterval > 0, itemsCount > 1, timer == nil else { return }

        timer = Timer.scheduledTimer(timeInterval: scrollTimeInterval, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
    }

    func endTimer() {
        timer?.invalidate()
        timer = nil
    }

    @objc func handleTimer() {
        let offsetX = collectionView.contentOffset.x
        let width = collectionView.bounds.size.width
        let index = Int(offsetX/width)
        
        collectionView.scrollToItem(at: [0, index + 1], at: .centeredHorizontally, animated: true)
    }
}

extension CycleThroughView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !isUseImages {
            return imageUrlStrings.count
        } else {
            return images.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CycleThroughCollectionCell", for: indexPath) as! CycleThroughCollectionCell
        if !isUseImages {
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
    
    private func adjustCollectionViewContentOffsetX() {
        
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
    
    private func updatePageControl() {
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        endTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        adjustCollectionViewContentOffsetX()
        startTimer()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        adjustCollectionViewContentOffsetX()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !pageControl.isHidden else {
            return
        }
        
        layoutIfNeeded()
        updatePageControl()
    }
}

