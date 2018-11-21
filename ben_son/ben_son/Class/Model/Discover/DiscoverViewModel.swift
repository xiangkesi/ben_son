//
//  DiscoverViewModel.swift
//  ben_son
//
//  Created by ZS on 2018/10/23.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift

class DiscoverViewModel: NSObject {

    var result: Observable<DiscoverModel?>?
    var loadData = PublishSubject<Int>()
    let disposeBag = DisposeBag()
    
    var customeLists = [CustomerListModel]()
    var activeLists = [DiscoverNewActive]()
    
    var msg: DicoverMsgModel?
    
    
    var result_user_msg: Observable<Bool>?
    var load_mine_user = PublishSubject<Int>()
    var login_user: Login_user?
    
    
    override init() {
        super.init()
        result = loadData.flatMapLatest({ (type) -> Observable<DiscoverModel?> in
            return bs_provider.rx.request(BSServiceAPI.dicover_msg).mapJSON().map({ (json) -> DiscoverModel? in
                BSLog(json)
                if let dic = json as? [String : Any], let data = dic["data"] as? [String: Any] {
                    if let model = DiscoverModel(JSON: data) {
                    return model
                    }
                }
                return nil
            }).catchErrorJustReturn(nil).asObservable()
        })
        
        result_user_msg = load_mine_user.flatMapLatest({ (page) -> Observable<Bool> in
            return bs_provider.rx.request(BSServiceAPI.mine_msg).mapJSON().map({ (json) -> Bool in
                if let dic = json as? [String: Any], let dicJson = dic["data"] as? [String: Any] {
                    if let user_model = Login_user(JSON: dicJson) {
                        self.login_user = user_model
                        return true
                    }
                }
                return false
            }).catchErrorJustReturn(false).asObservable()
        })
        
    }
}
