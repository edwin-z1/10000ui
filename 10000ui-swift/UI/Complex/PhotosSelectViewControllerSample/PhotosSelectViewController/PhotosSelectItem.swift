//
//  PhotosSelectItem.swift
//  Kuso
//
//  Created by blurryssky on 2018/8/2.
//  Copyright © 2018年 momo. All rights reserved.
//

import UIKit
import Photos

import RxSwift

class PhotosSelectItem: NSObject {
    
    var isCamera = false
    var asset: PHAsset?
    var cellSize = CGSize.zero
    var selectIndexVariable: Variable<Int?> = Variable(nil)
    var isShowMaskVariable = Variable(false)
    var mutliSelectionType: PhotosMultiSelectionType = .image

    init(asset: PHAsset, cellSize: CGSize) {
        self.asset = asset
        self.cellSize = cellSize
    }
    
    init(isCamera: Bool) {
        self.isCamera = isCamera
    }
    
}
