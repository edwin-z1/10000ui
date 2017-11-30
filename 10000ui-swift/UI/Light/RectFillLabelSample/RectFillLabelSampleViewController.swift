//
//  RectFillLabelSampleViewController.swift
//  10000ui-swift
//
//  Created by 张亚东 on 30/11/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import UIKit

class RectFillLabelSampleViewController: UIViewController {
    @IBOutlet weak var rectFillLabel: RectFillLabel!
    @IBOutlet weak var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        slider.addTarget(self, action: #selector(handleSlider), for: .valueChanged)
    }

    @objc func handleSlider() {
        rectFillLabel.progress = slider.value
    }
}
