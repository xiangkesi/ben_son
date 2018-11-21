//
//  BSAccountCodeViewModel.swift
//  ben_son
//
//  Created by ZS on 2018/9/18.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BSAccountCodeViewModel: NSObject {

    let validatedCode: Driver<ValidationResult>
    
    let signupEnabled: Driver<Bool>
    
    let disposeBag = DisposeBag()
    
    
    let signingIn: Driver<Bool>
    
    let signupResult: Driver<Bool>
    
        init(input: (
            phoneNumber: String,
            code: Driver<String>,
            loginTaps: Signal<Void>
            ),
             dependency: BSLoginService) {
            
            self.validatedCode = input.code.map({ (code) in
                return dependency.validateRepeatedPassword(code)
            })
            
            self.signupEnabled = self.validatedCode.flatMapLatest({ (result) -> Driver<Bool> in
                return Driver<Bool>.just(result.isValid)
            })
            
            
            let activityIndicator = ActivityIndicator()
            self.signingIn = activityIndicator.asDriver()
            
            
        
            let phone = Driver<String>.just(input.phoneNumber)
            let phoneAndCode = Driver.combineLatest(phone, input.code) {
                        (phone: $0, code: $1) }
            
            signupResult = input.loginTaps.withLatestFrom(phoneAndCode).flatMapLatest({ (pair) in
                return bs_provider.rx.request(BSServiceAPI.login(phone: pair.phone, code: pair.code)).mapJSON().map({ (json) -> Bool in
                    BSLog(json)
                    if let dic = json as? [String: Any], let status = dic["status"], let result = status as? String, let data = dic["data"] as? [String: Any], let tokenDic = data["token"] as? [String: Any] {
                        if result == "success" {
                             AccountManager.shareManager().login(dic: tokenDic)
                             return true
                        }else{
                            return false
                        }
                    }
                    return false
                }).trackActivity(activityIndicator).asDriver(onErrorJustReturn: false)
            })
       
    }
    
    func getCode(phone: String) {
        bs_provider.rx.request(BSServiceAPI.login_getcode(phone: phone)).mapJSON().subscribe(onSuccess: { (json) in
            BSLog(json)
        }) { (error) in
            BSLog(error)
        }.disposed(by: disposeBag)
    }
    
    
    deinit {
        BSLog("销毁了吗")
    }
}
