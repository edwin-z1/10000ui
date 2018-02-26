//
//  PullHeader.swift
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

protocol PullingTransitioning: NSObjectProtocol {
    func shouldTransition(fraction: CGFloat) -> Bool
}

enum PullingState {
    case resting(fraction: CGFloat)
    case pulling(fraction: CGFloat)
    case willRefresh(fraction: CGFloat)
    case refreshing(fraction: CGFloat)
    case willTransition(fraction: CGFloat)
    case transitioning(fraction: CGFloat)
}

class PullHeader: NSObject {
    

    fileprivate(set) var state: PullingState = .resting(fraction: 0) {
        didSet {
            pullToRefreshView.stateDidUpdate(state)
        }
    }
    
    fileprivate weak var scrollView: UIScrollView!
    fileprivate weak var pullToRefreshView: PullingRefreshing!
    fileprivate var refreshClosure: ((PullHeader) -> Void)!
    fileprivate weak var pullToTransitionViewController: PullingTransitioning?
    fileprivate var transitionClosure: ((PullHeader) -> Void)?
    
    fileprivate var observation: NSKeyValueObservation!
    
    init(scrollView: UIScrollView!,
         pullToRefreshView toRefresh: PullingRefreshing!,
         refreshClosure: ((PullHeader) -> Void)!,
         pullToTransitionViewController toTransition: PullingTransitioning? = nil,
         transitionClosure: ((PullHeader) -> Void)? = nil) {
        
        guard toRefresh is UIView else {
            fatalError("pullToRefreshView must be UIView")
        }
        if let toTransition = toTransition, !(toTransition is UIViewController) {
            fatalError("transitionToViewController must be UIViewController")
        }
        
        self.scrollView = scrollView
        self.pullToRefreshView = toRefresh
        self.refreshClosure = refreshClosure
        self.pullToTransitionViewController = toTransition
        self.transitionClosure = transitionClosure
        super.init()
        setup()
    }
}

extension PullHeader {
    
    func endRefresh() {
        UIView.animate(withDuration: 0.4, delay: 0.25, options: .curveEaseInOut, animations: {
            self.scrollView.contentInset = .zero
        })
        state = .resting(fraction: 0)
    }
    
    func endTransition() {
        state = .resting(fraction: 0)
    }
}

fileprivate extension PullHeader {
    
    func setup() {
        
        let refreshView = pullToRefreshView as! UIView
        scrollView.addSubview(refreshView)
        refreshView.frame = .init(origin: .init(x: 0, y: -refreshView.bounds.height), size: .init(width: scrollView.bs.width, height: refreshView.bs.height))
        
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
            
            let fraction = -offset.y/refreshView.bs.height

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
        
        let refreshView = pullToRefreshView as! UIView
        let height = refreshView.bs.height
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.scrollView.contentInset = .init(top: height, left: 0, bottom: 0, right: 0)
            self.scrollView.setContentOffset(.init(x: 0, y: -height), animated: false)
        })
        state = .refreshing(fraction: 1)
        
        refreshClosure(self)
    }
    
    func transition() {
        
        state = .transitioning(fraction: 1)
        
        transitionClosure?(self)
    }
}


