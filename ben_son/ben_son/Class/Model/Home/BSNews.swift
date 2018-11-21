//
//  BSNews.swift
//  ben_son
//
//  Created by ZS on 2018/9/13.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import ObjectMapper

class BSNews: Mappable {
    
    var author: String?
    var newsHead: String?
    var newsTitle: String?
    var newsId: Int = 0
    var newsPhoto: String?
    var newsTitles: String?
    
    var isAnimnes: Bool = false
    
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        author       <- map["author"]
        newsHead     <- map["newsHead"]
        newsTitle    <- map["newsTitle"]
        newsId       <- map["id"]
        newsPhoto    <- map["image"]
        newsTitles    <- map["title"]

    }
    

}

class BSNewsParam: Mappable {
    
    var current_page: Int = 0
    var total: Int = 0
    var last_page: Int = 0
    var per_page: Int = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        current_page     <- map["current_page"]
        total            <- map["total"]
        last_page        <- map["last_page"]
        per_page         <- map["per_page"]

    }
    
    
}
