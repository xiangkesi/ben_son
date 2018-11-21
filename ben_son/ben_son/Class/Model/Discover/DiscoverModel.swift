//
//  DiscoverModel.swift
//  ben_son
//
//  Created by ZS on 2018/10/23.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import ObjectMapper

class DiscoverModel: Mappable {
    
    var customerLists: [CustomerListModel]?
    var activeLists: [DiscoverNewActive]?
    
    var msgModel: DicoverMsgModel?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        customerLists        <- map["customer"]
        activeLists          <- map["news"]
        msgModel             <- map["member"]
    }
}

class DicoverMsgModel: Mappable {
    
    var headIcon: String?
    
    var user_type: Int = 0
    
    
    
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        headIcon        <- map["avatar"]
        user_type        <- map["level"]

    }
}

class CustomerListModel: Mappable {
    
    var customerId: Int = 0
    
    var customerPhoto: String?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        customerId     <- map["nid"]
        customerPhoto     <- map["image"]

    }
}

class DiscoverNewActive: Mappable {
    
    var activePhoto: String?
    
    var activeTitle: String?
    
    var activeId: Int = 0
    
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        activePhoto     <- map["image"]
        activeTitle     <- map["title"]
        activeId     <- map["id"]

    }
}
