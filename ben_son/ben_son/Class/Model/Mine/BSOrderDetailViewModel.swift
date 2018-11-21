//
//  BSOrderDetailViewModel.swift
//  ben_son
//
//  Created by ZS on 2018/11/9.
//  Copyright © 2018 ZS. All rights reserved.
//

import UIKit
import RxSwift

class BSOrderDetailViewModel {

    var pay_type: String = "待支付"
    
    
    let publish_msgs = PublishSubject<[OrderDetailMsg]>()
    
    let publish_loadData = PublishSubject<Int>()
    var result_data: Observable<Bool>?
    
    var orderMsgs = [OrderDetailMsg]()
    
    
    var orderMsg: BSOrderModel?
    
    
    init() {
        result_data = publish_loadData.flatMapLatest({ (orderId) -> Observable<Bool> in
            return bs_provider.rx.request(BSServiceAPI.order_detail(orderId: orderId), callbackQueue: DispatchQueue.global()).mapJSON().map({[weak self] (json) -> Bool in
                BSLog(json)
                if let jsonData = json as? [String: Any], let dicJson = jsonData["data"] as? [String: Any] {
                    if let model = BSOrderModel(JSON: dicJson) {
                        self?.orderMsg = model
                        self?.maptoOrderDetailMsg()
                        return true
                    }
                }
                return false
            }).catchErrorJustReturn(false).asObservable()
        })
    }
    
    func sent_signal() {
        publish_msgs.onNext(orderMsgs)
    }
    
    func maptoOrderDetailMsg() {
        let order_amount = OrderDetailMsg()
        order_amount.order_title = "订单总金额:"
        order_amount.order_value = "¥" + (orderMsg?.amount)!
        
        let order_deposit = OrderDetailMsg()
        order_deposit.order_title = "所需订金:"
        order_deposit.order_value = "¥" + (orderMsg?.pay_price)!
        
        let order_contact = OrderDetailMsg()
        order_contact.order_title = "联系人:"
        order_contact.order_value = orderMsg?.name
        
        let order_phone = OrderDetailMsg()
        order_phone.order_title = "手机号码:"
        order_phone.order_value = orderMsg?.telephone
        
        let order_receiveway = OrderDetailMsg()
        order_receiveway.order_title = "取车方式:"
        order_receiveway.order_value = (orderMsg?.remove_type == 1 ? "到店取车" : "送车上门")
        
        let order_address = OrderDetailMsg()
        order_address.order_title = "送车地址:"
        order_address.order_value = orderMsg?.removed_address
        
        let order_number = OrderDetailMsg()
        order_number.order_title = "订单编号:"
        order_number.order_value = orderMsg?.order_number
        
        let order_time = OrderDetailMsg()
        order_time.order_title = "下单时间:"
        order_time.order_value = orderMsg?.created_at
        
        orderMsgs.append(order_amount)
        orderMsgs.append(order_deposit)
        orderMsgs.append(order_contact)
        orderMsgs.append(order_phone)
        orderMsgs.append(order_receiveway)
        orderMsgs.append(order_address)
        orderMsgs.append(order_number)
        orderMsgs.append(order_time)
        
//        0未支付  1已支付
        switch orderMsg?.order_status {
        case "unfinished":
            orderMsg?.pay_type = "待支付"
            break
        case "progress":
            orderMsg?.pay_type = "进行中"
            break
        case "finished":
            orderMsg?.pay_type = "已完成"
            break
        default:
            break
        }
        let remove_attstr = (orderMsg?.removed_address ?? "") + "\n" + (orderMsg?.removed_time ?? "")
        let return_attstr = (orderMsg?.returned_city ?? "") + "\n" + (orderMsg?.returned_time ?? "")

        orderMsg?.remove_address_attstr = remove_attstr.rich_paragraph_text(lineSpace: 8, kern: nil)
        orderMsg?.return_address_attstr = return_attstr.rich_paragraph_text(lineSpace: 8, kern: nil)
    }
    
}

class OrderDetailMsg {
    
    var order_title: String?
    
    var order_value: String?
    
    
}
