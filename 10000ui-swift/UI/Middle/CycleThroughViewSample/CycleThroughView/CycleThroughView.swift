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
            }
            collectionView.reloadData()
            
            restartTimer()
        }
    }
    
    //set timeinterval to start cycle play, 0 = stop, default is 0
    var scrollTimeInterval: TimeInterval = 0
    
    lazy var pageControl: UIPageControl = {
        return UIPageControl()
    }()
    
    fileprivate var isUseLocalImage = false
    fileprivate var timer: DispatchSourceTimer?
    
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

    open override func layoutSubviews() {
        super.layoutSubviews()
        
        flowLayout.itemSize = bounds.size
        flowLayout.estimatedItemSize = bounds.size
        collectionView.frame = bounds
        pageControl.center = CGPoint(x: bounds.size.width/2, y: bounds.size.height - 12)
        
        if !pageControl.isHidden {
            collectionView.contentOffset = CGPoint(x: collectionView.bounds.size.width, y: 0)
        }
    }
}

extension CycleThroughView {
    
    func setup() {
        addSubview(collectionView)
        addSubview(pageControl)
    }
    
    func restartTimer() {
        if pageControl.isHidden {
            return
        }
        
        timer?.cancel()
        
        if scrollTimeInterval != 0 {
            startTimer()
        }
    }

    func startTimer() {
        
        timer = DispatchSource.makeTimerSource()
        timer?.setEventHandler { [weak self] in
            
            guard let strongSelf = self else {
                return
            }
            
            DispatchQueue.main.async { [unowned strongSelf] in
                
                let offsetX = strongSelf.collectionView.contentOffset.x
                let width = strongSelf.collectionView.bounds.size.width
                let index = offsetX/width
                
                strongSelf.collectionView.setContentOffset(CGPoint(x: strongSelf.collectionView.bounds.width * CGFloat(index + 1), y: 0), animated: true)
            }
        }

        timer?.schedule(deadline: .now() + scrollTimeInterval, repeating: scrollTimeInterval)
        timer?.resume()
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
            collectionView.setContentOffset(CGPoint(x: width, y: 0), animated: false)
        } else if index < 1 {
            collectionView.setContentOffset(CGPoint(x: width * CGFloat(itemsCount - 2), y: 0), animated: false)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollTimeInterval != 0 {
            timer?.cancel()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        adjustImagePosition()
        
        if scrollTimeInterval != 0 {
            restartTimer()
        }
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
        var index = Int(offsetX/width)
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        
        if index == itemsCount - 1 {
            index = 1
        } else if index == 0 {
            index = itemsCount - 1
        }
        
        pageControl.currentPage = Int(round(floatIndex)) - 1
        
        let a = Float(0.5)
        let b = Float(itemsCount - 2) + a
        
        if floatIndex >= b {
            pageControl.currentPage = 0
        } else if floatIndex <= a {
            pageControl.currentPage = Int(b - a)
        }
        
    }
    
}

