//
//  BSOrderListViewModel.swift
//  ben_son
//
//  Created by ZS on 2018/10/29.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift

class BSOrderListViewModel: NSObject {

    var summitResult: Observable<Bool>?
    let subjectSent = PublishSubject<String>()
    let disposeBag = DisposeBag()
    
    var order_lists = [BSOrderModel]()
    
    let result_orders = PublishSubject<[BSOrderModel]>()
    
    
    override init() {
        super.init()
        
        summitResult = subjectSent.flatMapLatest({ (status) -> Observable<Bool> in
            return bs_uploadFile_bs_provider.rx.request(BSServiceAPI.order_list(status: status)).mapJSON().map({[weak self] (json) -> Bool in
                BSLog(json)
                self?.order_lists.removeAll()
                if let dic = json as? [String: Any], let dicData = dic["data"] as? [[String: Any]] {
                    for dicJson in dicData {
                        if let order = BSOrderModel(JSON: dicJson) {
                            self?._layout(order: order)
                            self?.order_lists.append(order)
                        }
                    }
                    return true
                }
                return false
            }).catchErrorJustReturn(false).asObservable()
        })
    }
    
    func _layout(order: BSOrderModel) {
        switch order.order_status {
        case "unfinished":
            order.pay_type = "待支付"
            break
        case "progress":
            order.pay_type = "进行中"
            break
        case "finished":
            order.pay_type = "已完成"
            break
        default:
            break
        }
    }
}
