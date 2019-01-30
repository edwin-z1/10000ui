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

enum DragDirection {
    case down
    case left
}

class PullingHeader: NSObject {
    
    var dragDirection: DragDirection = .down {
        didSet {
            invalidateObservation()
            setup()
        }
    }
    
    fileprivate(set) var state: PullingState = .resting(fraction: 0) {
        didSet {
            pullToRefreshView.stateDidUpdate(state)
        }
    }
    
    fileprivate weak var scrollView: UIScrollView!
    fileprivate var pullToRefreshView: PullingRefreshingView!
    fileprivate var refreshClosure: ((PullingHeader) -> Void)!
    fileprivate var pullToTransitionViewController: PullingTransitioningViewController?
    fileprivate var transitionClosure: ((PullingHeader) -> Void)?
    
    fileprivate var contentSizeObservation: NSKeyValueObservation!
    fileprivate var offsetObservation: NSKeyValueObservation!
    
    deinit {
        invalidateObservation()
    }
    
    convenience init(scrollView: UIScrollView!,
         pullToRefreshView toRefresh: PullingRefreshingView!,
         refreshClosure: ((PullingHeader) -> Void)!,
         pullToTransitionViewController toTransition: PullingTransitioningViewController? = nil,
         transitionClosure: ((PullingHeader) -> Void)? = nil) {
        
        self.init()
        self.scrollView = scrollView
        pullToRefreshView = toRefresh
        self.refreshClosure = refreshClosure
        pullToTransitionViewController = toTransition
        self.transitionClosure = transitionClosure
        setup()
    }
}

extension PullingHeader {
    
    func endRefresh() {
        
        let inset = scrollViewDirectionInset - refreshViewDirectionLength
        animateScrollViewDirectionInset(inset)
        state = .resting(fraction: 0)
    }
    
    func endTransition() {
        state = .resting(fraction: 0)
    }
    
    func invalidateObservation() {
        contentSizeObservation.invalidate()
        offsetObservation.invalidate()
    }
}

fileprivate extension PullingHeader {
    
    func setup() {
        
        if pullToRefreshView!.superview == nil {
            scrollView.addSubview(pullToRefreshView)
        }

        contentSizeObservation = scrollView.observe(\.contentSize, changeHandler: { [weak self] (_, change) in
            guard let `self` = self else {
                return
            }
            self.updateHeaderFrame()
        })
        
        offsetObservation = scrollView.observe(\.contentOffset, options: .new, changeHandler: { [weak self] (_, change) in
            guard let `self` = self, let offset = change.newValue else {
                return
            }
            
            // 先判断松手后
            if self.scrollView.isTracking {
                
                let fraction = self.fraction(newOffset: offset)
                
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
            } else {
                
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
        })
    }
    
    func refresh() {
        
        state = .refreshing(fraction: 1)
        
        let inset = scrollViewDirectionInset + refreshViewDirectionLength
        animateScrollViewDirectionInset(inset)
        refreshClosure(self)
    }
    
    func transition() {
        
        state = .transitioning(fraction: 1)
        transitionClosure?(self)
    }
}

fileprivate extension PullingHeader {
    
    var scrollViewDirectionInset: CGFloat {
        switch dragDirection {
        case .down:
            return scrollView.contentInset.top
        case .left:
            return scrollView.contentInset.right
        }
    }
    
    var refreshViewDirectionLength: CGFloat {
        switch dragDirection {
        case .down:
            return pullToRefreshView.bounds.height
        case .left:
            return pullToRefreshView.bounds.width
        }
    }
    
    func fraction(newOffset: CGPoint) -> CGFloat {
        var offset: CGFloat = 0
        switch dragDirection {
        case .down:
            offset = -(newOffset.y + scrollViewDirectionInset)
        case .left:
            offset = newOffset.x + scrollView.bounds.width - pullToRefreshView.frame.origin.x
        }
        return offset/refreshViewDirectionLength
    }
    
    func updateHeaderFrame() {
        switch dragDirection {
        case .down:
            let originY = -(refreshViewDirectionLength + scrollViewDirectionInset)
            pullToRefreshView.frame = .init(origin: .init(x: 0, y: originY),
                                            size: .init(width: scrollView.bs.width, height: refreshViewDirectionLength))
        case .left:
            let originX = scrollView.contentSize.width + scrollViewDirectionInset
            pullToRefreshView.frame = .init(origin: .init(x: originX, y: 0),
                                            size: .init(width: refreshViewDirectionLength, height: scrollView.bs.height))
        }
    }
    
    func animateScrollViewDirectionInset(_ directionInset: CGFloat) {
        
        var scrollViewInset = scrollView.contentInset
        switch dragDirection {
        case .down:
            scrollViewInset.top = directionInset
        case .left:
            scrollViewInset.right = directionInset
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.scrollView.contentInset = scrollViewInset
        })
    }
}


