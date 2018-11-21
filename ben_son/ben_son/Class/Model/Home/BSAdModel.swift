//
//  BSAdModel.swift
//  ben_son
//
//  Created by ZS on 2018/9/15.
//  Copyright © 2018年 ZS. All rights reserved.
//

import Foundation
import ObjectMapper

class AdModel: Mappable {
    var banderId: Int = 0
    var banderUrl: String?
    
    
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        banderId        <- map["nid"]
        banderUrl       <- map["image"]

    }
    
}
