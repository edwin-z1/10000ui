//
//  CycleThroughViewController.swift
//  BSCycleThroughViewSample
//
//  Created by 张亚东 on 25/07/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import UIKit

class CycleThroughViewController: UIViewController {

    @IBOutlet weak var cycleThroughView: BSCycleThroughView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        cycleThroughView.scrollTimeInterval = 5
        
        var images: [UIImage] = []
        for i in 1...4 {
            let image = UIImage(contentsOfFile: Bundle.main.path(forResource: "\(i)", ofType: ".jpg")!)!
            images.append(image)
        }
        
        // set local images
        cycleThroughView.images = images
        
        // set image urls
//        cycleThroughView.imageUrlStrings = ["http://s9.knowsky.com/bizhi/l/55001-65000/2009529123133602476178.jpg",
//                                           "http://img4.duitang.com/uploads/item/201403/31/20140331094819_dayKx.jpeg",
//                                           "http://i1.17173cdn.com/9ih5jd/YWxqaGBf/forum/images/2014/08/05/201143hmymxmizwmqi86yi.jpg",
//                                           "http://p1.image.hiapk.com/uploads/allimg/150413/7730-150413103526-51.jpg"]
        
        cycleThroughView.imageDidSelectedClousure = { index in
            print(index)
        }
    }

}

