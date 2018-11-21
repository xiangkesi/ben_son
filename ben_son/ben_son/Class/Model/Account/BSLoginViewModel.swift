//
//  BSLoginViewModel.swift
//  ben_son
//
//  Created by ZS on 2018/9/14.
//  Copyright © 2018年 ZS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ValidationResult {
    case validating
    case empty
    case ok(message: String)
    case failed(message: String)
}

extension ValidationResult {
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}

extension ValidationResult: CustomStringConvertible {
    var description: String {
        switch self {
        case .validating:
            return "正在验证..."
        case .empty:
            return ""
        case let .ok(message):
            return message
        case let .failed(message):
            return message
        }
    }
}


class BSLoginService {
    
    
    private let codeCount = 4
    
    func validateUsername(_ phoneNumber: String) -> Observable<ValidationResult> {
        if phoneNumber.isEmpty {
            return Observable<ValidationResult>.just(ValidationResult.empty)
        }
        let pattern2 = "^1[0-9]{10}$"
        if !NSPredicate(format: "SELF MATCHES %@", pattern2).evaluate(with: phoneNumber) {
            return Observable.just(ValidationResult.failed(message: "您输入的手机号不合法"))
        }
        if phoneNumber.count != 11 {
            return Observable.just(ValidationResult.failed(message: "您输入的手机号不合法"))
        }
        return Observable<ValidationResult>.just(ValidationResult.ok(message: "success"))
    }
    
    func validateRepeatedPassword(_ code: String) -> ValidationResult {
        if code.count == 0 {
            return ValidationResult.empty
        }
        if code.count != codeCount {
            return ValidationResult.failed(message: "验证码需要\(codeCount)个数字")
        }
        
        return ValidationResult.ok(message: "验证码验证成功")
    }
}

class BSLoginViewModel: NSObject {
    
    let validatedPhone: Driver<ValidationResult>
    
//    let validatedCode: Driver<ValidationResult>
    
    let signupEnabled: Driver<Bool>
    
//    let signingIn: Driver<Bool>
//
//    let signupResult: Driver<Bool>
    
    init(input:(
            phoneNumber: Driver<String>,
            loginTaps: Signal<Void>
        ),dependency: BSLoginService) {

        self.validatedPhone = input.phoneNumber.flatMapLatest({ (phone) in
            return dependency.validateUsername(phone).asDriver(onErrorJustReturn: ValidationResult.failed(message: "验证失败了"))
        })
        
        self.signupEnabled = self.validatedPhone.flatMapLatest({ (result) -> Driver<Bool> in
            return Driver<Bool>.just(result.isValid)
        })
    }
    
//    init(input: (
//        phoneNumber: Driver<String>,
//        code: Driver<String>,
//        loginTaps: Signal<Void>
//        ),
//         dependency: BSLoginService) {
//        self.validatedPhone = input.phoneNumber.flatMapLatest({ (phone) in
//        return dependency.validateUsername(phone).asDriver(onErrorJustReturn: ValidationResult.failed(message: "验证失败了"))
//        })
//
//        self.validatedCode = input.code.map({ (code) in
//            return dependency.validateRepeatedPassword(code)
//        })
//
//        self.signupEnabled = Driver.combineLatest(validatedPhone, validatedCode) {phone, code in
//            phone.isValid && code.isValid
//        }.distinctUntilChanged()
//
//        //获取最新的用户名和密码
//        let phoneAndCode = Driver.combineLatest(input.phoneNumber, input.code) {
//            (phone: $0, code: $1) }
//        //用于检测是否正在请求数据
//        let activityIndicator = ActivityIndicator()
//        self.signingIn = activityIndicator.asDriver()
//
//        signupResult = input.loginTaps.withLatestFrom(phoneAndCode).flatMapLatest({ (pair) -> Driver<Bool> in
//
//            return bs_provider.rx.request(BSServiceAPI.registOrLogin(phone: pair.phone, code: pair.code)).mapJSON().map({ (result) -> Bool in
//                return true
//            }).trackActivity(activityIndicator).asDriver(onErrorJustReturn: true)
//        })
//
//    }
}
