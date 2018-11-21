//
//  BSChoosePayViewModel.swift
//  ben_son
//
//  Created by ZS on 2018/10/29.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift

class BSChoosePayViewModel: NSObject {
    
    var summitResult: Observable<Bool>?
    let subjectSent = PublishSubject<PayParam>()
    let disposeBag = DisposeBag()
    
    
    let publishPay = PublishSubject<[BSChoosePayModel]>()

    var pay_alipay: String?
    
    var param_pay = PayParam()
    
    
    var wechatPay: WhchatPayModel?
    override init() {
        super.init()
        summitResult = subjectSent.flatMapLatest({ (param) -> Observable<Bool> in
            BSLog(param.mapToDic())
            return bs_uploadFile_bs_provider.rx.request(BSServiceAPI.generate_order(param: param.mapToDic())).mapJSON().map({[weak self] (json) -> Bool in
                BSLog(json)
                if param.driver == "alipay" {
                    if let dic = json as? [String: Any], let payAlipay = dic["data"] as? String {
                        self?.pay_alipay = payAlipay
                        return true
                    }
                    return false
                }else{
                    if let dicJson = json as? [String: Any], let dic = dicJson["data"] as? [String: Any] {
                        if let model = WhchatPayModel(JSON: dic) {
                            self?.wechatPay = model
                            return true
                        }
                    }
                    return false
                }
            }).catchErrorJustReturn(false).asObservable()
        })
    }
    
    
    func selectedCell(item: BSChoosePayModel) {
        param_pay.driver = item.pay_type!
        for model in pays {
            model.isSelected = false
            if model === item {
                model.isSelected = true
            }
        }
        publishPay.onNext(pays)
    }

    
    lazy var pays: [BSChoosePayModel] = {
        let aplipayModel = BSChoosePayModel()
        aplipayModel.imageName = "pay_alipay"
        aplipayModel.title = "支付宝"
        aplipayModel.isSelected = true
        aplipayModel.pay_type = "alipay"
        aplipayModel.gateway = "app"
        
        let wechatModel = BSChoosePayModel()
        wechatModel.imageName = "pay_wechat"
        wechatModel.title = "微信"
        wechatModel.isSelected = false
        wechatModel.pay_type = "wechat"
        wechatModel.gateway = "app"
        return [aplipayModel, wechatModel]
    }()
    
}

class BSChoosePayModel {
    var imageName: String?
    
    var title: String?
    
    var isSelected: Bool = false
    
    var pay_type: String?
    
    var gateway: String?
    
    
}

class PayParam {
    var orderId: Int = 0
    
    var driver: String = "alipay"
    
    var gateway: String = "app"

}

extension PayParam {
    
    func mapToDic() -> [String: Any] {
        
        return ["order_id": orderId,
                "driver": driver,
                "gateway": gateway]
    }
}
