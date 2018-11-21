//
//  UITextView+Extension.swift
//  ben_son
//
//  Created by ZS on 2018/10/24.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit

extension UITextView {
    
    func placeHolderTextColor(placeholdStr: String, placeholdColor: UIColor) {
        let placeHolderLabel = UILabel()
        placeHolderLabel.text = placeholdStr
        placeHolderLabel.numberOfLines = 0
        placeHolderLabel.textColor = placeholdColor
        placeHolderLabel.font = font
        placeHolderLabel.sizeToFit()
        addSubview(placeHolderLabel)
        setValue(placeHolderLabel, forKey: "_placeholderLabel")
    }
}
