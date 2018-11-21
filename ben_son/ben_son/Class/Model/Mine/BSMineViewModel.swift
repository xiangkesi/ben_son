//
//  BSMineViewModel.swift
//  ben_son
//
//  Created by ZS on 2018/9/12.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift

class BSMineViewModel {
    
    var result: Observable<Bool>?
    var loadData = PublishSubject<Int>()
    let disposeBag = DisposeBag()
    
    var login_user: Login_user?
    

    init() {
        result = loadData.flatMapLatest({ (page) -> Observable<Bool> in
            return bs_provider.rx.request(BSServiceAPI.mine_msg).mapJSON().map({ (json) -> Bool in
                BSLog(json)
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
    
    lazy var dataSource: [[[String : String]]] = {
        let dataSourceFirst = [["title":"本森商城","type":"1"],["title":"我的收藏","type":"2"],["title":"分享应用","type":"3"],["title":"关于我们","type":"4"],["title":"联系我们","type":"5"]]
        let dataSourceSecond = [["title":"意见反馈","type":"6"],["title":"设置","type":"7"]]
        let arrayDic = [dataSourceFirst,dataSourceSecond]
        return arrayDic
    }()

}

class User {
    var headUrl: String = ""
    
    var signature: String = "这家伙很懒,什么也没有留下"
    
    var nickName: String = "未登录"
    
    var orderCount: Int = 0
    
    
    
}
