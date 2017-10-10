//
//  DialogViewContentView.swift
//  10000ui-swift
//
//  Created by 张亚东 on 19/05/2017.
//  Copyright © 2017 Jumei. All rights reserved.
//

import UIKit
import SnapKit

private struct Defaults {
    static var contentWidth: CGFloat = 305
    static var singleActionHeight: CGFloat = 49
}

class DialogViewContentView: UIView {
    
    var dialogStyle: DialogStyle! {
        didSet {
            setupSubviews()
        }
    }
    
    weak var presentingViewController: DialogViewController?
    @IBOutlet weak var styleBgView: UIView!
    @IBOutlet weak var actionBgView: UIView!
    
    @IBOutlet weak var constraintactionActionBgViewHeight: NSLayoutConstraint!
    
    fileprivate(set) var actions: [BSDialogAction] = []
    fileprivate(set) var actionButtons: [UIButton] = []
    
    lazy var textStyleView: DialogTextStyleView = {
        let dialog = DialogTextStyleView.instanceFromNib() as! DialogTextStyleView
        return dialog
    }()
    
    lazy var imageStyleFillView: BSDialogImageStyleView = {
        let dialog = BSDialogImageStyleView.instanceFromNib() as! BSDialogImageStyleView
        return dialog
    }()
    
    lazy var imageStyleCenterView: DialogImageStyleCenterView = {
        let dialog = DialogImageStyleCenterView.instanceFromNib() as! DialogImageStyleCenterView
        return dialog
    }()
}

private extension DialogViewContentView {
    
    func setupSubviews() {
        
        switch dialogStyle! {
        case let .imageCenter(imageUrl, image, title, message):
            setupImageStyleCenter(imageUrl: imageUrl, image: image, title: title, message: message)
        case let .imageFill(imageUrl, image, message):
            setupImageStyleFill(imageUrl: imageUrl, image: image, message: message)
        case let .text(title, message):
            setupTextStyle(title: title, message: message)
        }
    }
    
    func setupImageStyleCenter(imageUrl: String?, image: UIImage?, title: String, message: String) {

        if let imgUrl = imageUrl {
            imageStyleCenterView.imgView.setImage(with: imgUrl)
        } else if let img = image {
            imageStyleCenterView.imgView.image = img
        }
        
        imageStyleCenterView.titleLabel.text = title
        imageStyleCenterView.messageLabel.text = message
        styleBgView.addSubview(imageStyleCenterView)
        imageStyleCenterView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    func setupImageStyleFill(imageUrl: String?, image: UIImage?, message: String) {

        if let imgUrl = imageUrl {
            imageStyleFillView.imgView.setImage(with: imgUrl)
        } else if let img = image {
            imageStyleFillView.imgView.image = img
        }

        imageStyleFillView.messageLabel.text = message
        styleBgView.addSubview(imageStyleFillView)
        imageStyleFillView.snp.makeConstraints { (maker) in
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
        constraintactionActionBgViewHeight.constant = Defaults.singleActionHeight
        
        let firstAction = actions.first!
        let button = newActionButton(BSDialogAction: firstAction)
        actionBgView.addSubview(button)
        button.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    func setupDoubleAction() {
        constraintactionActionBgViewHeight.constant = Defaults.singleActionHeight
        
        let firstAction = actions.first!
        let lastAction = actions.last!
        let firstButton = newActionButton(BSDialogAction: firstAction)
        actionBgView.addSubview(firstButton)
        firstButton.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.left.equalToSuperview()
            maker.width.equalTo(Defaults.contentWidth/2)
            maker.bottom.equalToSuperview()
        }
        
        let lastButton = newActionButton(BSDialogAction: lastAction)
        actionBgView.addSubview(lastButton)
        lastButton.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.right.equalToSuperview()
            maker.width.equalTo(Defaults.contentWidth/2)
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
        constraintactionActionBgViewHeight.constant = Defaults.singleActionHeight * CGFloat(actions.count)
        
        var lastButton: UIButton?
        for action in actions {
            let button = newActionButton(BSDialogAction: action)
            actionBgView.addSubview(button)
            button.snp.makeConstraints { (maker) in
                if let lastButton = lastButton {
                    maker.top.equalTo(lastButton.snp.bottom)
                } else {
                    maker.top.equalToSuperview()
                }
                maker.left.equalToSuperview()
                maker.right.equalToSuperview()
                maker.height.equalTo(Defaults.singleActionHeight)
            }
            lastButton = button
        }
    }
    
    func newActionButton(BSDialogAction: BSDialogAction) -> UIButton {
        let button = UIButton()
        button.titleLabel?.font = UIFont.sp.mediumSystemFont(size: 18)
        switch BSDialogAction.style! {
        case .destructive:
            button.setTitleColor(UIColor.sp.lightGreen, for: .normal)
        case .default:
            button.setTitleColor(UIColor.sp.gray, for: .normal)
        case let .customColor(hexString):
            button.setTitleColor(UIColor(hexString: hexString) ?? UIColor.sp.gray, for: .normal)
        }
        button.setTitle(BSDialogAction.title, for: .normal)
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
        guard let index = actionButtons.index(of: button) else {
            return
        }
        let action = actions[index]
        action.handler?(action)
        presentingViewController?.dismiss()
    }
}

extension DialogViewContentView {
    
    func addAction(_ action: BSDialogAction) {
        
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

