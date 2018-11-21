//
//  BSOrderModel.swift
//  ben_son
//
//  Created by ZS on 2018/11/5.
//  Copyright © 2018 ZS. All rights reserved.
//

import UIKit
import ObjectMapper


class BSOrderModel: Mappable {
    
    var brand_name: String?
    
    var car_cover: String?
    
    var car_model: String?
    
    var days: Int = 0
    
    var removed_city: String?
    
    var returned_city: String?
    
    var removed_time: String?
    
    var returned_time: String?
    
    var amount: String?
    
    var order_status: String?
    
    var order_id: Int = 0
    
    var pay_price: String?
    
    var name: String?
    
    var telephone: String?
    
    var remove_type: Int = 0
    
    var removed_address: String?
    
    var order_number: String?
    
    var created_at: String?
    
    var colorString: String?
    
    var pay_type: String?
    
    var model: String?
    
    
    
    var remove_address_attstr: NSAttributedString?
    var return_address_attstr: NSAttributedString?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        brand_name           <- map["brand_name"]
        car_cover            <- map["car_cover"]
        car_model            <- map["car_model"]
        days                 <- map["days"]
        removed_city         <- map["removed_city"]
        returned_city        <- map["returned_city"]
        removed_time         <- map["removed_time"]
        returned_time        <- map["returned_time"]
        amount               <- map["amount"]
        order_status         <- map["status"]
        order_id             <- map["id"]
        pay_price            <- map["pay_price"]
        name                 <- map["name"]
        telephone            <- map["telephone"]
        remove_type          <- map["remove_type"]
        removed_address      <- map["removed_address"]
        order_number         <- map["order_number"]
        created_at           <- map["created_at"]
        colorString          <- map["color"]
        model                <- map["model"]

    }
    

}


class WhchatPayModel: Mappable {
    
    var appid: String?
    
    var noncestr: String?
    
    var package: String?
    
    var partnerid: String?
    
    var prepayid: String?
    
    var sign: String?
    
    var timestamp: Int64 = 0
    
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        appid                <- map["appid"]
        noncestr             <- map["noncestr"]
        package              <- map["package"]
        partnerid            <- map["partnerid"]
        sign                 <- map["partnerid"]
        timestamp            <- map["partnerid"]
        prepayid             <- map["prepayid"]
    }
    
    
}
