//
//  BSCycleThroughCollectionCell.swift
//  blurryssky
//
//  Created by 张亚东 on 16/5/4.
//  Copyright © 2016年 doyen. All rights reserved.
//

import UIKit
import Kingfisher

class BSCycleThroughCollectionCell: UICollectionViewCell {
    
    var imageUrlString: String! {
        didSet {
            guard let url = URL(string: imageUrlString) else {
                return
            }
            imgView.kf.setImage(with: ImageResource(downloadURL: url), placeholder: placeholderImage)
        }
    }
    
    public var placeholderImage: UIImage?
    
    var image: UIImage! {
        didSet {
            imgView.image = image
        }
    }
    
    lazy var imgView: UIImageView = {
        let imgView: UIImageView = UIImageView(frame: self.bounds)
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgView.frame = bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgView.kf.cancelDownloadTask()
        imgView.image = nil
    }
}

extension BSCycleThroughCollectionCell {
    
    func setup() {
        addSubview(imgView)
    }
}
