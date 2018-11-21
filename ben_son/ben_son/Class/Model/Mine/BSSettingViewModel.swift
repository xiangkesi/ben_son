//
//  BSSettingViewModel.swift
//  ben_son
//
//  Created by ZS on 2018/10/12.
//  Copyright © 2018年 ZS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class BSSettingViewModel: NSObject {
    private let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first

    let publishModels = PublishSubject<[BSSeetingModel]>()
    
    let sub = PublishSubject<ChooseImage>()
    let resultImage: Observable<UIImage?>
    
    let modifySubject = PublishSubject<[String: Any]>()
    let result: Observable<Bool>?
  
     override init() {
        
        resultImage = sub.flatMapLatest { (choose) in
            return UIImagePickerController.rx.createWithParent(choose.controller) { picker in
                picker.sourceType = choose.isCamera ? .camera : .photoLibrary
                picker.allowsEditing = true
                }
                .flatMap { $0.rx.didFinishPickingMediaWithInfo }
            }
            .map { info in
                if let imageInfo = info["UIImagePickerControllerEditedImage"], let editImage = imageInfo as? UIImage {
                    return editImage
                }
                return nil
            }.catchErrorJustReturn(nil).asObservable()
        
        
        result = modifySubject.flatMapLatest({ (dic) in
            return bs_provider.rx.request(BSServiceAPI.modify_user_msg(param: dic)).mapJSON().map({ (json) -> Bool in
                
                BSLog(json)
                
                return true
            }).catchErrorJustReturn(false).asObservable()
        })
        
    }
    
    var login_user: Login_user? {
        didSet{

        }
    }
    
    lazy var models: [BSSeetingModel] = {
        let headModel = BSSeetingModel()
        headModel.name = "头像"
        headModel.type = 0
        headModel.image = head_image_placholder
        headModel.colorString = "53402F"
        headModel.headUrl = login_user?.avatar
        
        let nickModel = BSSeetingModel()
        nickModel.name = "昵称"
        nickModel.type = 1
        nickModel.describe = login_user?.username
        nickModel.colorString = "A98054"
        
        let sexModel = BSSeetingModel()
        sexModel.name = "性别"
        sexModel.type = 2
        sexModel.describe = login_user?.gender == 1 ? "男" : "女"
        sexModel.colorString = "A98054"
        
        let nameModel = BSSeetingModel()
        nameModel.name = "个性签名"
        nameModel.type = 3
        nameModel.describe = login_user?.signature
        nameModel.colorString = "53402F"
      
        
        let addressModel = BSSeetingModel()
        addressModel.name = "常用地址"
        addressModel.type = 4
        addressModel.describe = login_user?.address
        addressModel.colorString = "A98054"
        
        let certificationModel = BSSeetingModel()
        certificationModel.name = "清理缓存"
        certificationModel.type = 5
        certificationModel.describe = "100M"
        certificationModel.colorString = "53402F"
        
        let arrayModels = [headModel, nickModel, sexModel, nameModel, addressModel, certificationModel]
        
        return arrayModels
    }()
    
    
    func calculateCache(){
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        var size = 0
        for file in fileArr! {
            // 把文件名拼接到路径中
            let path = cachePath! + ("/\(file)")
            // 取出文件属性
            let floder = try! FileManager.default.attributesOfItem(atPath: path)
            // 用元组取出文件大小属性
            for (key, fileSize) in floder {
                // 累加文件大小
                if key == FileAttributeKey.size {
                    size += (fileSize as AnyObject).integerValue
                }
            }
        }
        let totalCache = Double(size) / 1024.00 / 1024.00
        let str = String(format: "%.2f", totalCache) + "M"
        models.last?.describe = str
//        publishModels.onNext(models)
    }
    
    func cleanCache() {
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        // 遍历删除
        for file in fileArr! {
            
            let path = (cachePath! as NSString).appending("/\(file)")
            
            if FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                    models.last?.describe = "0M"
                    publishModels.onNext(models)
                } catch {
                    RSProgressHUD.showSuccessOrFailureHud(titleStr: "清除失败", (kRootVc?.view)!)
                }
            }
        }
     
    }
}


class BSSeetingModel {
    
    var name: String?
    
    var type: Int = 0
    
    var describe: String?
    
    var colorString: String?
    
    var image: UIImage?
    
    var headUrl: String?
    
    
}
