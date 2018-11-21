//
//  BSHomeModel.swift
//  ben_son
//
//  Created by ZS on 2018/10/17.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import ObjectMapper


class BSHomeModel: Mappable {
    
    var firstBrand: [HomeRecommendedBrand]?
    
    var firstCar: [HomeRecommendedCar]?
    
    var secondBrand: [HomeRecommendedBrand]?
    
    var secondCar: [HomeRecommendedCar]?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        firstBrand       <- map["index_first_brand"]
        firstCar       <- map["index_first_car"]
        secondBrand       <- map["index_second_brand"]
        secondCar       <- map["index_second_car"]

    }
    

}

class HomeRecommendedBrand: Mappable {
    
    var brandId: Int = 0
    
    var image: String?
    
    var name: String?
    
    var slogo: String?
    
    var logo: String?
    
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        brandId          <- map["id"]
        image            <- map["image"]
        name             <- map["name"]
        slogo            <- map["slogo"]
        logo             <- map["logo"]
    }
    
}

class HomeRecommendedCar: Mappable {
    
    var cover: String?
    
    var carId: Int = 0
    
    var model: String?
    
    var onePrice: String?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        cover       <- map["cover"]
        carId       <- map["id"]
        model       <- map["model"]
        onePrice       <- map["onePrice"]

    }
    
    
    
}
