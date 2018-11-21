//
//  CarDetailViewModel.swift
//  ben_son
//
//  Created by ZS on 2018/10/16.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import ObjectMapper
import RxSwift
import RxCocoa

class CarDetailViewModel: NSObject {
    
    var resultCarDetail: Observable<Bool>?
    var loadCarDetailData = PublishSubject<Int>()
    let disposeBag = DisposeBag()
    var detail: CarDetailModel?
    
    var signupResult: Observable<Bool>?
    let signingIn = PublishSubject<BSServiceAPI>()


    override init() {
        super.init()
        self.resultCarDetail = loadCarDetailData.flatMapLatest({ (carId) ->  Observable<Bool> in
            return bs_provider.rx.request(BSServiceAPI.car_detail(carId: carId), callbackQueue: DispatchQueue.global()).mapJSON().map({[weak self] (json) -> Bool in
                return (self?.mapperObjectCarMsg(json: json))!
            }).catchErrorJustReturn(false).asObservable()
        })
        
        self.signupResult = signingIn.flatMapLatest({ (col) in
            return bs_provider.rx.request(col).mapJSON().map({ (json) -> Bool in
                if let dicJson = json as? [String: Any], let success = dicJson["status"] as? String{
                    if success == "success" {
                        return true
                    }
                    return false
                }
                return false
            }).catchErrorJustReturn(false).asObservable()
        })
    }
}

class CarDetailModel: Mappable {
    
    var car_id: Int = 0
    
    var carPhotos: [String]?
    
    var model: String?
    
    var brand: String?
    
    var oneDayPrice: String?
    
    var tridDayPrice: String?
    
    var weekPrice: String?
    
    var monthPrice: String?
    
    var car_engine: String?
    
    var car_displacement: String?
    
    var car_upSpeed: String?
    
    var car_maxSpeed: String?
    
    var car_seat: String?
    
    var car_maxPower: String?
    
    var car_ceiling: String?
    
    var car_deposit: Int = 0
    
    var colors: [CarDetailColor]?
    
    var pay_price: Int = 0
    
    var isMark: Bool = false
    
    
    
    
    var car_praces:[CarDetailPrace]?
    var car_msgs: [CarDetailPrace]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        carPhotos            <- map["images"]
        model                <- map["model"]
        brand                <- map["brand_name"]
        oneDayPrice          <- map["onePrice"]
        tridDayPrice         <- map["tridPrice"]
        weekPrice            <- map["weekPrice"]
        monthPrice           <- map["monthPrice"]
        car_deposit          <- map["deposit"]
        car_engine           <- map["engine"]
        car_displacement     <- map["displacement"]
        car_upSpeed          <- map["upSpeed"]
        car_maxSpeed         <- map["maxSpeed"]
        car_seat             <- map["seat"]
        car_maxPower         <- map["maxPower"]
        car_ceiling          <- map["ceiling"]
        colors               <- map["colors"]
        pay_price            <- map["pay_price"]
        car_id               <- map["id"]
        isMark               <- map["isMark"]

    }
    
}

extension CarDetailModel {
    
    func mapPraceToArray() -> [CarDetailPrace] {
    
        
        let one_day_prace = CarDetailPrace()
        one_day_prace.day_title = "一天"
        one_day_prace.oneDay_prace = (oneDayPrice ?? "0") + "/天"
        one_day_prace.threeDay_prace = String(Int(Float(oneDayPrice ?? "0")! * 0.9)) + "/天"
        one_day_prace.week_prace = String(Int(Float(oneDayPrice ?? "0")! * 0.8)) + "/天"
        
        let three_day_prace = CarDetailPrace()
        three_day_prace.day_title = "三天"
        three_day_prace.oneDay_prace = (tridDayPrice ?? "0") + "/天"
        three_day_prace.threeDay_prace = String(Int(Float(tridDayPrice ?? "0")! * 0.9)) + "/天"
        three_day_prace.week_prace = String(Int(Float(tridDayPrice ?? "0")! * 0.8)) + "/天"
        
        let week_day_prace = CarDetailPrace()
        week_day_prace.day_title = "一周"
        week_day_prace.oneDay_prace = (weekPrice ?? "0") + "/天"
        week_day_prace.threeDay_prace = String(Int(Float(weekPrice ?? "0")! * 0.9)) + "/天"
        week_day_prace.week_prace = String(Int(Float(weekPrice ?? "0")! * 0.8)) + "/天"
        
        let mounth_day_prace = CarDetailPrace()
        mounth_day_prace.day_title = "一月"
        mounth_day_prace.oneDay_prace = (monthPrice ?? "0") + "/天"
        mounth_day_prace.threeDay_prace = String(Int(Float(monthPrice ?? "0")! * 0.9)) + "/天"
        mounth_day_prace.week_prace = String(Int(Float(monthPrice ?? "0")! * 0.8)) + "/天"
        
        let deposit = CarDetailPrace()
        deposit.day_title = "押金"
        deposit.oneDay_prace = String(car_deposit) + "万"
        deposit.threeDay_prace = String(Int(CGFloat(car_deposit) * 0.5)) + "/天"
        deposit.week_prace = "0"
        
        let arrayPraces = [one_day_prace, three_day_prace, week_day_prace, mounth_day_prace, deposit]
        return arrayPraces
    }
    
    func mapCarMsgArrays() -> [CarDetailPrace] {
        
        let displacement = CarDetailPrace()
        displacement.day_title = "排量"
        displacement.oneDay_prace = car_displacement
        
        let upSpeed = CarDetailPrace()
        upSpeed.day_title = "0-100km/h加速 (s)"
        upSpeed.oneDay_prace = car_upSpeed
        
        
        let maxSpeed = CarDetailPrace()
        maxSpeed.day_title = "最高时速 (km/h)"
        maxSpeed.oneDay_prace = car_maxSpeed
        
        let seat = CarDetailPrace()
        seat.day_title = "座位数 (个)"
        seat.oneDay_prace = car_seat
        
        let maxPower = CarDetailPrace()
        maxPower.day_title = "最大马力 (Ps)"
        maxPower.oneDay_prace = car_maxSpeed
      
       return [displacement, upSpeed, maxSpeed, seat, maxPower]
    }
}

class CarDetailPrace {
    
    var day_title: String?
    
    var oneDay_prace: String?
    
    var threeDay_prace: String?
    
    var week_prace: String?
}

class CarDetailColor: Mappable {
    
    var carColor: String?
    
    var colorId: Int = 0
    
    var onePrice: Int = 0
    
    var isSelected: Bool = false
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        carColor            <- map["color"]
        colorId            <- map["id"]
        onePrice            <- map["onePrice"]
    }
    
    
}
