//
//  BSCarModelListsViewModel.swift
//  ben_son
//
//  Created by ZS on 2018/11/8.
//  Copyright © 2018 ZS. All rights reserved.
//

import UIKit
import RxSwift
class BSCarModelListsViewModel {

    let request_publist = PublishSubject<Int>()
    var result_obser: Observable<Bool>?
    
    let result_publish = PublishSubject<[CarModel]>()
    
    var cars = [CarModel]()
    
    init() {
        result_obser = request_publist.flatMapLatest({ (brandId) -> Observable<Bool> in
            return bs_provider.rx.request(BSServiceAPI.car_model_list(brand: brandId)).mapJSON().map({ (json) -> Bool in
                if let dicJson = json as? [String: Any], let dataArray = dicJson["data"] as? [[String: Any]] {
                    self.cars.removeAll()
                    for dic in dataArray {
                        if let model = CarModel(JSON: dic) {
                            self.cars.append(model)
                        }
                    }
                    return true
                }
                return false
            }).catchErrorJustReturn(false).asObservable()
        })
        
    }
    
    
}
