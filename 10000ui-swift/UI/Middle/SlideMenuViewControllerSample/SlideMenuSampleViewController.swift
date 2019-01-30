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
        addChild(slideMenuViewController)
        slideMenuViewController.didMove(toParent: self)
        
        slideMenuViewController.setMenuTitles(["草莓🍓", "葡萄🍇", "苹果🍎", "菠萝🍍", "猕猴桃🥝", "香蕉🍌"])
        slideMenuViewController.dataSource = self
        slideMenuViewController.delegate = self
    }
}

extension SlideMenuSampleViewController: SlideMenuViewControllerDataSource {
    
    func slideMenuViewController(_ slideMenuViewController: UIViewController, viewControllerForItemAt index: Int) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = UIColor.bs.random(alpha: 0.3)
        return viewController
    }
}

extension SlideMenuSampleViewController: SlideMenuViewControllerDelegate {
    
    func slideMenuViewController(_ slideMenuViewController: UIViewController, didChange viewController: UIViewController) {
        print(viewController)
    }
}
