//
//  CircularRevealTransitionSampleViewController2.swift
//  10000ui-swift
//
//  Created by 张亚东 on 02/11/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import UIKit

class CircularRevealTransitionSampleViewController2: UIViewController {
    
    fileprivate var circularTransition: CircularRevealTransition {
        return navigationController!.bs.circularRevealTransition
    }
    
    fileprivate lazy var pushButton : UIButton = {
        let button = UIButton()
        button.setTitle("Push", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.bounds = CGRect(origin: .zero, size: .init(width: 44, height: 44))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.bs.random(alpha: 0.5).cgColor, UIColor.bs.random(alpha: 0.5).cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        let randomX = CGFloat(arc4random()%UInt32(view.bounds.width - 40) + 20)
        let randomY = CGFloat(arc4random()%UInt32(view.bounds.height - 80 - 64) + 40 + 64)
        pushButton.center = CGPoint(x: randomX, y: randomY)
        pushButton.addTarget(self, action: #selector(handlePushButton(_:)), for: .touchUpInside)
        view.addSubview(pushButton)
    }
    
    @objc func handlePushButton(_ sender: UIButton) {
        circularTransition.fromCenter = sender.center
        
        let c2 = UIStoryboard(name: "CircularRevealTransition", bundle: nil).instantiateViewController(withIdentifier: "CircularRevealTransitionSampleViewController2")
        navigationController?.pushViewController(c2, animated: true)
    }
    
    @IBAction func handleButton(_ sender: UIButton) {
        circularTransition.fromCenter = sender.center
        
        navigationController?.popViewController(animated: true)
    }
}
