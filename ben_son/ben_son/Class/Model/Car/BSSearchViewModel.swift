//
//  BSSearchViewModel.swift
//  ben_son
//
//  Created by ZS on 2018/11/6.
//  Copyright © 2018 ZS. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper

class BSSearchViewModel: NSObject {

    let disposeBag = DisposeBag()

    var searchResult: Observable<Bool>?
    let searchLoadData = PublishSubject<String>()
    
    var result_cars = [CarModel]()
    let publish_cars = PublishSubject<[CarModel]>()
    
    
    
    var hotSearchList: Observable<[SearchHot_keyword]>?
    let hotSearchLoadData = PublishSubject<Int>()
    
    
    override init() {
        super.init()
        searchResult = searchLoadData.flatMapLatest({ (keyword) -> Observable<Bool> in
            self.result_cars.removeAll()
            return bs_uploadFile_bs_provider.rx.request(BSServiceAPI.search_car(keywords: keyword)).mapJSON().map({ (json) -> Bool in
                if let jsonData = json as? [String: Any], let dicJson = jsonData["data"] as? [[String: Any]] {
                    for dic in dicJson {
                        if let car = CarModel(JSON: dic) {
                            self.result_cars.append(car)
                        }
                    }
                    return true
                }
                return false
            }).catchErrorJustReturn(false).asObservable()
        })
        
        hotSearchList = hotSearchLoadData.flatMapLatest({ (page) -> Observable<[SearchHot_keyword]> in
            return bs_provider.rx.request(BSServiceAPI.hot_search_cars).mapJSON().map({ (json) -> [SearchHot_keyword] in
                var hot_keywords = [SearchHot_keyword]()
                if let data = json as? [String: Any], let dicArray = data["data"] as? [[String: Any]] {
                    for dic in dicArray {
                        if let model = SearchHot_keyword(JSON: dic) {
                            hot_keywords.append(model)
                        }
                    }
                }
                return hot_keywords
            }).catchErrorJustReturn([]).asObservable()
        })
    }
    
}


class SearchHot_keyword: Mappable {
    
    var keyword: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        keyword       <- map["keyword"]

    }
    
    
}
