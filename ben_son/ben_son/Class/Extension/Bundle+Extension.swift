//
//  Bundle+Extension.swift
//  ben_son
//
//  Created by ZS on 2018/8/28.
//  Copyright © 2018年 ZS. All rights reserved.
//

import Foundation

extension Bundle {
    //计算型属性 不能使用懒加载
    var nameSpace: String{
        let dic = infoDictionary
        let spaceName = dic?["CFBundleName"] as? String ?? ""
        return spaceName
    }
}
