//
//  PhotosSelectViewController.swift
//  Kuso
//
//  Created by blurryssky on 2018/7/24.
//  Copyright © 2018年 blurryssky. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos

import RxSwift
import RxCocoa

enum PhotosMultiSelectionType {
    case image
    case mix
}

class PhotosSelectViewController: UIViewController {
    
    var photosDidSelectClosure: (([PHAsset]) -> Void)?
    var fetchType: PhotosFetchType = .all
    var limitImageCount = 9
    var mutliSelectionType: PhotosMultiSelectionType = .mix

    @IBOutlet weak var closeBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    
    fileprivate var itemsVariable: Variable<[PhotosSelectItem]> = Variable([])
    fileprivate var selectedAlbumVariable: Variable<PHAssetCollection?> = Variable(nil)
    fileprivate var selectedItemsVariable: Variable<[PhotosSelectItem]> = Variable([])

    fileprivate let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
}

private extension PhotosSelectViewController {
    
    func setup() {
        setupCloseBarButtonItem()
        setupTitleButton()
        setupCollectionView()
        setupDoneBarButtonItem()

        AuthorizationManager.requestPhotoLibraryAuthorization()
            .filter{ $0 }
            .subscribe(onNext: { [unowned self] _ in
                self.updatePhotosAssets()
            })
            .disposed(by: bag)
    }
    
    func setupCloseBarButtonItem() {
        closeBarButtonItem.rx.tap
            .subscribe(onNext: { [unowned self] (_) in
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: bag)
    }
    
    func setupTitleButton() {
        
        titleButton.rx.tap
            .subscribe(onNext: { [unowned self] (_) in
                let albumsSelectVC = AlbumsSelectViewController.bs.instantiateFromStoryboard(name: "PhotosSelectViewController")
                albumsSelectVC.fetchType = self.fetchType
                let navi = UINavigationController(rootViewController: albumsSelectVC)
                self.present(navi, animated: true, completion: nil)
                
                albumsSelectVC.albumDidSelectClosure = { [unowned self] album in
                    self.selectedAlbumVariable.value = album
                }
            })
            .disposed(by: bag)
        
        selectedAlbumVariable.asObservable()
            .filter { $0 != nil }
            .subscribe(onNext: { [unowned self] (album) in
                self.titleButton.setTitle(album!.localizedTitle, for: .normal)
                self.selectedItemsVariable.value = []
                self.updatePhotosAssets()
            })
            .disposed(by: bag)
    }
    
    func setupCollectionView() {
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let itemWidth = collectionView.bs.caculateItemWidth(hCount: 3)
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        itemsVariable.asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: PhotosSelectCollectionCell.bs.string, cellType: PhotosSelectCollectionCell.self))  { (idx, photoSelectItem, cell) in
                cell.photoSelectItem = photoSelectItem
            }
            .disposed(by: bag)
        
        collectionView.rx.modelSelected(PhotosSelectItem.self)
            .subscribe(onNext: { [unowned self] (photoSelectItem) in
                if photoSelectItem.isCamera {
                    
                    self.presentCamera()
                    
                } else {
                    
                    guard !photoSelectItem.isShowMaskVariable.value else {
                        return
                    }
                    
                    let asset = photoSelectItem.asset!
                    let isLocallyAvailable = PHAssetResource.assetResources(for: asset).first?.value(forKey: "locallyAvailable") as? Int
                    guard isLocallyAvailable == 1 else {
                        print("isLocallyAvailable = 0, it's icloud file")
                        return
                    }

                    switch self.mutliSelectionType {
                    case .image:
                        switch asset.mediaType {
                        case .video:
                            self.photosDidSelectClosure?([asset])
                        case .image:
                            self.handleSelectedItem(photoSelectItem)
                        default:
                            break
                        }
                    case .mix:
                        self.handleSelectedItem(photoSelectItem)
                    }
                }
            })
            .disposed(by: bag)
    }
    
    func updatePhotosAssets() {
        PhotosManager.fetchPhotos(album: selectedAlbumVariable.value, fetchType: fetchType)
            .subscribe(onNext: { [weak self] (assets) in
                guard let `self` = self else { return }
                let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
                var items = [PhotosSelectItem(isCamera: true)]
                items += assets.map { PhotosSelectItem(asset: $0, cellSize: layout.itemSize) }
                items.forEach{ [unowned self] item in
                    item.mutliSelectionType = self.mutliSelectionType
                }
                self.itemsVariable.value = items
            })
            .disposed(by: bag)
    }
    
    func setupDoneBarButtonItem() {
        
        selectedItemsVariable.asObservable()
            .map { $0.count != 0 }
            .bind(to: doneBarButtonItem.rx.isEnabled)
            .disposed(by: bag)
        
        doneBarButtonItem.rx.tap
            .subscribe(onNext: { [unowned self] (_) in
                let assets = self.selectedItemsVariable.value.map {
                    $0.asset!
                }
                self.photosDidSelectClosure?(assets)
            })
            .disposed(by: bag)
    }
    
    func presentCamera() {
        
        _ = AuthorizationManager.requestCaptureDeviceAuthorization(type: .video)
            .filter{ $0 }
            .flatMap{ _ in AuthorizationManager.requestCaptureDeviceAuthorization(type: .audio) }
            .filter{ $0 }
            .filter{ _ in UIImagePickerController.isSourceTypeAvailable(.camera) }
            .subscribe(onNext: { [unowned self] (_) in
                
                var mediaTypes: [String] = []
                switch self.fetchType {
                case .video:
                    mediaTypes += [String(kUTTypeMovie)]
                case .image:
                    mediaTypes += [String(kUTTypeImage)]
                case .all:
                    mediaTypes = [String(kUTTypeImage), String(kUTTypeMovie)]
                }
                
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .camera
                imagePicker.mediaTypes = mediaTypes
                imagePicker.videoQuality = .typeIFrame1280x720
                imagePicker.delegate = self
                self.present(imagePicker, animated: true, completion: nil)
            })
    }
}

extension PhotosSelectViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let type = info[.mediaType] as? String else {
            return
        }
        
        var requestIdentifier: String?
        if type == String(kUTTypeImage),
            let img = info[.originalImage] as? UIImage {
            
            PHPhotoLibrary.shared().performChanges({
                requestIdentifier = PHAssetCreationRequest.creationRequestForAsset(from: img).placeholderForCreatedAsset?.localIdentifier
            }) { [weak self] (isFinished, error) in
                guard let `self` = self else { return }
                if let error = error {
                    self.handleCreationRequest(error: error)
                } else if isFinished {
                    self.handleCreationRequest(requestIdentifier: requestIdentifier)
                }
            }
            
        } else if type == String(kUTTypeMovie),
            let fileUrl = info[.mediaURL] as? URL {
            
            PHPhotoLibrary.shared().performChanges({
                requestIdentifier = PHAssetCreationRequest.creationRequestForAssetFromVideo(atFileURL: fileUrl)?.placeholderForCreatedAsset?.localIdentifier
            }) { [weak self] (isFinished, error) in
                guard let `self` = self else { return }
                if let error = error {
                    self.handleCreationRequest(error: error)
                } else if isFinished {
                    self.handleCreationRequest(requestIdentifier: requestIdentifier)
                }
            }
        }
    }
    
    func handleCreationRequest(requestIdentifier: String? = nil, error: Error? = nil) {
        
        if let error = error {
            
            print("\(#function) error :\(error)")
            
        } else {
            
            guard let localIdentifier = requestIdentifier,
                let phAsset = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil).firstObject else {
                    return
            }
            DispatchQueue.main.async {
                self.photosDidSelectClosure?([phAsset])
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

private extension PhotosSelectViewController {
    
    func handleSelectedItem(_ item: PhotosSelectItem) {
        // 选中删除
        if let idx = selectedItemsVariable.value.index(of: item) {
            
            // 如果删除前已选到最大数量, 取消图片遮罩
            if selectedItemsVariable.value.count == limitImageCount {
                
                itemsVariable.value.forEach {
                    switch self.mutliSelectionType {
                    case .image:
                        if $0.asset?.mediaType == .video {
                            $0.isShowMaskVariable.value = true
                        } else {
                            $0.isShowMaskVariable.value = false
                        }
                    case .mix:
                        $0.isShowMaskVariable.value = false
                    }
                }
            }
            
            // 清除cell上的index标号
            item.selectIndexVariable.value = nil
            selectedItemsVariable.value.remove(at: idx)
            
            // 修改删除后其他选中照片index
            selectedItemsVariable.value.forEach {
                if let idx = self.selectedItemsVariable.value.index(of: $0) {
                    $0.selectIndexVariable.value = idx + 1
                }
            }
            
            // 如果删除后没有图片了, 取消所有遮罩
            if selectedItemsVariable.value.count == 0 {
                itemsVariable.value.forEach {
                    $0.isShowMaskVariable.value = false
                }
            }
            
            // 选中添加
        } else if selectedItemsVariable.value.count < limitImageCount {
            
            selectedItemsVariable.value.append(item)
            item.selectIndexVariable.value = selectedItemsVariable.value.count
            
            // 给视频加遮罩
            if case .image = mutliSelectionType {
                itemsVariable.value.forEach {
                    if $0.asset?.mediaType == .video {
                        $0.isShowMaskVariable.value = true
                    }
                }
            }
            
            // 如果到最大限制, 给除了选中外的其他item加遮罩
            if selectedItemsVariable.value.count == limitImageCount {
                itemsVariable.value.forEach {
                    if !self.selectedItemsVariable.value.contains($0) {
                        $0.isShowMaskVariable.value = true
                    }
                }
            }
        }
        
    }
}
