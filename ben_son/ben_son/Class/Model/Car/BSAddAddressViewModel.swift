//
//  BSAddAddressViewModel.swift
//  ben_son
//
//  Created by ZS on 2018/11/6.
//  Copyright © 2018 ZS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BSAddAddressViewModel: NSObject {

    let publish_SentRequest = PublishSubject<BSAddAddressParam>()
    
    var result_Request: Observable<Bool>?
    
    var address: AddressList?
    
    
    override init() {
        super.init()
        result_Request = publish_SentRequest.flatMapLatest({ (param) -> Observable<Bool> in
            BSLog(param.mapToJson())
            return bs_uploadFile_bs_provider.rx.request(BSServiceAPI.add_address(param: param.mapToJson())).mapJSON().map({[weak self] (json) -> Bool in
                BSLog(json)
                if let dic = json as? [String: Any], let dataJson = dic["data"] as? [String: Any] {
                    if let model = AddressList(JSON: dataJson) {
                        model.address_final = (model.region ?? "") + (model.address ?? "")
                        model.titleHeight = (model.address_final?.heightString(font: UIFont.systemFont(ofSize: 15), width: kScreenWidth - 40))!
                        model.rowHeight = model.titleHeight + 50
                        self?.address = model
                        return true
                    }
                }
                return false
            }).catchErrorJustReturn(false).asObservable()
        })
    }
    
    
}
