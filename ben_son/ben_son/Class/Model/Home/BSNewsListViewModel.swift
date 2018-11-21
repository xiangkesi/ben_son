//
//  BSNewsListViewModel.swift
//  ben_son
//
//  Created by ZS on 2018/10/19.
//  Copyright © 2018年 ZS. All rights reserved.
//

import Foundation
import RxSwift
class BSNewsListViewModel: NSObject {
    
    var resultNews: Observable<[BSNews]>?
    private var loadData = PublishSubject<Int>()
    var refreshStatus = Variable(BSRefreshStatus.InvalidData)
    
    let disposeBag = DisposeBag()

    var newLists = [BSNews]()
    
    private var param: BSNewsParam?
    
    override init() {
        super.init()
        resultNews = loadData.flatMapLatest { (page) -> Observable<[BSNews]> in
            return bs_provider.rx.request(BSServiceAPI.news_list(page: page)).mapJSON().map({ (json) -> [BSNews] in
                if let data = json as? [String: AnyObject], let rows = data["data"], let dicArray = rows as? [[String: AnyObject]] {
                    if let p = BSNewsParam(JSON: data) {
                        self.param = p
                        if self.param?.current_page == 1 {
                            self.newLists.removeAll()
                            self.refreshStatus.value = BSRefreshStatus.DropDownSuccess
                        }else{
                            if (self.param?.current_page)! * (self.param?.per_page)! > (self.param?.total)! {
                                self.refreshStatus.value = BSRefreshStatus.PullSuccessNoMoreData
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
    
    
    func loadWebData(type: Int = 1) {
        if type == 0 && self.param != nil {
            self.param?.current_page = 0
        }
        loadData.onNext(self.param == nil ? 1 : ((self.param?.current_page)! + 1))
    }
    
}
