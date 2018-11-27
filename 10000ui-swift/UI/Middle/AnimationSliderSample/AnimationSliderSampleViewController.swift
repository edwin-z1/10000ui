//
//  AnimationSliderSampleViewController.swift
//  10000ui-swift
//
//  Created by blurryssky on 2018/5/1.
//  Copyright © 2018年 blurryssky. All rights reserved.
//

import UIKit

class AnimationSliderSampleViewController: UIViewController {

    @IBOutlet weak var animationSlider: AnimationSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        animationSlider.thumbImage = #imageLiteral(resourceName: "circleslider_thumb")
        animationSlider.thumbExtendRespondsRadius = 20
        animationSlider.addTarget(self, action: #selector(handleSliderValueChanged(sender:)), for: .valueChanged)
        
    }

    @objc func handleSliderValueChanged(sender: AnimationSlider) {
        
        print(sender.value)
    }
    
    @IBAction func handleButton(_ sender: UIButton) {
        
        if sender.isSelected {
            animationSlider.stopIncrese()
            sender.setTitle("开始", for: .normal)
        } else {
            animationSlider.increaseValueToMaximum(duration: TimeInterval(10 * (1 - animationSlider.value)))
            sender.setTitle("停止", for: .normal)
        }
        
        sender.isSelected = !sender.isSelected
    }
}
