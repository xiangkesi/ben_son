//
//  UIColor+Extension.swift
//  ben_son
//
//  Created by ZS on 2018/8/28.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit

extension UIColor{
    
    static func colorWidthHexString(hex: String,_ alpha: CGFloat = 1.0) -> UIColor {
        
//        if hex.count != 6 || hex.count != 7 {
//            return UIColor.clear
//        }
        
        let set = CharacterSet.whitespacesAndNewlines
        var stringColor = hex.trimmingCharacters(in: set)
        
        if stringColor.hasPrefix("#"){
            stringColor = String(stringColor.suffix(stringColor.count - 1))
        }
        if stringColor.count != 6 {
            return UIColor.clear
        }
        
        let rString = String(stringColor.prefix(2))
                
        let startIndex = stringColor.index(stringColor.startIndex, offsetBy: 2)
        let endIndex = stringColor.index(stringColor.startIndex, offsetBy: 4)
        
        let gString = String(stringColor[startIndex..<endIndex])
        
        let bString = String(stringColor.suffix(2))
                
        var r: CUnsignedInt = 0
        var g: CUnsignedInt = 0
        var b: CUnsignedInt = 0
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
//        print("\(r)--\(g)---\(b)")
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
}
