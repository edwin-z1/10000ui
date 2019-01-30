//
//  PullingHeaderSampleViewController.swift
//  10000ui-swift
//
//  Created by blurryssky on 2018/2/23.
//  Copyright © 2018年 blurryssky. All rights reserved.
//

import UIKit

class PullingHeaderSampleViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var pullToRefreshView: PullToFreshView!
    
    private var pullingHeader: PullingHeader!
    fileprivate lazy var animator = DynamicGravityTransitionAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let pullingRefreshView = pullToRefreshView as PullingRefreshingView
        
        let toTransitionViewController = PullToTransitionViewController.bs.instantiateFromStoryboard(name: "PullingHeader")
        toTransitionViewController.transitioningDelegate = self
        toTransitionViewController.modalPresentationStyle = .custom
        
        let pullingTransitionViewController = toTransitionViewController as PullingTransitioningViewController

        pullingHeader = PullingHeader(scrollView: scrollView, pullToRefreshView: pullingRefreshView, refreshClosure: { header in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                header.endRefresh()
            })
        }, pullToTransitionViewController: pullingTransitionViewController, transitionClosure: { [weak self] header in
            self?.present(toTransitionViewController, animated: true, completion: {
                header.endTransition()
            })
        })
//        scrollView.contentInset = UIEdgeInsetsMake(42, 0, 0, 0)
        scrollView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 42)
        pullingHeader.dragDirection = .left
    }
}

extension PullingHeaderSampleViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.isPresent = true
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.isPresent = false
        return animator
    }
}
