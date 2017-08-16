//
//  CircleSliderSampleViewController.swift
//  BSCircleSliderSample
//
//  Created by 张亚东 on 07/08/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import UIKit

class CircleSliderSampleViewController: UIViewController, TopBarsAppearanceChangable {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var circleSlider: BSCircleSlider!
    
    @IBOutlet weak var minValueLabel: UILabel!
    @IBOutlet weak var maxValueLabel: UILabel!
    @IBOutlet weak var startAngleLabel: UILabel!
    @IBOutlet weak var circumAngleLabel: UILabel!
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var lineWidthLabel: UILabel!
    @IBOutlet weak var startColorRLabel: UILabel!
    @IBOutlet weak var startColorGLabel: UILabel!
    @IBOutlet weak var startColorBLabel: UILabel!
    @IBOutlet weak var symmetryRLabel: UILabel!
    @IBOutlet weak var symmetryGLabel: UILabel!
    @IBOutlet weak var symmetryBLabel: UILabel!
    
    @IBOutlet weak var minValueSlider: UISlider!
    @IBOutlet weak var maxValueSlider: UISlider!
    @IBOutlet weak var startAngleSlider: UISlider!
    @IBOutlet weak var circumAngleSlider: UISlider!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var lineWidthSlider: UISlider!
    @IBOutlet weak var startColorRSlider: UISlider!
    @IBOutlet weak var startColorGSlider: UISlider!
    @IBOutlet weak var startColorBSlider: UISlider!
    @IBOutlet weak var symmetryRSlider: UISlider!
    @IBOutlet weak var symmetryGSlider: UISlider!
    @IBOutlet weak var symmetryBSlider: UISlider!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTopBarsAppearanceStyle(.clearBackground, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bs.setRightItem(title: "随机值") { [unowned self] in
            self.randomSetValueAnimated()
        }
        setupCircleSlider()
        setupUISlider()
        updateUISlider()
    }
}

fileprivate extension CircleSliderSampleViewController {
    
    func setupCircleSlider() {
        circleSlider.thumbImage = #imageLiteral(resourceName: "thumb")
        circleSlider.thumbExtendRespondsRadius = 20
        circleSlider.addTarget(self, action: #selector(handleCircleSliderValueChanged(sender:)), for: .valueChanged)
    }
    
    func setupUISlider() {
        
        startAngleSlider.minimumValue = 0
        startAngleSlider.maximumValue = .pi * 2
        
        circumAngleSlider.minimumValue = 0
        circumAngleSlider.maximumValue = .pi * 2
        circumAngleSlider.value = .pi * 2
        
        [minValueSlider, maxValueSlider, startAngleSlider, circumAngleSlider, radiusSlider, lineWidthSlider, startColorRSlider, startColorGSlider, startColorBSlider, symmetryRSlider, symmetryGSlider, symmetryBSlider].forEach {
            $0?.setThumbImage(#imageLiteral(resourceName: "thumb"), for: .normal)
        }
    }
    
    func updateUISlider() {
        handleMinValueSlider(minValueSlider)
        handleMaxValueSlider(maxValueSlider)
        handleStartAngleSlider(startAngleSlider)
        handleCircumAngleSlider(circumAngleSlider)
        handleRadiusSlider(radiusSlider)
        handleLineWidthSlider(lineWidthSlider)
        handleStartColorRSlider(startColorRSlider)
        handleStartColorGSlider(startColorGSlider)
        handleStartColorBSlider(startColorBSlider)
        handleSymmetryRSlider(symmetryRSlider)
        handleSymmetryGSlider(symmetryGSlider)
        handleSymmetryBSlider(symmetryBSlider)
    }
    
    func randomSetValueAnimated() {
        let fraction = CGFloat(arc4random()%100)/100
        let value = (circleSlider.maximumValue - circleSlider.minimumValue) * fraction + circleSlider.minimumValue
        circleSlider.setValue(value: value, animated: true)
    }
    
    func updateLabel() {
        let valueString = String(format: "value: %.1f min: %.1f max: %.1f", circleSlider.value, circleSlider.minimumValue, circleSlider.maximumValue)
        label.text = valueString
    }
    
    func updateStartPointColor() {
        
        let symmertyPointColor = circleSlider.minimunTrackTintColors.last!
        let color = UIColor(red: CGFloat(startColorRSlider.value/255), green: CGFloat(startColorGSlider.value/255), blue: CGFloat(startColorBSlider.value/255), alpha: 1)
        circleSlider.minimunTrackTintColors = [color, symmertyPointColor]
    }
    
    func updateSymmetryPointColor() {
        let startPointColor = circleSlider.minimunTrackTintColors.first!
        let color = UIColor(red: CGFloat(symmetryRSlider.value/255), green: CGFloat(symmetryGSlider.value/255), blue: CGFloat(symmetryBSlider.value/255), alpha: 1)
        circleSlider.minimunTrackTintColors = [startPointColor, color]
    }
}

fileprivate extension CircleSliderSampleViewController {
    
    @objc func handleCircleSliderValueChanged(sender: BSCircleSlider) {
        
        updateLabel()
        print(sender.value)
    }
    
    @IBAction func handleMinValueSlider(_ sender: UISlider) {
        minValueLabel.text = String(format: "最小值: %.1f", sender.value)
        circleSlider.minimumValue = CGFloat(sender.value)
        updateLabel()
    }
    
    @IBAction func handleMaxValueSlider(_ sender: UISlider) {
        maxValueLabel.text = String(format: "最大值: %.1f", sender.value)
        circleSlider.maximumValue = CGFloat(sender.value)
        updateLabel()
    }
    
    @IBAction func handleStartAngleSlider(_ sender: UISlider) {
        startAngleLabel.text = String(format: "起始角: %.2f", sender.value)
        circleSlider.startAngleFromNorth = CGFloat(sender.value)
        updateLabel()
    }
    
    @IBAction func handleCircumAngleSlider(_ sender: UISlider) {
        circumAngleLabel.text = String(format: "圆周角: %.2f", sender.value)
        circleSlider.circumAngle = CGFloat(sender.value)
        updateLabel()
    }
    
    @IBAction func handleRadiusSlider(_ sender: UISlider) {
        radiusLabel.text = String(format: "半径: %.2f", sender.value)
        circleSlider.radius = CGFloat(sender.value)
    }
    
    @IBAction func handleLineWidthSlider(_ sender: UISlider) {
        lineWidthLabel.text = String(format: "线宽: %.2f", sender.value)
        circleSlider.lineWidth = CGFloat(sender.value)
    }
    
    @IBAction func handleStartColorRSlider(_ sender: UISlider) {
        startColorRLabel.text = String(format: "r: %.0f", sender.value)
        updateStartPointColor()
    }
    
    @IBAction func handleStartColorGSlider(_ sender: UISlider) {
        startColorGLabel.text = String(format: "g: %.0f", sender.value)
        updateStartPointColor()
    }
    
    @IBAction func handleStartColorBSlider(_ sender: UISlider) {
        startColorBLabel.text = String(format: "b: %.0f", sender.value)
        updateStartPointColor()
    }
    
    @IBAction func handleSymmetryRSlider(_ sender: UISlider) {
        symmetryRLabel.text = String(format: "r: %.0f", sender.value)
        updateSymmetryPointColor()
    }
    
    @IBAction func handleSymmetryGSlider(_ sender: UISlider) {
        symmetryGLabel.text = String(format: "g: %.0f", sender.value)
        updateSymmetryPointColor()
    }
    
    @IBAction func handleSymmetryBSlider(_ sender: UISlider) {
        symmetryBLabel.text = String(format: "b: %.0f", sender.value)
        updateSymmetryPointColor()
    }
}

