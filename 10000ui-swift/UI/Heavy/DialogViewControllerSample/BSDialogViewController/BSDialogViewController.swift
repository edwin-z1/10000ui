//
//  DialogViewController.swift
//  10000ui-swift
//
//  Created by 张亚东 on 19/05/2017.
//  Copyright © 2017 Jumei. All rights reserved.
//

import UIKit
import SwiftyJSON

// 如果imageUrl和image都设置了 优先使用imageUrl
enum BSDialogStyle {
    case image(imageUrl: String?, image: UIImage?, message: String)
    case text(title: String, message: String)
}

class DialogViewController: BSPopoverController {
    
    convenience init?(dialogJson: JSON?, handler:((SchemeModel) -> Void)? = nil) {

        guard let dialogDict = dialogJson?.dictionaryObject,
            let dialog = Dialog(JSON: dialogDict) else {
            return nil
        }
        self.init(dialog: dialog, handler: handler)
    }
    
    convenience init?(dialog: Dialog, handler:((SchemeModel) -> Void)? = nil) {
        let dialogStyle: DialogStyle!
        switch dialog.type {
            case "1":
                dialogStyle = .text(title: dialog.title, message: dialog.message)
            case "2":
                dialogStyle = .imageCenter(imageUrl: dialog.imageUrl, image: dialog.image, title: dialog.title, message: dialog.message)
            case "3":
                dialogStyle = .imageFill(imageUrl: dialog.imageUrl, image: dialog.image, message: dialog.message)
            default:return nil
        }
        self.init(dialogStyle: dialogStyle)
        setupActionButtons(withDialog: dialog, handler: handler)
    }
    
    convenience init(dialogStyle: DialogStyle) {
        self.init()
        self.dialogStyle = dialogStyle
        // As Apple says didSet (and willSet as well) is not called during the init.
        dialogViewContentView.dialogStyle = dialogStyle
        setup()
    }
    
    fileprivate(set) var dialogStyle: DialogStyle?
    fileprivate lazy var dialogViewContentView: DialogViewContentView = {
        let dialog = DialogViewContentView.instanceFromNib() as! DialogViewContentView
        dialog.layer.cornerRadius = 10
        dialog.presentingViewController = self
        return dialog
    }()
    
    @discardableResult
    override func present() -> Bool {
        
        guard !BSPopoverController.isAnyPresented,
            !isPresented else {
            return false
        }
        return super.present()
    }
}

private extension DialogViewController {
    
    func setup() {
        
        view.addSubview(dialogViewContentView)
        dialogViewContentView.snp.makeConstraints({ (maker) in
            maker.center.equalToSuperview()
        })
        
        // override
        isTapGestureEnabled = false
        maskColor = UIColor(hexString: "#000000", alpha: 0.5)!
        dialogViewContentView.alpha = 0
        
        presentAnimations = { [weak self] in
            self?.dialogViewContentView.alpha = 1
        }
        dismissAnimations = { [weak self] in
            self?.dialogViewContentView.alpha = 0
        }
    }
    
    func setupActionButtons(withDialog dialog: Dialog, handler:((SchemeModel) -> Void)?) {
        for (index, schemeModel) in dialog.schemeModels.enumerated() {
            guard index <= 1 else {
                break
            }
            addAction(BSDialogAction(title: schemeModel.text, style: .customColor(hexString: schemeModel.fontColorHexString) , handler: { (action) in
                
                let handleClosure = {
                    if let handler = handler {
                        handler(schemeModel)
                    } else {
                        JMRouter.routing(url: schemeModel.scheme)
                    }
                }
                
                if let loadingTime = TimeInterval(schemeModel.loading), loadingTime > 0 {
                    App.rootVC.view.sp.showLoading()
                    DispatchQueue.main.asyncAfter(deadline: .now() + loadingTime, execute: {
                        handleClosure()
                        App.rootVC.view.sp.hideLoading()
                    })
                } else {
                    handleClosure()
                }
            }))
        }
    }
}

extension DialogViewController {
    
    func addAction(_ action: BSDialogAction) {
        dialogViewContentView.addAction(action)
    }
}
