//
//  SlideMenuSampleViewController.swift
//  10000ui-swift
//
//  Created by blurryssky on 2018/11/27.
//  Copyright © 2018 blurryssky. All rights reserved.
//

import UIKit

class SlideMenuSampleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
}

private extension SlideMenuSampleViewController {
    
    func setup() {
        let slideMenuViewController = SlideMenuViewController.bs.instantiateFromStoryboard(name: "SlideMenuViewController")
        view.addSubview(slideMenuViewController.view)
        addChildViewController(slideMenuViewController)
        slideMenuViewController.didMove(toParentViewController: self)
        
        slideMenuViewController.setMenuTitles(["推荐", "喜欢", "收藏", "苹果", "沙拉"])
        slideMenuViewController.dataSource = self
        slideMenuViewController.delegate = self
    }
}

extension SlideMenuSampleViewController: SlideMenuViewControllerDataSource {
    
    func slideMenuViewController(_ slideMenuViewController: UIViewController, viewControllerForItemAt index: Int) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = UIColor.bs.random(alpha: 0.6)
        return viewController
    }
}

extension SlideMenuSampleViewController: SlideMenuViewControllerDelegate {
    
    func slideMenuViewController(_ slideMenuViewController: UIViewController, didChange viewController: UIViewController) {
        print(viewController)
    }
}
