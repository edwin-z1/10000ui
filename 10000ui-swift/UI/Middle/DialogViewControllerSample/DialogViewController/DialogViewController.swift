//
//  DialogViewController.swift
//  10000ui-swift
//
//  Created by 张亚东 on 19/05/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import UIKit

// remoteImage和localImage均赋值 则优先使用remoteImage
enum DialogViewControllerStyle {
    case image(remoteImage: (url: URL, width: CGFloat, height: CGFloat)?, localImage: UIImage?, message: String)
    case text(title: String, message: String)
}

class DialogViewController: PopoverController {
    
    var dialogViewCornerRadius: CGFloat = 10 {
        didSet {
            dialogViewContentView.layer.cornerRadius = dialogViewCornerRadius
        }
    }
    
    convenience init(dialogStyle: DialogViewControllerStyle) {
        self.init()
        self.dialogStyle = dialogStyle
        dialogViewContentView.dialogStyle = dialogStyle
        setup()
    }
    
    fileprivate(set) var dialogStyle: DialogViewControllerStyle?
    fileprivate lazy var dialogViewContentView: DialogViewContentView = {
        let dialog = DialogViewContentView.instantiateFromNib() as! DialogViewContentView
        dialog.layer.cornerRadius = self.dialogViewCornerRadius
        dialog.presentingViewController = self
        return dialog
    }()
    
    @discardableResult
    override func present() -> Bool {
        
        guard !PopoverController.isAnyPresented,
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
        maskColor = UIColor.bs.color(hexString: "000000", alpha: 0.5)!
        dialogViewContentView.alpha = 0
        
        presentAnimations = { [weak self] in
            self?.dialogViewContentView.alpha = 1
        }
        dismissAnimations = { [weak self] in
            self?.dialogViewContentView.alpha = 0
        }
    }
}

extension DialogViewController {
    
    func addAction(_ action: DialogAction) -> DialogViewController {
        dialogViewContentView.addAction(action)
        return self
    }
}
