//
//  PullingHeader.swift
//  10000ui-swift
//
//  Created by blurryssky on 2018/2/23.
//  Copyright © 2018年 blurryssky. All rights reserved.
//

import UIKit

protocol PullingRefreshing: NSObjectProtocol {
    func shouldRefresh(fraction: CGFloat) -> Bool
    func stateDidUpdate(_ state: PullingState)
}

typealias PullingRefreshingView = PullingRefreshing & UIView

protocol PullingTransitioning: NSObjectProtocol {
    func shouldTransition(fraction: CGFloat) -> Bool
}

typealias PullingTransitioningViewController = PullingTransitioning & UIViewController

enum PullingState {
    case resting(fraction: CGFloat)
    case pulling(fraction: CGFloat)
    case willRefresh(fraction: CGFloat)
    case refreshing(fraction: CGFloat)
    case willTransition(fraction: CGFloat)
    case transitioning(fraction: CGFloat)
}

class PullingHeader: NSObject {
    

    fileprivate(set) var state: PullingState = .resting(fraction: 0) {
        didSet {
            pullToRefreshView.stateDidUpdate(state)
        }
    }
    
    fileprivate weak var scrollView: UIScrollView!
    fileprivate weak var pullToRefreshView: PullingRefreshingView!
    fileprivate var refreshClosure: ((PullingHeader) -> Void)!
    fileprivate weak var pullToTransitionViewController: PullingTransitioningViewController?
    fileprivate var transitionClosure: ((PullingHeader) -> Void)?
    
    fileprivate var observation: NSKeyValueObservation!
    
    init(scrollView: UIScrollView!,
         pullToRefreshView toRefresh: PullingRefreshingView!,
         refreshClosure: ((PullingHeader) -> Void)!,
         pullToTransitionViewController toTransition: PullingTransitioningViewController? = nil,
         transitionClosure: ((PullingHeader) -> Void)? = nil) {
        
        self.scrollView = scrollView
        self.pullToRefreshView = toRefresh
        self.refreshClosure = refreshClosure
        self.pullToTransitionViewController = toTransition
        self.transitionClosure = transitionClosure
        super.init()
        setup()
    }
}

extension PullingHeader {
    
    func endRefresh() {
        let insetTop = scrollViewInsetTop - refreshViewHeight
        var scrollViewInset = scrollView.contentInset
        scrollViewInset.top = insetTop

        UIView.animate(withDuration: 0.4, delay: 0.25, options: .curveEaseInOut, animations: {
            self.scrollView.contentInset = scrollViewInset
        })
        state = .resting(fraction: 0)
    }
    
    func endTransition() {
        state = .resting(fraction: 0)
    }
}

fileprivate extension PullingHeader {
    
    var scrollViewInsetTop: CGFloat {
        return scrollView.contentInset.top
    }
    
    var refreshViewHeight: CGFloat {
        return pullToRefreshView.bounds.height
    }
    
    func setup() {
        
        scrollView.addSubview(pullToRefreshView)
        
        let originY = -(refreshViewHeight + scrollViewInsetTop)
        pullToRefreshView.frame = .init(origin: .init(x: 0, y: originY),
                                  size: .init(width: scrollView.bs.width, height: refreshViewHeight))
        
        observation = scrollView.observe(\.contentOffset, options: .new, changeHandler: { [weak self] (_, change) in
            guard let `self` = self, let offset = change.newValue else {
                return
            }
            
            // 先判断松手后
            if !self.scrollView.isTracking {
                switch self.state {
                case .willRefresh:
                    self.refresh()
                case .willTransition:
                    self.transition()
                case .refreshing: fallthrough
                case .transitioning: return
                default:break
                }
            }
            
            let fraction = -(offset.y + self.scrollViewInsetTop)/self.refreshViewHeight

            let shouldRefresh = self.pullToRefreshView.shouldRefresh(fraction: fraction)
            if let shouldTransition = self.pullToTransitionViewController?.shouldTransition(fraction: fraction),
                shouldTransition {
                
                switch self.state {
                case .pulling: fallthrough
                case .willRefresh: fallthrough
                case .willTransition:
                    self.state = .willTransition(fraction: fraction)
                default:break
                }

            } else if shouldRefresh {
                
                switch self.state {
                case .pulling: fallthrough
                case .willRefresh: fallthrough
                case .willTransition:
                    self.state = .willRefresh(fraction: fraction)
                default:break
                }

            } else {
                
                switch self.state {
                case .resting: fallthrough
                case .pulling: fallthrough
                case .willRefresh: fallthrough
                case .willTransition:
                    self.state = .pulling(fraction: fraction)
                default:break
                }
            }
        })
    }
    
    func refresh() {
        
        let insetTop = refreshViewHeight + scrollViewInsetTop
        var scrollViewInset = scrollView.contentInset
        scrollViewInset.top = insetTop
        
        state = .refreshing(fraction: 1)
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.scrollView.contentInset = scrollViewInset
        })

        refreshClosure(self)
    }
    
    func transition() {
        
        state = .transitioning(fraction: 1)
        
        transitionClosure?(self)
    }
}


