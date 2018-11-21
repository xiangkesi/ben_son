//
//  BSHostingViewModel.swift
//  ben_son
//
//  Created by ZS on 2018/10/22.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BSHostingViewModel: NSObject {

    var summitResult: Observable<Bool>
    let subjectSent = PublishSubject<BSHostingModel>()
    let disposeBag = DisposeBag()
    
    let sub = PublishSubject<ChooseImage>()
    let resultImage: Observable<UIImage?>
    
    override init() {
        summitResult = subjectSent.flatMapLatest({ (hosting) -> Observable<Bool> in

            if !hosting.judjeEmpty() {
                return Observable.just(false)
            }
            return bs_uploadFile_bs_provider.rx.request(BSServiceAPI.benson_hosting(param: hosting.mapJsonToDic(), imageDatas: hosting.mapToArray())).mapJSON().map({ (json) -> Bool in
                BSLog(json)
                if let data = json as? [String: Any], let status = data["status"] as? String {
                    if status == "success" {
                        return true
                    }
                }
                return false
            }).catchErrorJustReturn(false).asObservable()
        })
        
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
    }
    
    deinit {
        BSLog("本森托管销毁了吗")
    }
    
    
}

class BSHostingModel {
    
    var price = Variable("")
    
    var use_type: String?
    
    var remark = Variable("")
    
    var name = Variable("")
    
    var age: Int = 35
    
    var contact = Variable("")
    
    var brand = Variable("")
    
    var model = Variable("")
    
    let color = "FFFFFF"
    
    var year: String?
    
    var attribution: String?
    
    var img_car: Data?
    
    var img_driving_license: Data?
    
    var img_traffic_insurance: Data?
    
    var img_commercial_insurance: Data?
}

extension BSHostingModel {
    
    func mapJsonToDic() -> [String: Any] {
        return ["price":price.value,
                "use_type":use_type!,
                "remark": remark.value,
                "name": name.value,
                "age":age,
                "contact":contact.value,
                "brand": brand.value,
                "model": model.value,
                "color":color,
                "year": year!,
                "attribution": attribution!]
    }
    
    func mapToArray() -> [Data] {
        
        return [img_car!, img_driving_license!, img_traffic_insurance!, img_commercial_insurance!]
    }
    
    func judjeEmpty() -> Bool {
        var titleStr = ""
        if name.value == "" {
            titleStr = "请输入姓名"
        }else if contact.value == "" {
            titleStr = "请输入联系方式"
        }else if brand.value == "" {
            titleStr = "请输入车辆品牌"
        }else if model.value == "" {
            titleStr = "请输入车辆型号"
        }else if year == nil || year == "" {
            titleStr = "请选择购车年份"
        }else if attribution == nil || attribution == "" {
            titleStr = "请选择车辆归属地"
        }else if img_car == nil {
            titleStr = "请拍摄车辆照片"
        }else if img_driving_license == nil {
            titleStr = "请拍摄驾驶证照片"
        }else if img_traffic_insurance == nil {
            titleStr = "请拍摄交强险证照片"
        }else if img_commercial_insurance == nil {
            titleStr = "请拍摄商业险证照片"
        }else if price.value == ""{
            titleStr = "请输入期望价格"
        }else if use_type == nil || use_type == "" {
             titleStr = "请选择使用方式"
        }else {
            return true
        }
        RSProgressHUD.showSuccessOrFailureHud(titleStr: titleStr)
        return false
    }
}

class ChooseImage {
    
    weak var controller: UIViewController?
    
    var isCamera: Bool = false
    
    var btn_type: Int = 0
    
    
    
}
