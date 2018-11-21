//
//  PhoneAddressModel.swift
//  ben_son
//
//  Created by ZS on 2018/10/16.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper

class PhoneAddressModel: Mappable {
    
    
    var name: String?
    
    var address: String?
    
    var phone: String?
    
    var isFirst: Bool?
    
    var longitude: String?
    
    var latitude: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name                <- map["name"]
        address             <- map["address"]
        phone               <- map["tel"]
        longitude           <- map["longitude"]
        latitude            <- map["latitude"]
    }
    

    
}

class PhoneAddressViewModel {
    
    let load_request = PublishSubject<Int>()
    
    var result_singal: Observable<Bool>?
    
    var addresss = [PhoneAddressModel]()
    
    let publish_result = PublishSubject<[PhoneAddressModel]>()
    
    
    
    
    init() {
     
        result_singal = load_request.flatMapLatest({ (type) -> Observable<Bool> in
            
            return bs_provider.rx.request(BSServiceAPI.companys_list).mapJSON().map({ (json) -> Bool in
                BSLog(json)
                if let dicJson = json as? [String: Any], let dicArray = dicJson["data"] as? [[String: Any]] {
                    for dic in dicArray {
                        if let dicDetail = dic["detail"] as? [String: Any], let address = PhoneAddressModel(JSON: dicDetail) {
                            if let cityName = dic["name"] as? String{
                                address.name = cityName
                            }
                            self.addresss.append(address)
                        }
                    }
                    return true
                }
                return false
            }).catchErrorJustReturn(false).asObservable()
        })
    }
}
