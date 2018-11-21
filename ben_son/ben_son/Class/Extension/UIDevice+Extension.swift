//
//  UIDevice+Extension.swift
//  ben_son
//
//  Created by ZS on 2018/8/28.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit

extension UIDevice {
    
    func isX() -> Bool {
        if #available(iOS 11.0, *) {
            guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else {
                return false
            }
            if unwrapedWindow.safeAreaInsets.left > 0 || unwrapedWindow.safeAreaInsets.bottom > 0 {
                return true
            }
        }
        return false
    }
    
    public func navigationBarHeight() -> CGFloat {
        return isX() ? 88.0 : 64.0
    }
    
    public func tabBarHeight() -> CGFloat {
        return isX() ? 83.0 : 49.0
    }
    
    public func statusHeight() -> CGFloat {
        return isX() ? 44.0 : 20.0
    }
    
    public func contentHeight() -> CGFloat {
        return kScreenHeight - navigationBarHeight() - tabBarHeight()
    }
    
    public func tabbarBottomHeight() -> CGFloat {
        return isX() ? 34.0 : 0.0
    }
    
    public func navigationSubviewY() -> CGFloat {
        return isX() ? 51.0 : 27.0
    }
    
    public func contentNoNavHeight() -> CGFloat {
        return kScreenHeight - tabBarHeight()
    }
    
    public func contentNoTabBarHeight() -> CGFloat {
        return kScreenHeight - navigationBarHeight()
    }
}
