//
//  AlbumsSelectViewController.swift
//  Kuso
//
//  Created by blurryssky on 2018/8/1.
//  Copyright © 2018年 momo. All rights reserved.
//

import UIKit
import Photos

import RxSwift
import RxCocoa

class AlbumsSelectViewController: UIViewController {
    
    var albumDidSelectClosure: ((PHAssetCollection) -> Void)?
    var fetchType: PhotosFetchType = .all
    
    @IBOutlet weak var closeBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
}

private extension AlbumsSelectViewController {
    
    func setup() {
        setupCloseBarButtonItem()
        setupTableView()
    }
    
    func setupCloseBarButtonItem() {
        closeBarButtonItem.rx.tap
            .subscribe(onNext: { [unowned self] (_) in
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: bag)
    }
    
    func setupTableView() {
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        PhotosManager.fetchAlbums(fetchType: fetchType)
            .bind(to: tableView.rx.items(cellIdentifier: AlbumsSelectTableCell.bs.string, cellType: AlbumsSelectTableCell.self))  { [weak self] (idx, assetCollection, cell) in
                guard let `self` = self else { return }
                cell.fetchType = self.fetchType
                cell.assetCollection = assetCollection
            }
            .disposed(by: bag)
        
        tableView.rx.modelSelected(PHAssetCollection.self)
            .subscribe(onNext: { [unowned self] (assetCollection) in
                self.albumDidSelectClosure?(assetCollection)
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: bag)
    }
}
