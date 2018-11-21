//
//  Login_user.swift
//  ben_son
//
//  Created by ZS on 2018/11/5.
//  Copyright © 2018 ZS. All rights reserved.
//

import UIKit
import ObjectMapper

class Login_user: Mappable {
    
    var avatar: String?
    
    var gender: Int = 0
    
    var level: Int = 0
    
    var order_progress_count: Int = 0
    
    var signature: String?
    
    var telephone: String?
    
    var username: String?
    
    var address: String?
    
    var score: Int = 0
    
    
    
    
    
    
    
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        avatar                      <- map["avatar"]
        gender                      <- map["gender"]
        level                       <- map["level"]
        order_progress_count        <- map["order_progress_count"]
        signature                   <- map["signature"]
        telephone                   <- map["telephone"]
        username                    <- map["username"]
        address                     <- map["address"]

    }
    

}
