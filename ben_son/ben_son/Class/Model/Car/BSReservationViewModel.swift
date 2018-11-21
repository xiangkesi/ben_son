//
//  BSReservationViewModel.swift
//  ben_son
//
//  Created by ZS on 2018/10/24.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper

class BSReservationViewModel: NSObject {

    
    var summitResult: Observable<Bool>?
    let subjectSent = PublishSubject<BSReservationParam>()
    let disposeBag = DisposeBag()
    
    var orderModel: BSOrderModel?
    
    
    override init() {
        super.init()
        summitResult = subjectSent.flatMapLatest({ (param) -> Observable<Bool> in
            return bs_uploadFile_bs_provider.rx.request(BSServiceAPI.car_online_upload(param: param.mapJsonToDic())).mapJSON().map({ (json) -> Bool in
                if let dic = json as? [String: Any], let status = dic["status"] as? String, let dicData = dic["data"] as? [String: Any]  {
                    if status == "success" {
                        if let model = BSOrderModel(JSON: dicData) {
                            model.car_model = model.model
                            self.orderModel = model
                            return true
                        }
                    }
                }
                return false
            }).catchErrorJustReturn(false).asObservable()
        })
    }
}

class BSReservationParam {
    var car_id: Int = 0  //车型id
    
    var is_exchange_color = Variable(true) //是否换颜色
    
    var removed_city: String? //取车城市
    
    var returned_city: String? // 还车城市
    
    var removed_time: String? //取车时间
    
    var returned_time: String? // 还车时间
    
    var remove_type: Int = 1 //1或者2 取车方式
    
    var removed_address: String? //送车地址 配送地址
    
    var is_application_exempt_deposit: Int = 0 //没用
    
    var days: Int = 0
    
    
    
    var name = Variable("") //姓名
    
    var telephone = Variable("") //手机号

    var address = Variable("") //联系地址
    
    var wechat_id = Variable("") //微信号
    
    var remark = Variable("") //备注

}

extension BSReservationParam {
    
    func mapJsonToDic() -> [String: Any] {
        return ["car_id": car_id,
                "is_exchange_color": is_exchange_color.value == false ? 0 : 1,
                "removed_city": removed_city!,
                "returned_city": returned_city!,
                "removed_time": removed_time!,
                "returned_time": returned_time!,
                "remove_type": remove_type,
                "removed_address": removed_address!,
                "is_application_exempt_deposit": is_application_exempt_deposit,
                "name": name.value,
                "telephone": telephone.value,
                "address": address.value,
                "wechat_id": wechat_id.value,
                "remark": remark.value,
                "days":days
                ]
    }
    
    
    func judjeEmpty() -> Bool {
        var titleStr = ""
        if car_id == 0 {
            titleStr = "请选择车辆颜色"
        }else if removed_city == nil || removed_city == "" {
            titleStr = "请选择取车城市"
        }else if returned_city == nil || returned_city == "" {
            titleStr = "请选择还车城市"
        }else if removed_time == nil  || removed_time == "" {
            titleStr = "使用时间"
        }else if returned_time == nil || returned_time == "" {
            titleStr = "使用时间"
        }else if removed_address == nil || removed_address == "" {
             titleStr = "请选择送车地址"
        }else if name.value == "" {
                titleStr = "请输入姓名"
        }else if telephone.value == "" {
                titleStr = "请输入手机号"
        }else {
            return true
        }
        RSProgressHUD.showSuccessOrFailureHud(titleStr: titleStr)
        return false
    }
}
