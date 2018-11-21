//
//  BSFlyerViewModel.swift
//  ben_son
//
//  Created by ZS on 2018/11/15.
//  Copyright © 2018 ZS. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper

class BSFlyerViewModel {

    let publish_loadData = PublishSubject<Int>()
    var result_json: Observable<Bool>?
    
    let result_flays = PublishSubject<[BSFlyerListModel]>()
    
    var flyer_lists = [BSFlyerListModel]()
    
    
    init() {
        result_json = publish_loadData.flatMapLatest({ (type) -> Observable<Bool> in
            return bs_provider.rx.request(BSServiceAPI.scores_list).mapJSON().map({[weak self] (json) -> Bool in
                if let jsonDic = json as? [String: Any], let jsonDatas = jsonDic["data"] as? [[String: Any]]{
                    for dic in jsonDatas {
                        if let flay = BSFlyerListModel(JSON: dic) {
                            self?.flyer_lists.append(flay)
                        }
                    }
                    return true
                }
                return false
            }).catchErrorJustReturn(false).asObservable()
        })
    }
    
}

class BSFlyerListModel: Mappable {
    
    var created_at: String?
    
    var money: Int = 0
    
    var type: Int = 0
    
    var remark: String?
    
    
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        created_at           <- map["created_at"]
        money                <- map["money"]
        type                 <- map["type"]
        remark               <- map["remark"]

    }
    
    
}
