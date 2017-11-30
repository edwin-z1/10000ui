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
        
        // set local images
        var images: [UIImage] = []
        for i in 1...4 {
            let image = UIImage(contentsOfFile: Bundle.main.path(forResource: "\(i)", ofType: ".jpg")!)!
            images.append(image)
        }
        cycleThroughView.images = images
        
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

