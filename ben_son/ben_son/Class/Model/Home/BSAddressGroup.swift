//
//  BSAddressGroup.swift
//  ben_son
//
//  Created by ZS on 2018/9/25.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import ObjectMapper
import RxSwift
import RxDataSources

class BSAddressGroup: Mappable {
    
    var sectionTitle: String?
    
    var citys: [BSAddressColumn]?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        sectionTitle   <- map["title"]
        citys          <- map["citys"]
    }
    

}


class BSAddressColumn: Mappable {
    
    var cityId: String?
    
    var cityName: String?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        cityId   <- map["nameId"]
        cityName          <- map["name"]
    }
    
}


class BSCityListViewModel {
    
    let subjectCity = PublishSubject<[SectionModel<String?, CitySectionItem>]>()
    var sectionTitles = [String]()
    func loadWebData(finish:@escaping ([String]) -> ()) {
        DispatchQueue.global().async { [weak self] in
            var sections = [SectionModel<String?, CitySectionItem>]()
            var resultSearch = [String]()
            if let jsonPath = Bundle.main.path(forResource: "RSCitys", ofType: "plist"), let array = NSArray(contentsOfFile: jsonPath), let dicArray = array as? [[String: Any]] {
                for (index, dic) in dicArray.enumerated() {
                    if let cityGroup = BSAddressGroup(JSON: dic) {
                        var sectionItems = [CitySectionItem]()
                        if index == 0 {
                            self?.sectionTitles.append("当前")
                            sectionItems.append(CitySectionItem.TitleCurrentCity(title: "定位中..."))
                        }else if index == 1 {
                            sectionItems.append(CitySectionItem.TitleHotCity(addressArray: cityGroup.citys!))
                            self?.sectionTitles.append("热门")
                        }else{
                            self?.sectionTitles.append(cityGroup.sectionTitle!)
                        }
                        for address in cityGroup.citys! {
                            if index > 1{
                                sectionItems.append(CitySectionItem.TitleCityList(address: address))
                                resultSearch.append(address.cityName!)
                            }
                        }
                        let sectionModel = SectionModel(model: cityGroup.sectionTitle, items: sectionItems)
                        sections.append(sectionModel)
                    }
                }
            }
            DispatchQueue.main.async(execute: { [weak self] in
                self?.subjectCity.onNext(sections)
                finish(resultSearch)
            })
        }
    }
}
