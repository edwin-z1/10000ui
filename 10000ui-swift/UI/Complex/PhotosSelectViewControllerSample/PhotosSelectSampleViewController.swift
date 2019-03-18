//
//  PhotosSelectSampleViewController.swift
//  10000ui-swift
//
//  Created by blurryssky on 2019/3/14.
//  Copyright © 2019 blurryssky. All rights reserved.
//

import UIKit

class PhotosSelectSampleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func handlePhotosSelectButton(_ sender: UIButton) {
        
        _ = AuthorizationManager.requestPhotoLibraryAuthorization()
            .subscribe(onNext: { [unowned self] (isGranted) in
                guard isGranted else {
                    return
                }
                let photosSelectVC = PhotosSelectViewController.bs.instantiateFromStoryboard(name: "PhotosSelectViewController")
                let navi = UINavigationController(rootViewController: photosSelectVC)
                photosSelectVC.photosDidSelectClosure = { [unowned navi] assets in
                    navi.dismiss(animated: true, completion: nil)
                    print(assets)
                }
                self.present(navi, animated: true, completion: nil)
            })
    }
}
