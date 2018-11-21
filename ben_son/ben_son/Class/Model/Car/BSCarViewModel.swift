//
//  BSCarViewModel.swift
//  ben_son
//
//  Created by ZS on 2018/9/13.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift

class BSCarViewModel: NSObject {

    var result: Observable<[CarBrand]>?
    var loadData = PublishSubject<Int>()
    
    var resultCarModel: Observable<[CarModel]>?
    var loadModelData = PublishSubject<(value: [CarModel]?,type: Int)>()
    
    
    var refreshStatus = Variable(BSRefreshStatus.InvalidData)
    var carBrands = [CarBrand]()
    
    
    var signingIn: Observable<Bool>?
    let disposeBag = DisposeBag()


    override init() {
        super.init()
        
        let activityIndicator = ActivityIndicator()
        self.signingIn = activityIndicator.asObservable()
        
        result = loadData.flatMapLatest({ (p) -> Observable<[CarBrand]> in
            if p == 100 {
                return Observable.just(self.carBrands)
            }
            if p == 200 {
                let json = ZSCacheManager.shareManager().readCacheData(cacheKey: kPath_carlist)
                if json != nil {
                    if let dicArray = json as? [[String: Any]] {
                        self.carBrands.removeAll()
                        for dic in dicArray {
                            if let brand = CarBrand(JSON: dic) {
                                self.carBrands.append(brand)
                            }
                        }
                    }
                    return Observable.just(self.carBrands)
                }
            }
            
            return bs_provider.rx.request(BSServiceAPI.car_brand).mapJSON().map({ (json) -> [CarBrand] in
                BSLog(json)
                self.refreshStatus.value = BSRefreshStatus.DropDownSuccess
                return self.mapperObjectBrands(json)
            }).trackActivity(activityIndicator).catchErrorJustReturn(self.carBrands)
           
        })
        
        
        resultCarModel = loadModelData.flatMapLatest({ (models) -> Observable<[CarModel]> in            
            if models.type == 100 {
                return Observable.just(models.value!)
            }
            
            if models.type == 200 {
                let json = ZSCacheManager.shareManager().readCacheData(cacheKey: kPath_recommended_car_car)
                if json != nil {
                    var cars = [CarModel]()
                    if let dicArray = json as? [[String: Any]] {
                        for dic in dicArray {
                            if let car = CarModel(JSON: dic){
                                cars.append(car)
                            }
                        }
                    }
                    return Observable.just(cars)
                }
            }
            
            
            return bs_provider.rx.request(BSServiceAPI.recommended_car_car).mapJSON().map({ (json) -> [CarModel] in
                BSLog(json)
                var cars = [CarModel]()
                if let dic = json as? [String: Any], let result = dic["data"], let dicArray = result as? [[String: Any]] {
                    ZSCacheManager.shareManager().cacheData(dicArray, kPath_recommended_car_car)
                    for dic in dicArray {
                        if let car = CarModel(JSON: dic) {
                            cars.append(car)
                        }
                    }
                }
                return cars
            }).catchErrorJustReturn([]).asObservable()
        })
    }
}
