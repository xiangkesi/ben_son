//
//  UIlabel+Extension.swift
//  ben_son
//
//  Created by ZS on 2018/10/25.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit


extension UILabel {
    
    func setupAttribute(_ fontSize: CGFloat,_ fontType: String?, _ colorString: String,_ labelSize: CGSize,_ labelOrigin: CGPoint) {
        if fontType == nil {
            font = UIFont.systemFont(ofSize: fontSize)
        }else {
            font = UIFont.init(name: fontType!, size: fontSize)
        }
        textColor = UIColor.colorWidthHexString(hex: colorString)
        size = labelSize
        origin = labelOrigin
    }
}
