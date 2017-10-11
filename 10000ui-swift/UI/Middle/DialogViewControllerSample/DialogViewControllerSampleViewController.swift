//
//  DialogViewControllerSampleViewController.swift
//  10000ui-swift
//
//  Created by 张亚东 on 10/10/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import UIKit

class DialogViewControllerSampleViewController: UIViewController {

    @IBAction func handleShow1ButtonDialogButton(_ sender: UIButton) {
        DialogViewController(dialogStyle: .text(title: "Hello", message: "click to dismiss")).addAction(DialogAction(title: "click")).present()
    }
    @IBAction func handleShow2ButtonDialogButton(_ sender: UIButton) {
        DialogViewController(dialogStyle: .text(title: "Hello", message: "click to dismiss")).addAction(DialogAction(title: "cancel", style: .customColor(hexString: "333333"))).addAction(DialogAction(title: "click")).present()
    }
    
    @IBAction func handleShowMoreButtonDialogButton(_ sender: UIButton) {
        DialogViewController(dialogStyle: .text(title: "Hello", message: "click to dismiss")).addAction(DialogAction(title: "cancel", style: .customColor(hexString: "333333"))).addAction(DialogAction(title: "click")).addAction(DialogAction(title: "whatever", style: .customColor(hexString: "85ce1a"))).present()
    }
    
    @IBAction func handleShowDialogWithImageButton(_ sender: UIButton) {
        DialogViewController(dialogStyle: .image(remoteImage: nil, localImage: #imageLiteral(resourceName: "bh3"), message: "tech otakus save the world ")).addAction(DialogAction(title: "hmmm..")).present()
    }
}
