//
//  PullHeaderSampleViewController.swift
//  10000ui-swift
//
//  Created by blurryssky on 2018/2/23.
//  Copyright © 2018年 blurryssky. All rights reserved.
//

import UIKit

class PullHeaderSampleViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var pullToRefreshView: PullToFreshView!
    
    private var pullHeader: PullHeader!
    fileprivate lazy var animator = DynamicGravityTransitionAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let pullingRefresh = pullToRefreshView as PullingRefreshing
        let toTransitionViewController = "PullToTransitionViewController".bs.instantiateViewController(fromStoryboardName: "PullHeader")
        toTransitionViewController.transitioningDelegate = self
        toTransitionViewController.modalPresentationStyle = .custom
        
        let pullingTransition = toTransitionViewController as! PullingTransitioning

        pullHeader = PullHeader(scrollView: scrollView, pullToRefreshView: pullingRefresh, refreshClosure: { header in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                header.endRefresh()
            })
        }, pullToTransitionViewController: pullingTransition, transitionClosure: { [weak self] header in
            self?.present(toTransitionViewController, animated: true, completion: {
                header.endTransition()
            })
        })
    }
}

extension PullHeaderSampleViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.isPresent = true
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.isPresent = false
        return animator
    }
}
