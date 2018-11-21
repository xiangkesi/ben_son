//
//  UITextField+Extension.swift
//  ben_son
//
//  Created by ZS on 2018/9/18.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit

extension UITextField {
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        UIMenuController.shared.isMenuVisible = false
        return false        
    }
}
