//
//  ZSAssetModel.swift
//  ben_son
//
//  Created by ZS on 2018/9/7.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import PhotosUI

enum ZSAssetModelMediaType: Int {
    case photo = 0
    case livePhoto
    case photoGif
    case video
    case audio
}
class ZSAssetModel {

    var asset: PHAsset?
    
    var isSelected: Bool = false
    
    var type: ZSAssetModelMediaType = ZSAssetModelMediaType.photo
    
    var timeLength: String?
    
    var cacheImage: UIImage?
    
    
    init(asset: PHAsset, type: ZSAssetModelMediaType, timeLength: String?) {
        
    }
}

class ZSAlbumModel {
    
    var name: String?
    
    var count: Int = 0
    
    var result: PHFetchResult<PHAsset>?
    
    var isCameraRoll: Bool = false
    
    
    func setResult(resultP: PHFetchResult<PHAsset>, needFetchAssets: Bool) {
        result = resultP
        if needFetchAssets {
            
        }
    }
}
