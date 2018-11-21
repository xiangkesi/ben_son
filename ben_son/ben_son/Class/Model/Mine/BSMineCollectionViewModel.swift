//
//  BSMineCollectionViewModel.swift
//  ben_son
//
//  Created by ZS on 2018/10/30.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift

class BSMineCollectionViewModel: NSObject {

    var resultNews: Observable<Bool>?
    let loadData = PublishSubject<Int>()
    
    let publishResult = PublishSubject<[CarModel]>()
    
    
    var signupResult: Observable<Bool>?
    let signingIn = PublishSubject<CarModel>()

    var collectionCars = [CarModel]()
    
    let disposeBag = DisposeBag()
    
    override init() {
        super.init()
        resultNews = loadData.flatMapLatest({ (page) -> Observable<Bool> in
            if page == 100 {return Observable.just(true)}
            return bs_provider.rx.request(BSServiceAPI.car_collection_list).mapJSON().map({ (json) -> Bool in
                if let jsonDic = json as? [String: Any], let dicArray = jsonDic["data"] as? [[String: Any]] {
                    self.collectionCars.removeAll()
                    for dicCar in dicArray {
                        if let model = CarModel(JSON: dicCar) {
                            self.collectionCars.append(model)
                        }
                    }
                    return true
                }
                return false
            }).catchErrorJustReturn(false).asObservable()
        })
        
        
        signupResult = signingIn.flatMapLatest({ (car) in
            return bs_provider.rx.request(BSServiceAPI.car_collection_cancel(carId: car.carId)).mapJSON().map({ (json) -> Bool in
                if let dicJson = json as? [String: Any], let success = dicJson["status"] as? String{
                    if success == "success" {
                        let index = self.collectionCars.index(where: {$0 === car})
                        self.collectionCars.remove(at: index!)
                        return true
                    }
                    return false
                }
                return false
            }).catchErrorJustReturn(false).asObservable()
        })
    }
    
}
