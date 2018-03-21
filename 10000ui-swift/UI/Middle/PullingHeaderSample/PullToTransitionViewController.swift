//
//  PullToTransitionViewController.swift
//  10000ui-swift
//
//  Created by blurryssky on 2018/2/24.
//  Copyright © 2018年 blurryssky. All rights reserved.
//

import UIKit

class PullToTransitionViewController: UIViewController {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        dismiss(animated: true, completion: nil)
    }

}

extension PullToTransitionViewController: PullingTransitioning {
    func shouldTransition(fraction: CGFloat) -> Bool {
        return fraction >= 1.3
    }
}
