//
//  AssetsManager.swift
//  Kuso
//
//  Created by blurryssky on 2018/7/24.
//  Copyright © 2018年 momo. All rights reserved.
//

import UIKit
import Photos

import RxSwift

enum PhotosFetchType {
    case video
    case image
    case all
}

class PhotosManager: NSObject {

    static let imageManager = PHCachingImageManager.default()
}

extension PhotosManager {
    
    static func fetchAlbums(fetchType: PhotosFetchType) -> Observable<[PHAssetCollection]> {
        
        return Observable<[PHAssetCollection]>.create({ (observer) -> Disposable in
            
            let options = self.optionsForFetchType(fetchType)
            
            var albums: [PHAssetCollection] = []
            let smartAlbumsResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
            smartAlbumsResult.enumerateObjects { (collection, idx, stop) in
                
                let inCollectionResult = PHAsset.fetchAssets(in: collection, options: options)
                if inCollectionResult.count > 0 {
                    albums.append(collection)
                }
            }
            
            let albumsResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
            albumsResult.enumerateObjects { (collection, idx, stop) in
                
                let inCollectionResult = PHAsset.fetchAssets(in: collection, options: options)
                if inCollectionResult.count > 0 {
                    albums.append(collection)
                }
            }
            observer.onNext(albums)
            return Disposables.create()
        })
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInteractive))
            .observeOn(MainScheduler.asyncInstance)
    }
    
    static func fetchPhotos(album: PHAssetCollection?, fetchType: PhotosFetchType) -> Observable<[PHAsset]> {
        
        return Observable<[PHAsset]>.create { (observer) -> Disposable in
            
            let options = self.optionsForFetchType(fetchType)
            
            var result: PHFetchResult<PHAsset>!
            if let album = album {
                result = PHAsset.fetchAssets(in: album, options: options)
            } else {
                result = PHAsset.fetchAssets(with: options)
            }

            var assets: [PHAsset] = []
            result.enumerateObjects(options: .reverse) { (asset, idx, stop) in
                assets.append(asset)
            }
            observer.onNext(assets)
            return Disposables.create()
        }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInteractive))
            .observeOn(MainScheduler.asyncInstance)
    }
    
    static func optionsForFetchType(_ type: PhotosFetchType) -> PHFetchOptions {
        let options = PHFetchOptions()
        switch type {
        case .image:
            options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        case .video:
            options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue)
        case .all:
            options.predicate = NSPredicate(format: "mediaType != %d AND mediaType != %d", PHAssetMediaType.audio.rawValue, PHAssetMediaType.unknown.rawValue)
        }
        return options
    }
}

extension PhotosManager {
    
    @discardableResult
    static func reqeustStillImage(for asset: PHAsset, width w: CGFloat, height: CGFloat? = nil, contentMode: PHImageContentMode = .aspectFill, resultHandler:@escaping ((UIImage?)->Void)) -> PHImageRequestID {
        
        let ratio = CGFloat(asset.pixelWidth/asset.pixelHeight)
        let h = height ?? w/ratio
        let size = CGSize(width: w, height: h)
        let scale = UIScreen.main.scale
        let targetSize = size.applying(CGAffineTransform(scaleX: scale, y: scale))
        
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.resizeMode = .exact
        
        return imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options) { (img, info) in
            resultHandler(img)
        }
    }
}

extension PhotosManager {
    
    static func saveImage(data: Data, fileUrl: URL) -> Observable<Bool> {
        
        return Observable<Bool>.create { (observer) -> Disposable in
            
            do {
                try data.write(to: fileUrl)
            } catch {
                observer.onError(error)
            }
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetCreationRequest.creationRequestForAssetFromImage(atFileURL: fileUrl)
            }) { (isFinished, error) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(isFinished)
                }
            }
            return Disposables.create()
        }
    }
}
