//
//  AlbumsSelectTableCell.swift
//  Kuso
//
//  Created by blurryssky on 2018/8/1.
//  Copyright © 2018年 momo. All rights reserved.
//

import UIKit
import Photos

class AlbumsSelectTableCell: UITableViewCell {
    
    var fetchType: PhotosFetchType!
    var assetCollection: PHAssetCollection! {
        didSet {
            update()
        }
    }

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    fileprivate var requestId: PHImageRequestID?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if let rid = requestId {
            PhotosManager.imageManager.cancelImageRequest(rid)
        }
        imgView.image = nil
    }
}

private extension AlbumsSelectTableCell {
    
    func update() {
        let fetchOptions = PhotosManager.optionsForFetchType(fetchType)
        let assetFetchResult = PHAsset.fetchAssets(in: assetCollection, options: fetchOptions)
        guard let asset = assetFetchResult.lastObject else { return }
        
        requestId = PhotosManager.reqeustStillImage(for: asset, width: 40, height: 40) { [weak self] img in
            guard let `self` = self, let img = img else { return }
            self.imgView.image = img
        }
        
        nameLabel.text = "\(assetCollection.localizedTitle ?? "")(\(assetFetchResult.count))"
    }
}
