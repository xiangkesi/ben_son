//
//  BSMsgCenterViewModel.swift
//  ben_son
//
//  Created by ZS on 2018/11/15.
//  Copyright © 2018 ZS. All rights reserved.
//

import UIKit
import RxSwift

class BSMsgCenterViewModel {

    var result_list: Observable<Bool>?
    let publish_load = PublishSubject<Int>()
    
    let publish_data = PublishSubject<[BSMsgCenterList]>()
    
    var msg_lists = [BSMsgCenterList]()
    
    init() {
        result_list = publish_load.flatMapLatest({ (page) -> Observable<Bool> in
            
        return bs_provider.rx.request(BSServiceAPI.notification_list).mapJSON().map({[weak self] (json) -> Bool in
                BSLog(json)
            if let jsonDic = json as? [String: Any], let dicData = jsonDic["data"] as? [[String: Any]] {
                self?.msg_lists.removeAll()
                for dic in dicData {
                    if let msg = BSMsgCenterList(JSON: dic) {
                        self?.msg_lists.append(msg)
                    }
                }
                return true
            }
                return false
            }).catchErrorJustReturn(false).asObservable()
        })
    }
    
    
}


class BSMsgDetailViewModel {
    
    var result_Detail: Observable<Bool>?
    let publish_load = PublishSubject<Int>()
    
    var detailMsg: BSMsgCenterList?
    
    init() {
        result_Detail = publish_load.flatMapLatest({ (msgId) -> Observable<Bool> in
            return bs_provider.rx.request(BSServiceAPI.notification_detail(notificationId: msgId)).mapJSON().map({ (json) -> Bool in
                BSLog(json)
                if let jsonDic = json as? [String: Any], let dicData = jsonDic["data"] as? [String: Any] {
                    if let detail = BSMsgCenterList(JSON: dicData) {
                        self.detailMsg = detail
                        return true
                    }
                }
                return false
            }).catchErrorJustReturn(false).asObservable()
        })
    }
}
