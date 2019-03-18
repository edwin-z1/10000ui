//
//  PhotosGifRequester.swift
//  Kuso
//
//  Created by blurryssky on 2018/12/27.
//  Copyright © 2018 momo. All rights reserved.
//

import Foundation
import Photos

class PhotosImageRequester: NSObject {
    
    fileprivate var requestId: PHImageRequestID?
    
    func reqeustGif(for asset: PHAsset, width: CGFloat, height: CGFloat? = nil, isGif: Bool = false, resultHandler: @escaping ((UIImage) -> Void)) {

        // gif
        if asset.mediaSubtypes.rawValue == 32 || isGif {

            let options = PHImageRequestOptions()
            options.isNetworkAccessAllowed = true

            self.requestId = PhotosManager.imageManager.requestImageData(for: asset, options: options, resultHandler: { (data, _, _, _) in
                guard let data = data else { return }
                DispatchQueue.global().async {
                    let gif = UIImage.bs_image(withGIFData: data)
                    DispatchQueue.main.async {
                        resultHandler(gif)
                    }
                }
            })
            
        } else {
            // img
            requestId = PhotosManager.reqeustStillImage(for: asset, width: width, height: height) { img in
                guard let img = img else { return }
                resultHandler(img)
            }
        }
    }
    
    func cancel() {
        if let rid = requestId {
            PhotosManager.imageManager.cancelImageRequest(rid)
        }
    }
}
