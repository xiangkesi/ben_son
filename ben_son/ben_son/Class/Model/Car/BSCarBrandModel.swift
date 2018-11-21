//
//  BSCarBrandModel.swift
//  ben_son
//
//  Created by ZS on 2018/9/13.
//  Copyright © 2018年 ZS. All rights reserved.
//

import Foundation
import ObjectMapper


class CarBrand: Mappable {
    
    var logo: String?
    
    var slogo: String?
    
    var cars: [CarModel]?
    
    var name: String?
    
    var brandId: Int = 0
    
    
    var selected: Bool = false
    
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        logo       <- map["logo"]
        slogo      <- map["slogo"]
        cars       <- map["cars"]
        name       <- map["name"]
        brandId       <- map["id"]
    }
    
}


class CarModel: Mappable {
    
    var carId: Int = 0
    
    var carName: String?
    
    var cover: String?
    
    var prace: String?
    
    var brand: CarNewBrand?
    
    var brand_name: String?
    
    
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        carId       <- map["id"]
        carName     <- map["model"]
        cover        <- map["cover"]
        prace         <- map["onePrice"]
        brand         <- map["brand"]
        brand_name         <- map["brandName"]


    }
    
    
}

class CarNewBrand: Mappable {
    
    var brand: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        brand       <- map["name"]

    }
    
    
}
