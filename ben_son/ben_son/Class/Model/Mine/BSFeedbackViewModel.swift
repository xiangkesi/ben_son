//
//  BSFeedbackViewModel.swift
//  ben_son
//
//  Created by ZS on 2018/11/8.
//  Copyright © 2018 ZS. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BSFeedbackViewModel {

    let param = BSFeedbackParam()
    var result_request: Observable<Bool>?
    let publish_load = PublishSubject<Int>()
    
    init() {
        result_request = publish_load.flatMapLatest({[weak self] (type) -> Observable<Bool> in
            return bs_uploadFile_bs_provider.rx.request(BSServiceAPI.feedback(param: (self?.param.mapToDic())!)).mapJSON().map({ (json) -> Bool in
                BSLog(json)
                return true
            }).catchErrorJustReturn(false).asObservable()
        })
    }
    
    
}

class BSFeedbackParam {
    
    var proposal = Variable("")
    
    var telephone = Variable("")
    
    var email = Variable("")
    
}

extension BSFeedbackParam {
    func mapToDic() -> [String: Any] {
        return ["proposal":proposal.value,
                "telephone":telephone.value,
                "email":email.value]
    }
}
