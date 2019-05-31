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
    func stateDidUpdate(_ state: PullingState, fraction: CGFloat)
}

typealias PullingRefreshingView = PullingRefreshing & UIView

protocol PullingTransitioning: NSObjectProtocol {
    func shouldTransition(fraction: CGFloat) -> Bool
}

enum PullingState {
    case resting
    case pulling
    case willRefresh
    case refreshing
    case willTransition
    case transitioning
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
    
    private(set) var fraction: CGFloat = 0
    fileprivate(set) var state: PullingState = .resting {
        didSet {
            pullToRefreshView.stateDidUpdate(state, fraction: fraction)
        }
    }
    
    fileprivate weak var scrollView: UIScrollView!
    fileprivate var pullToRefreshView: PullingRefreshingView!
    fileprivate var refreshClosure: ((PullingHeader) -> Void)!
    fileprivate var pullingTransitioningDelegate: PullingTransitioning?
    fileprivate var transitionClosure: ((PullingHeader) -> Void)?
    
    fileprivate var contentSizeObservation: NSKeyValueObservation!
    fileprivate var offsetObservation: NSKeyValueObservation!
    
    deinit {
        invalidateObservation()
    }
    
    convenience init(scrollView: UIScrollView!,
         pullToRefreshView toRefresh: PullingRefreshingView!,
         refreshClosure: ((PullingHeader) -> Void)!,
         pullingTransitioningDelegate: PullingTransitioning? = nil,
         transitionClosure: ((PullingHeader) -> Void)? = nil) {
        
        self.init()
        self.scrollView = scrollView
        pullToRefreshView = toRefresh
        self.refreshClosure = refreshClosure
        self.pullingTransitioningDelegate = pullingTransitioningDelegate
        self.transitionClosure = transitionClosure
        setup()
    }
}

extension PullingHeader {
    
    func endRefresh() {
        
        let inset = scrollViewDirectionInset - refreshViewDirectionLength
        animateScrollViewDirectionInset(inset)
        fraction = 0
        state = .resting
    }
    
    func endTransition() {
        fraction = 0
        state = .resting
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
                
                self.fraction = self.caculateFraction(newOffset: offset)
                
                let shouldRefresh = self.pullToRefreshView.shouldRefresh(fraction: self.fraction)
                if let shouldTransition = self.pullingTransitioningDelegate?.shouldTransition(fraction: self.fraction),
                    shouldTransition {
                    
                    switch self.state {
                    case .pulling: fallthrough
                    case .willRefresh: fallthrough
                    case .willTransition:
                        self.state = .willTransition
                    default:break
                    }
                    
                } else if shouldRefresh {
                    
                    switch self.state {
                    case .pulling: fallthrough
                    case .willRefresh: fallthrough
                    case .willTransition:
                        self.state = .willRefresh
                    default:break
                    }
                    
                } else {
                    
                    switch self.state {
                    case .resting: fallthrough
                    case .pulling: fallthrough
                    case .willRefresh: fallthrough
                    case .willTransition:
                        self.state = .pulling
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
        
        fraction = 1
        state = .refreshing
        
        let inset = scrollViewDirectionInset + refreshViewDirectionLength
        animateScrollViewDirectionInset(inset)
        refreshClosure(self)
    }
    
    func transition() {
        
        fraction = 1
        state = .transitioning
        
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
    
    func caculateFraction(newOffset: CGPoint) -> CGFloat {
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


