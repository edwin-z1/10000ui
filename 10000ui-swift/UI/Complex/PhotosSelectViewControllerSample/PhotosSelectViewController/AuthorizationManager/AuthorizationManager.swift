//
//  AuthorizationManager.swift
//  Kuso
//
//  Created by blurryssky on 2018/8/15.
//  Copyright © 2018年 momo. All rights reserved.
//

import Foundation
import Photos
import MediaPlayer

import RxSwift
import RxCocoa

enum AlertPermission {
    case camera
    case microphone
    case photoLibrary
    case mediaLibrary
    
    var title: String {
        switch self {
        case .camera:
            return "开启摄像头才能使用拍照和录制视频功能"
        case .microphone:
            return "开启麦克风才能使用配音功能"
        case .photoLibrary:
            return "请允许访问相册上传或存储您的作品"
        case .mediaLibrary:
            return "请允许访问音乐库用本地音乐配音"
        }
    }
    
    var message: String {
        switch self {
        case .camera:
            return "已禁用摄像头权限，请在设置页面开启"
        case .microphone:
            return "已禁用麦克风权限，请在设置页面开启"
        case .photoLibrary:
            return "已禁用相册权限，请在设置页面开启"
        case .mediaLibrary:
            return "已禁用音乐库权限，请在设置页面开启"
        }
    }
}

enum PermissionError: Error {
    case notGranted
}

class AuthorizationManager {
    
    static func requestMediaLibraryAuthorization() -> Observable<Bool> {
        
        return Observable<Bool>.create{ (observer) -> Disposable in
            MPMediaLibrary.requestAuthorization({ (status) in
                switch status {
                case .authorized:
                    observer.onNext(true)
                case .denied: fallthrough
                case .notDetermined: fallthrough
                case .restricted:
                    observer.onNext(false)
                }
            })
            return Disposables.create()
            }
            .observeOn(MainScheduler.asyncInstance)
            .do(onNext: { (isGranted) in
                if !isGranted {
                    self.presentAlert(alertPermission: .mediaLibrary)
                }
            })
    }
    
    static func requestPhotoLibraryAuthorization() -> Observable<Bool> {
        
        return Observable<Bool>.create{ (observer) -> Disposable in
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status {
                case .authorized:
                    observer.onNext(true)
                case .denied: fallthrough
                case .notDetermined: fallthrough
                case .restricted:
                    observer.onNext(false)
                }
            }
            return Disposables.create()
            }
            .observeOn(MainScheduler.asyncInstance)
            .do(onNext: { (isGranted) in
                if !isGranted {
                    self.presentAlert(alertPermission: .photoLibrary)
                }
            })
    }
    
    static func requestCaptureDeviceAuthorization(type: AVMediaType) -> Observable<Bool> {
        
        return Observable.create { (observer) -> Disposable in
            switch AVCaptureDevice.authorizationStatus(for: type) {
            case .authorized:
                observer.onNext(true)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: type) { isGranted in
                    observer.onNext(isGranted)
                }
            case .denied: fallthrough
            case .restricted:
                observer.onNext(false)
            }
            return Disposables.create()
            }
            .observeOn(MainScheduler.asyncInstance)
            .do(onNext: { (isGranted) in
                if !isGranted {
                    if type == .audio {
                        self.presentAlert(alertPermission: .microphone)
                    } else if type == .video {
                        self.presentAlert(alertPermission: .camera)
                    }
                }
            })
    }
}

private extension AuthorizationManager {
    
    static func presentAlert(alertPermission: AlertPermission) {
        let alert = UIAlertController(title: alertPermission.title, message: alertPermission.message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let goSetting = UIAlertAction(title: "去设置", style: .default) { (alertAction) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alert.addAction(cancel)
        alert.addAction(goSetting)
        
        let rootVC = UIApplication.shared.delegate?.window??.rootViewController
        var targetVC = rootVC!.bs.topPresentedVC
        if targetVC.isBeingDismissed,
            let presenting = targetVC.presentingViewController {
            targetVC = presenting
        }
        targetVC.present(alert, animated: true, completion: nil)
    }
}
