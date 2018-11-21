//
//  BSAddressListViewModel.swift
//  ben_son
//
//  Created by ZS on 2018/11/7.
//  Copyright © 2018 ZS. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper

class BSAddressListViewModel {

    let publish_loaddata = PublishSubject<Int>()
    var address_list_result: Observable<Bool>?
    
    let publishAddress = PublishSubject<[AddressList]>()
    var address_lists = [AddressList]()
    
    let delete_publish = PublishSubject<AddressList>()
    var delete_address_result: Observable<Bool>?
    
    
    
    
    init() {
        address_list_result = publish_loaddata.flatMapLatest({ (type) ->  Observable<Bool> in
            return bs_provider.rx.request(BSServiceAPI.address_list, callbackQueue: DispatchQueue.global()).mapJSON().map({ (json) -> Bool in
                if let dic = json as? [String: Any], let dicArray = dic["data"] as? [[String: Any]] {
                    self.address_lists.removeAll()
                    for dicJson in dicArray {
                        if let model = AddressList(JSON: dicJson) {
                            model.address_final = (model.region ?? "") + (model.address ?? "")
                            model.titleHeight = (model.address_final?.heightString(font: UIFont.systemFont(ofSize: 15), width: kScreenWidth - 40))!
                            model.rowHeight = model.titleHeight + 50
                            self.address_lists.append(model)
                        }
                    }
                    return true
                }
                return false
            }).catchErrorJustReturn(false).asObservable()
        })
        
        delete_address_result = delete_publish.flatMapLatest({ (address) -> Observable<Bool> in
            return bs_uploadFile_bs_provider.rx.request(BSServiceAPI.delete_address_list(addressId: address.addressId)).mapJSON().map({[weak self] (json) -> Bool in
                BSLog(json)
                if let dic = json as? [String: Any], let status = dic["status"] as? String {
                    if status == "success", let index = self?.address_lists.index(where: {$0 === address}) {
                        self?.address_lists.remove(at: index)
                        return true
                    }
                }
                return false
            }).catchErrorJustReturn(false).asObservable()
        })
    }
    
    
}

class AddressList: Mappable {
    
    var address: String?
    
    var addressId: Int = 0
    
    var name: String?
    
    var region: String?
    
    var telephone: String?
    
    var address_final: String?
    
    var titleHeight: CGFloat = 0
    
    var rowHeight: CGFloat = 0
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        address       <- map["address"]
        addressId       <- map["id"]
        name       <- map["name"]
        region       <- map["region"]
        telephone       <- map["telephone"]

    }
    
    
}
