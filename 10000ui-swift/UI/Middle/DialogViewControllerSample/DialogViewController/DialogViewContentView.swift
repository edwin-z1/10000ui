//
//  DialogViewContentView.swift
//  10000ui-swift
//
//  Created by 张亚东 on 19/05/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

private struct Defaults {
    static var actionHeight: CGFloat = 49
}

class DialogViewContentView: UIView {
    
    var dialogStyle: DialogViewControllerStyle! {
        didSet {
            setupSubviews()
        }
    }
    
    weak var presentingViewController: DialogViewController?
    @IBOutlet weak var styleBgView: UIView!
    @IBOutlet weak var actionBgView: UIView!
    
    @IBOutlet weak var constraintActionBgViewHeight: NSLayoutConstraint!
    
    fileprivate var actions: [DialogAction] = []
    fileprivate var actionButtons: [UIButton] = []
    
    lazy var textStyleView: DialogTextStyleView = {
        let dialog = DialogTextStyleView.instantiateFromNib() as! DialogTextStyleView
        return dialog
    }()
    
    lazy var imageStyleView: DialogImageStyleView = {
        let dialog = DialogImageStyleView.instantiateFromNib() as! DialogImageStyleView
        return dialog
    }()
    
}

private extension DialogViewContentView {
    
    func setupSubviews() {
        
        switch dialogStyle! {
        case let .image(remoteImage, localImage, message):
            setupImageStyle(remoteImage: remoteImage, localImage: localImage, message: message)
        case let .text(title, message):
            setupTextStyle(title: title, message: message)
        }
    }
    
    func setupImageStyle(remoteImage: (url: URL, width: CGFloat, height: CGFloat)?, localImage: UIImage?, message: String) {

        if let (url, width, height) = remoteImage {
            imageStyleView.constraintImgViewWidth.constant = width
            imageStyleView.constraintImgViewHeight.constant = height
            imageStyleView.imgView.kf.setImage(with: ImageResource(downloadURL: url))
        } else if let localImage = localImage {
            imageStyleView.constraintImgViewWidth.constant = localImage.size.width
            imageStyleView.constraintImgViewHeight.constant = localImage.size.height
            imageStyleView.imgView.image = localImage
        }
        
        imageStyleView.messageLabel.text = message
        styleBgView.addSubview(imageStyleView)
        imageStyleView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    func setupTextStyle(title: String, message: String) {

        textStyleView.titleLabel.text = title
        textStyleView.messageLabel.text = message
        styleBgView.addSubview(textStyleView)
        textStyleView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
}

private extension DialogViewContentView {
    
    func setupSingleAction() {
        constraintActionBgViewHeight.constant = Defaults.actionHeight
        
        let firstAction = actions.first!
        let button = newActionButton(dialogAction: firstAction)
        actionBgView.addSubview(button)
        button.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    func setupDoubleAction() {
        constraintActionBgViewHeight.constant = Defaults.actionHeight
        
        let firstAction = actions.first!
        let lastAction = actions.last!
        let firstButton = newActionButton(dialogAction: firstAction)
        actionBgView.addSubview(firstButton)
        
        let lastButton = newActionButton(dialogAction: lastAction)
        actionBgView.addSubview(lastButton)
        
        firstButton.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.left.equalToSuperview()
            maker.right.equalTo(lastButton.snp.left)
            maker.bottom.equalToSuperview()
        }
        
        lastButton.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.left.equalTo(firstButton.snp.right)
            maker.right.equalToSuperview()
            maker.width.equalTo(firstButton)
            maker.bottom.equalToSuperview()
        }
        
        let verLine = UIView()
        verLine.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        actionBgView.addSubview(verLine)
        verLine.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.height.equalTo(30)
            maker.width.equalTo(1/UIScreen.main.scale)
        }
    }
    
    func setupMultiAction() {
        constraintActionBgViewHeight.constant = Defaults.actionHeight * CGFloat(actions.count)
        
        var lastButton: UIButton?
        for action in actions {
            let button = newActionButton(dialogAction: action)
            actionBgView.addSubview(button)
            button.snp.makeConstraints { (maker) in
                if let lastButton = lastButton {
                    maker.top.equalTo(lastButton.snp.bottom)
                } else {
                    maker.top.equalToSuperview()
                }
                maker.left.equalToSuperview()
                maker.right.equalToSuperview()
                maker.height.equalTo(Defaults.actionHeight)
            }
            lastButton = button
        }
    }
    
    func newActionButton(dialogAction: DialogAction) -> UIButton {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        switch dialogAction.style {
        case .default:
            button.setTitleColor(#colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1), for: .normal)
        case let .customColor(hexString):
            button.setTitleColor(UIColor.bs.color(hexString: hexString) ?? #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1), for: .normal)
        }
        button.setTitle(dialogAction.title, for: .normal)
        button.addTarget(self, action: #selector(handleActionButton(_:)), for: .touchUpInside)
        actionButtons.append(button)
        
        let horLine = UIView()
        horLine.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        button.addSubview(horLine)
        horLine.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.height.equalTo(1/UIScreen.main.scale)
        }
        return button
    }
    
    @objc func handleActionButton(_ button: UIButton) {
        guard let index = actionButtons.firstIndex(of: button) else {
            return
        }
        let action = actions[index]
        action.handler?(action)
        presentingViewController?.dismiss()
    }
}

extension DialogViewContentView {
    
    func addAction(_ action: DialogAction) {
        
        actions.append(action)
        actionBgView.subviews.forEach {
            $0.removeFromSuperview()
        }
        actionButtons.removeAll(keepingCapacity: false)
        
        if actions.count == 1 {
            setupSingleAction()
        } else if actions.count == 2 {
            setupDoubleAction()
        } else {
            setupMultiAction()
        }
    }
}

