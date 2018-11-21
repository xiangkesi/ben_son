//
//  RSHomeViewModel.swift
//  ben_son
//
//  Created by ZS on 2018/9/11.
//  Copyright © 2018年 ZS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
class RSHomeViewModel: NSObject {
    
    let disposeBag = DisposeBag()
    private var loadAdData = PublishSubject<Int>()
    var adresult: Observable<[AdModel]>?

    
    var recommendedSubject = PublishSubject<Int>()
    var recommendedResult: Observable<BSHomeModel?>?
    var home: BSHomeModel?
    
    
    var signingIn: Observable<Bool>?

    
    var resultNews: Observable<[BSNews]>?
    private var loadData = PublishSubject<Int>()
    var refreshStatus = Variable(BSRefreshStatus.InvalidData)
    
    private var newLists = [BSNews]()
    private var param: BSNewsParam?
    
    override init() {
        super.init()
        
        adresult = loadAdData.flatMapLatest({ (page) -> Observable<[AdModel]> in
            return bs_provider.rx.request(BSServiceAPI.home_bander).mapJSON().map({ (json) -> [AdModel] in
                return self.mapperObjectAds(json)
            }).catchErrorJustReturn([]).asObservable()
        })
        
        recommendedResult = recommendedSubject.flatMapLatest({ (type) -> Observable<BSHomeModel?> in
            return bs_provider.rx.request(BSServiceAPI.recommended_car).mapJSON().map({ (json) -> BSHomeModel? in
                if let data = json as? [String: Any], let result = data["data"], let dicJson = result as? [String: Any] {
                    if let home = BSHomeModel(JSON: dicJson) {
                        self.home = home
                        return home
                    }
                }
                return self.home
            }).catchErrorJustReturn(self.home).asObservable()
        })
        
        resultNews = loadData.flatMapLatest { (page) -> Observable<[BSNews]> in
            return bs_provider.rx.request(BSServiceAPI.news_list(page: page)).mapJSON().map({ (json) -> [BSNews] in
                if let data = json as? [String: AnyObject], let rows = data["data"], let dicArray = rows as? [[String: AnyObject]] {
                    if let p = BSNewsParam(JSON: data) {
                        BSLog("\(p.current_page), \(p.last_page), \(p.total), \(p.per_page)")
                        self.param = p
                        if self.param?.current_page == 1 {
                            self.newLists.removeAll()
                            self.refreshStatus.value = BSRefreshStatus.DropDownSuccess
                        }else{
                            if (self.param?.current_page)! * (self.param?.per_page)! > (self.param?.total)! {
                                self.refreshStatus.value = BSRefreshStatus.PullSuccessNoMoreData
                                self.param?.current_page = 0
                            }else {
                                self.refreshStatus.value = BSRefreshStatus.PullSuccessHasMoreData
                            }
                        }
                        for dic in dicArray {
                            if let new = BSNews(JSON: dic) {
                                self.newLists.append(new)
                            }
                        }
                    }
                    return self.newLists
                }
                self.refreshStatus.value = BSRefreshStatus.InvalidData
                return self.newLists
            }).catchError({ (error) -> PrimitiveSequence<SingleTrait, [BSNews]> in
                self.refreshStatus.value = BSRefreshStatus.InvalidData
                return PrimitiveSequence<SingleTrait, [BSNews]>.just(self.newLists)
            }).asObservable()
        }
        
    }    
    func loadWebData() {
        loadAdData.onNext(1)
        recommendedSubject.onNext(1)
        if self.param != nil {
            self.param?.current_page = 0
        }
        loadData.onNext(self.param == nil ? 1 : ((self.param?.current_page)! + 1))
    }
    
    func loadMoreData() {
        loadData.onNext((self.param?.current_page)! + 1)
    }
}
