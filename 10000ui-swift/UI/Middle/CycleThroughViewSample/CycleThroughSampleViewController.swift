//
//  CycleThroughSampleViewController.swift
//  10000ui-swift
//
//  Created by 张亚东 on 25/07/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import UIKit

private let insetsTop: CGFloat = 180

class CycleThroughSampleViewController: UIViewController {

    @IBOutlet weak var cycleThroughView: CycleThroughView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cycleThroughView.clean()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupTableView()
        setupCycleThroughView()
    }
    
    func setupTableView() {
        tableView.contentInset = UIEdgeInsetsMake(insetsTop, 0, 0, 0)
    }
    
    func setupCycleThroughView() {
        
        tableView.insertSubview(cycleThroughView, at: 0)
        
        cycleThroughView.frame = CGRect(origin: .init(x: 0, y: -insetsTop), size: .init(width: view.bs.width, height: insetsTop))
        
        cycleThroughView.zoomForScrollView = tableView
        
        cycleThroughView.scrollTimeInterval = 5
        
        /* set local images
        cycleThroughView.images = [#imageLiteral(resourceName: "c_01"), #imageLiteral(resourceName: "c_10"), #imageLiteral(resourceName: "c_13")]
        cycleThroughView.placeholderImage = nil
        */
        
        // set image urls
        cycleThroughView.imageUrlStrings = ["http://static.event.mihoyo.com/bh3_homepage/images/pic/picture/15.jpg",
                                            "http://static.event.mihoyo.com/bh3_homepage/images/pic/picture/14.jpg",
                                            "http://static.event.mihoyo.com/bh3_homepage/images/pic/picture/09.jpg",
                                            "http://static.event.mihoyo.com/bh3_homepage/images/pic/picture/06.jpg"]
        
        cycleThroughView.imageDidSelectedClousure = { index in
            print(index)
        }
    }
}

