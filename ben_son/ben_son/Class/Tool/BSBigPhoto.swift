//
//  BSBigPhoto.swift
//  ben_son
//
//  Created by ZS on 2018/10/30.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class BSBigPhoto {

    class func showBigPhoto(vc: UIViewController, images: [String], currentIndex: Int) {
        var iamgePhotos = [SKPhoto]()
        for url in images {
            let photo = SKPhoto.photoWithImageURL(url)
            photo.shouldCachePhotoURLImage = false
            iamgePhotos.append(photo)
        }
        let browser = SKPhotoBrowser(photos: iamgePhotos)
//        browser.popupShare(includeCaption: false)
        browser.initializePageIndex(currentIndex)
        vc.present(browser, animated: false, completion: nil)
        
    }
}
