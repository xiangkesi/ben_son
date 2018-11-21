//
//  BSMsgCenterList.swift
//  ben_son
//
//  Created by ZS on 2018/11/15.
//  Copyright © 2018 ZS. All rights reserved.
//

import UIKit
import ObjectMapper

class BSMsgCenterList: Mappable {
    
    var content: String?
    
    var msgId: Int = 0
    
    var is_read: Int = 0
    
    var title: String?
    
    var created_at: String?
    
    
    
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        content       <- map["content"]
        msgId         <- map["id"]
        is_read       <- map["is_read"]
        title         <- map["title"]
        created_at    <- map["created_at"]

    }
    

}
