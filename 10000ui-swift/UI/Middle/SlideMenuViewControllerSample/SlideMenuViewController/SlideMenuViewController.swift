//
//  SlideMenuViewController.swift
//  Kuso
//
//  Created by blurryssky on 2018/7/26.
//  Copyright © 2018年 blurryssky. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

protocol SlideMenuViewControllerDataSource: NSObjectProtocol {
    func slideMenuViewController(_ slideMenuViewController: UIViewController, viewControllerForItemAt index: Int) -> UIViewController
}

protocol SlideMenuViewControllerDelegate: NSObjectProtocol {
    func slideMenuViewController(_ slideMenuViewController: UIViewController, didChange viewController: UIViewController)
}

class SlideMenuViewController: UIViewController {
    
    var selectedIndex: Int {
        set {
            slideFromIndex = selectedIndex
            slideToIndex = newValue
            let idx = max(0, min(menusVariable.value.count - 1, newValue))
            slideCollectionView.scrollToItem(at: [0, idx], at: .centeredHorizontally, animated: true)
        }
        get {
            return currentIndex
        }
    }
    
    var slideMenuInsetX: CGFloat? {
        didSet {
            menuCollectionView.reloadData()
        }
    }
    
    weak var delegate: SlideMenuViewControllerDelegate?
    weak var dataSource: SlideMenuViewControllerDataSource?

    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var slideCollectionView: UICollectionView!
    
    fileprivate lazy var menuSlideView: UIView = {
        let view = UIView()
        view.bs.size = CGSize(width: 15, height: 2)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.colors = [#colorLiteral(red: 1, green: 0.06274509804, blue: 0.8470588235, alpha: 1).cgColor, #colorLiteral(red: 1, green: 0.3137254902, blue: 0.06274509804, alpha: 1).cgColor]
        view.layer.addSublayer(gradientLayer)
        return view
    }()
    
    fileprivate var menusVariable: Variable<[String]> = Variable([])
    fileprivate var idxToViewControllerDict: [Int : UIViewController] = [:]

    fileprivate var isSlideByMenuSelect = false
    fileprivate var slideFromIndex = 0
    fileprivate var slideToIndex: Int?
    
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate var currentIndex = 0 {
        didSet {
            guard oldValue != currentIndex else {
                return
            }

            if let vc = idxToViewControllerDict[currentIndex] {
                delegate?.slideMenuViewController(self, didChange: vc)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension SlideMenuViewController {
    
    func setMenuTitles(_ titles: [String]) {
        
        menusVariable.value = titles.map { $0 }
    }
    
    var currentViewController: UIViewController? {
        return idxToViewControllerDict[currentIndex]
    }
}

private extension SlideMenuViewController {
    
    func setup() {
        setupMenuCollectionView()
        setupSlideCollectionView()
    }
    
    func setupMenuCollectionView() {
        
        menuCollectionView.backgroundColor = UIColor.clear
        
        menuCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        // default ratio 1
        menusVariable.asObservable()
            .bind(to: menuCollectionView.rx.items(cellIdentifier: MenuCollectionCell.bs.string, cellType: MenuCollectionCell.self))  { (idx, menuText, cell) in
                if idx == 0 {
                    cell.ratio = 1
                }
                cell.menuText = menuText
            }
            .disposed(by: disposeBag)
        
        // setup menuSlideView
        menuCollectionView.rx.willDisplayCell
            .take(1)
            .delay(0.1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (cell, indexPath) in
                guard let `self` = self,
                    let menuCell = cell as? MenuCollectionCell else {
                        return
                }

                let convertedOriginX = menuCell.convert(menuCell.label.frame.origin, to: self.menuCollectionView).x
                self.menuSlideView.bs.origin = CGPoint(x: convertedOriginX, y: menuCell.frame.maxY - 15)
                self.menuCollectionView.addSubview(self.menuSlideView)
            })
            .disposed(by: disposeBag)
        
        // update slideFromIndex, slideToIndex
        menuCollectionView.rx.itemSelected
            .subscribe(onNext: { [unowned self] (indexPath) in
                
                guard self.slideToIndex != indexPath.item else {
                    return
                }

                self.slideFromIndex = self.currentIndex
                self.slideToIndex = indexPath.item
                
                self.isSlideByMenuSelect = true
                
                self.slideCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            })
            .disposed(by: disposeBag)
    }
    
    func setupSlideCollectionView() {
        
        slideCollectionView.backgroundColor = UIColor.clear
        
        slideCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        menusVariable.asObservable()
            .bind(to: slideCollectionView.rx.items(cellIdentifier: SlideCollectionCell.bs.string, cellType: SlideCollectionCell.self))  { [weak self] (idx, _, cell) in
                
                guard let `self` = self else { return }
                // avoid initialize needless view controller
                if self.isSlideByMenuSelect {
                    guard self.slideToIndex == idx else {
                        return
                    }
                }
                
                // setup child view controller
                var targetVC: UIViewController!
                if let vc = self.idxToViewControllerDict[idx] {
                    targetVC = vc
                } else if let vc = self.dataSource?.slideMenuViewController(self, viewControllerForItemAt: idx) {
                    targetVC = vc
                    self.idxToViewControllerDict[idx] = vc
                } else {
                    return
                }
                self.addChild(targetVC)
                cell.viewController = targetVC
                targetVC.didMove(toParent: self)
            }
            .disposed(by: disposeBag)
        
        // call first callback
        slideCollectionView.rx.willDisplayCell
            .take(1)
            .subscribe(onNext: { [weak self] (cell, indexPath) in
                guard let `self` = self else { return }
                if let vc = self.idxToViewControllerDict[self.currentIndex] {
                    self.delegate?.slideMenuViewController(self, didChange: vc)
                }
            })
            .disposed(by: disposeBag)
        
        // update currentIndex and call callback, update raio
        slideCollectionView.rx.contentOffset
            .skip(1)
            .subscribe(onNext: { [weak self] (offset) in
                guard let `self` = self else { return }
                let times = offset.x/self.slideCollectionView.bounds.width
                let maxItem = CGFloat(self.menusVariable.value.count - 1)
                let targetItem = Int(min(max(times + 0.5, 0), maxItem))
                self.menuCollectionView.selectItem(at: [0, targetItem], animated: true, scrollPosition: .centeredHorizontally)
                self.currentIndex = targetItem
                
                self.updateRatio()
            })
            .disposed(by: disposeBag)
        
        // update slideFromIndex, and set toCell ratio 0. avoid continuous slide display bug
        slideCollectionView.rx.willBeginDragging
            .subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else { return }
                self.isSlideByMenuSelect = false
                self.slideFromIndex = self.currentIndex
            })
            .disposed(by: disposeBag)
        
        // clean status
        Observable.of(slideCollectionView.rx.didEndScrollingAnimation, slideCollectionView.rx.didEndDecelerating).merge()
            .subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else { return }
                self.isSlideByMenuSelect = false
                self.slideToIndex = nil
            })
            .disposed(by: disposeBag)
    }
}

private extension SlideMenuViewController {
    
    func updateRatio() {
        
        let fromOffsetX = slideCollectionView.bounds.width * CGFloat(slideFromIndex)
        let currentOffsetX = slideCollectionView.contentOffset.x
        
        let isToRight = currentOffsetX >= fromOffsetX
        // only set slideToIndex if scroll by finger
        if !isSlideByMenuSelect {
            slideToIndex = isToRight ? min(menusVariable.value.count - 1, slideFromIndex + 1) : max(0, slideFromIndex - 1)
        }
        guard let slideToIndex = slideToIndex else {
            return
        }
        
        let toOffsetX = slideCollectionView.bounds.width * CGFloat(slideToIndex)
        let totalDistance = toOffsetX - fromOffsetX
        guard totalDistance != 0 else {
            return
        }
        let ratio = (currentOffsetX - fromOffsetX)/totalDistance
        
        if let fromCell = menuCollectionView.cellForItem(at: [0, slideFromIndex]) as? MenuCollectionCell,
            let toCell = menuCollectionView.cellForItem(at: [0, slideToIndex]) as? MenuCollectionCell {
            
            fromCell.ratio = 1 - ratio
            toCell.ratio = ratio
            
            let convertedFromOriginX = fromCell.convert(fromCell.label.frame.origin, to: menuCollectionView).x
            let convertedToOriginX = toCell.convert(toCell.label.frame.origin, to: menuCollectionView).x
            let distance = convertedToOriginX - convertedFromOriginX
 
            menuSlideView.bs.origin = CGPoint(x: convertedFromOriginX + distance * ratio, y: fromCell.frame.maxY - 15)
        }
    }
}

extension SlideMenuViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
        case menuCollectionView:
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let width = collectionView.bounds.size.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right
            let size = CGSize(width: ceil(width/5) - (slideMenuInsetX ?? 0), height: collectionView.bs.height)
            return size
        case slideCollectionView:
            return slideCollectionView.bounds.size
        default:
            return .zero
        }
    }
}
