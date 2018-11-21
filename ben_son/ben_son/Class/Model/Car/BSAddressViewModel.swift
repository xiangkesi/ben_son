//
//  BSAddressViewModel.swift
//  ben_son
//
//  Created by ZS on 2018/9/26.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import ObjectMapper
import RxSwift
import RxCocoa

class BSAddressViewModel: NSObject {

    override init() {
        super.init()
    }
    
}


class BSAddress {
    
    
    var addressId: Int = 0
    
    var address: String?
    
    var userName: String?
    
    var phone: String?

}

class BSAddAddressParam {
    
    var phoneNumber = Variable("")
    
    var userName = Variable("")
    
    var address: String?
    
    var detailAddress = Variable("")
    
    var isNomalAddress: Bool = false
    
}

extension BSAddAddressParam {
    
    func judgeEmpty() -> Bool {
        var titleStr = ""
        if userName.value == "" {
            titleStr = "请输入收货人"
        }else if phoneNumber.value == "" {
            titleStr = "请输入手机号"
        }else if address == nil || address == "" {
            titleStr = "请选择所在地区"
        }else if detailAddress.value == "" {
            titleStr = "请输入详细地址"
        }else {
            return true
        }
        RSProgressHUD.showSuccessOrFailureHud(titleStr: titleStr, (kRootVc?.view)!)
        return false
    }
    func mapToJson() -> [String: Any] {
        return ["name": userName.value,
                "telephone":phoneNumber.value,
                "region": address!,
                "address": detailAddress.value]
    }
}
