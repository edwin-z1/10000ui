//
//  PhotosSelectCollectionCell.swift
//  Kuso
//
//  Created by blurryssky on 2018/7/24.
//  Copyright © 2018年 blurryssky. All rights reserved.
//

import UIKit
import Photos

import RxSwift

class PhotosSelectCollectionCell: UICollectionViewCell {
    
    var photoSelectItem: PhotosSelectItem! {
        didSet {
            update()
        }
    }
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var selectImgView: UIImageView!
    @IBOutlet weak var selectIndexLabel: UILabel!
    @IBOutlet weak var videoCameraImgView: UIImageView!
    @IBOutlet weak var videoDurationLabel: UILabel!
    @IBOutlet weak var gifLabel: UILabel!
    @IBOutlet weak var translucentView: UIView!
    
    fileprivate var reuseBag = DisposeBag()
    
    fileprivate var requestId: PHImageRequestID?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectIndexLabel.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        selectIndexLabel.layer.borderWidth = 1
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reuseBag = DisposeBag()
        translucentView.isHidden = true
        selectIndexLabel.isHidden = true
        selectImgView.isHidden = true
        videoCameraImgView.isHidden = true
        videoDurationLabel.isHidden = true
        gifLabel.isHidden = true
        
        if let rid = requestId {
            PhotosManager.imageManager.cancelImageRequest(rid)
        }
        imgView.image = nil
    }
}

extension PhotosSelectCollectionCell {
    
    func update() {
        
        if photoSelectItem.isCamera {
            
            imgView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.27)
            imgView.contentMode = .center
            imgView.image = #imageLiteral(resourceName: "ps_camera")
            
        } else {
            
            imgView.backgroundColor = nil
            imgView.contentMode = .scaleAspectFill
            
            updateImg()
            updateItem()
            
            let asset = photoSelectItem.asset!
            switch asset.mediaType {
            case .video:
                videoCameraImgView.isHidden = false
                videoDurationLabel.text = asset.duration.bs.formattedColonString
                videoDurationLabel.isHidden = false
                
                if photoSelectItem.mutliSelectionType == .mix {
                    selectImgView.isHidden = false
                }
                
            case .image:
                selectImgView.isHidden = false
                
                if asset.mediaSubtypes.rawValue == 32 {
                    gifLabel.isHidden = false
                }
            default:
                break
            }
        }
    }
    
    func updateImg() {
        
        let asset = photoSelectItem.asset!
        requestId = PhotosManager.reqeustStillImage(for: asset, width: photoSelectItem.cellSize.width, height: photoSelectItem.cellSize.height) { [weak self] img in
            guard let `self` = self, let img = img, asset == self.photoSelectItem.asset else { return }
            self.imgView.image = img
        }
    }
    
    func updateItem() {
        
        photoSelectItem.selectIndexVariable.asDriver()
            .do(onNext: { [unowned self] (index) in
                if let _ = index {
                    self.showSelectIndexLabel()
                } else {
                    self.selectIndexLabel.isHidden = true
                }
            })
            .filter{ $0 != nil }
            .map { "\($0!)" }
            .drive(selectIndexLabel.rx.text)
            .disposed(by: reuseBag)
        
        photoSelectItem.isShowMaskVariable.asDriver()
            .distinctUntilChanged()
            .map { !$0 }
            .drive(translucentView.rx.isHidden)
            .disposed(by: reuseBag)
        
    }
    
    func showSelectIndexLabel() {
        guard selectIndexLabel.isHidden else {
            return
        }
        selectIndexLabel.isHidden = false
        selectIndexLabel.transform = .init(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.5, options: .curveEaseInOut, animations: {
            self.selectIndexLabel.transform = .identity
        }, completion: nil)
    }
}
