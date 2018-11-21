//
//  BSObjectAPI.swift
//  ben_son
//
//  Created by ZS on 2018/9/16.
//  Copyright © 2018年 ZS. All rights reserved.
//

extension RSHomeViewModel {
    func mapperObjectAds(_ json: Any) -> [AdModel] {
        var adModels = [AdModel]()
        if let ad = json as? [String: AnyObject], let ads = ad["data"], let result = ads as? [[String: AnyObject]] {
            for dic in result {
                if let adModel = AdModel(JSON: dic) {
                    adModels.append(adModel)
                }
            }
        }
        return adModels
    }
}

extension BSCarViewModel {
    func mapperObjectBrands(_ json: Any) -> [CarBrand] {
        if let data = json as? [String: Any], let dic = data["data"], let dicArray = dic as? [[String: Any]] {
            ZSCacheManager.shareManager().cacheData(dicArray, kPath_carlist)
            self.carBrands.removeAll()
            for dic in dicArray {
                if let brand = CarBrand(JSON: dic) {
                    self.carBrands.append(brand)
                }
            }
        }
        return self.carBrands
    }
}

extension CarDetailViewModel {
    
    func mapperObjectCarMsg(json: Any) -> Bool {
        if let jsonDic = json as? [String: Any], let dataDic = jsonDic["data"] as? [String: Any] {
            if let carMsg = CarDetailModel(JSON: dataDic) {
                carMsg.car_praces = carMsg.mapPraceToArray()
                carMsg.car_msgs = carMsg.mapCarMsgArrays()
                self.detail = carMsg
                return true
            }
        }
        return false
    }
}
