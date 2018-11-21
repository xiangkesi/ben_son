//
//  ZSImageManager.swift
//  ben_son
//
//  Created by ZS on 2018/9/7.
//  Copyright © 2018年 ZS. All rights reserved.
//

import Foundation
import PhotosUI

class ZSImageManager {
    
    static let manager = ZSImageManager()
    
    func getCamerRollAlbum(allowPickingVideo: Bool, allowPickingImage: Bool, needFetchAssets: Bool, completion:@escaping (_ assetModels: ZSAlbumModel) -> ()) {
        let option = PHFetchOptions.init()
        //允许选择照片
        if allowPickingImage {
            option.predicate = NSPredicate.init(format: "mediaType == " + String(PHAssetMediaType.image.rawValue))
        }
//        //允许选择视频
        if allowPickingVideo {
            option.predicate = NSPredicate.init(format: "mediaType == " + String(PHAssetMediaType.video.rawValue))
        }
       //排序
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        //PHAssetCollection 数组
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: nil)
        
        smartAlbums.enumerateObjects { (collection, count, nil) in
            // 目前已知8.0.0 ~ 8.0.2系统，拍照后的图片会保存在最近添加中,这个是8.0.2之后的
            if collection.isKind(of: PHAssetCollection.self) && collection.estimatedAssetCount > 0 && collection.assetCollectionSubtype == PHAssetCollectionSubtype.smartAlbumUserLibrary{
                let fetchResult = PHAsset.fetchAssets(in: collection, options: option)
                let albumModel = self.modelWithResult(fetchResult: fetchResult, name: collection.localizedTitle ?? "", isCameraRoll: true, needFetchAssets: needFetchAssets)
                self.getAssetsFromFetchResult(fetchResult: fetchResult, allowPickingVideo: true, allowPickingImage: true, completion: { (model) in
                    
                })
                completion(albumModel)
            }

        }
    }
    
    private func modelWithResult(fetchResult: PHFetchResult<PHAsset>, name: String, isCameraRoll: Bool, needFetchAssets: Bool) -> ZSAlbumModel {
        let model = ZSAlbumModel.init()
        model.setResult(resultP: fetchResult, needFetchAssets: needFetchAssets)
        model.name = name
        model.isCameraRoll = isCameraRoll
        model.count = fetchResult.count
        return model
    }
    
    
    //获取照片数组
    func getAssetsFromFetchResult(fetchResult: PHFetchResult<PHAsset>, allowPickingVideo: Bool, allowPickingImage: Bool, completion:(_ assetModels: [ZSAssetModel]) -> ()) {
        
//        var photoArr = [ZSAssetModel]()
        fetchResult.enumerateObjects { (asset, count, nil) in
            print(asset)
        }
        
    }
    
    private func assetModel(asset: PHAsset, allowPickingVideo: Bool, allowPickingImage: Bool) -> ZSAssetModel? {
//        let type = getAssetType(asset: asset)
        
//        let timeLength = (type == ZSAssetModelMediaType.video) ? String(asset.duration) : ""
        
        
        
        
        return nil
    }
    
    
    private func getAssetType(asset: PHAsset) -> ZSAssetModelMediaType {
        
        var type = ZSAssetModelMediaType.photo
        switch asset.mediaType {
        case PHAssetMediaType.video:
            type = ZSAssetModelMediaType.video
        case PHAssetMediaType.audio:
            type = ZSAssetModelMediaType.audio
        case PHAssetMediaType.image:
            type = ZSAssetModelMediaType.photo
        default:
            type = ZSAssetModelMediaType.photo
        }
        if let asseting = asset.value(forKey: "filename"), let saa = asseting as? String {
            if saa == "GIF"{
                type = ZSAssetModelMediaType.photoGif
            }
        }
        return type
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
