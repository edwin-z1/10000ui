//
//  LoadingViewControllerSampleViewController.swift
//  10000ui-swift
//
//  Created by 张亚东 on 11/10/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import UIKit

class LoadingViewControllerSampleViewController: UIViewController {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        LoadingViewController.show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            LoadingViewController.hide()
        }
    }
}
