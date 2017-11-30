//
//  FadingLabelSampleViewController.swift
//  10000ui-swift
//
//  Created by 张亚东 on 20/10/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import UIKit

class FadingLabelSampleViewController: UIViewController {

    @IBOutlet weak var fadingLabel: FadingLabel!
    var touchCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 6
        let attributedString = NSMutableAttributedString(string: "律者诞生是崩坏的一种表现形式, 因此一次崩坏只会产生一名「律者」, 但是在某种特殊情况下, 会产生崩坏能接近「律者」的个体, 他们的力量远远高于「崩坏兽」和「死士」, 接近律者但是又不具备律者核心, 其名为「拟似律者」与高浓度崩坏能量接触的人也有可能变为「拟似律者」（更大的可能是变为死士）拟似律者往往具备强大的意志或者无法放弃的羁绊, 这使得他们没有成为死士反而变成更加强大的存在。", attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .paragraphStyle: paraStyle])
        let colors = [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)]
        let interval = 18
        for index in (0..<attributedString.length/interval) {
            attributedString.addAttribute(.foregroundColor, value: colors[index%7], range: .init(location: index * interval, length: interval))
        }

        fadingLabel.attributedText = attributedString
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard !fadingLabel.isAnimating else {
            return
        }
        switch touchCount%4 {
        case 0:
            fadingLabel.fade(mode: .orderly(eachCharacterDuration: 0.2), type: .in)
        case 1:
            fadingLabel.fade(mode: .orderly(eachCharacterDuration: 0.2), type: .out)
        case 2:
            fadingLabel.fade(mode: .randomly(totalDuration: 2.5, strategy: .partly(maxCount: 50)), type: .in)
        case 3:
            fadingLabel.fade(mode: .randomly(totalDuration: 2.5, strategy: .partly(maxCount: 50)), type: .out)
        default:
            break
        }
        touchCount += 1
    }
}
