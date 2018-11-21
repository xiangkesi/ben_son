//
//  String+Extension.swift
//  ben_son
//
//  Created by ZS on 2018/8/28.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit

extension String {
    
    func kIsEmpty() -> Bool {
        if isEmpty || self == ""{
            return true
        }
        return false
    }
    
    func judge_return_value(value: String?) -> String {
        if value == nil {
            return ""
        }
        return self
        
    }
    
    func rich_subStr(_ subStrs:[String]) -> NSAttributedString {
        
        let attStr = NSMutableAttributedString.init(string: self)
        
        for subStr in subStrs {
            if subStr.count == 0 {continue}
            var searchRange = NSRange(location: 0, length: self.count)
            repeat {
                let range = (self as NSString).range(of: subStr, options: [], range: searchRange)
                if range.location == NSNotFound {break}
                if text(index: range.location, textAttr: attStr) == nil {
                    attStr.addAttribute(NSAttributedString.Key.foregroundColor, value: kMainColor, range: range)
                }
                searchRange.location = searchRange.location + (searchRange.length > 0 ? searchRange.length : 1)
                if searchRange.location + 1 >= attStr.length {break}
                searchRange.length = attStr.length - searchRange.location
                
            }while (true)
            
        }
        return attStr
    }
    
    func text(index: Int, textAttr: NSMutableAttributedString) -> Any? {
        var indexSub = index
        if indexSub > self.count || self.count == 0 {
            return nil
        }
        if self.count > 0 && indexSub == self.count {indexSub = indexSub - 1}
        return textAttr.attribute(NSAttributedString.Key.foregroundColor, at: indexSub, effectiveRange: nil)
    }
    
    func rich_moresubStr(_ subStr: String,_ subFont: CGFloat,_ subColor: String) -> NSAttributedString {
        let attr = NSMutableAttributedString.init(string: self)
       
//        for subStr in subStrs {
            if self.contains(subStr) {
                let commpentArr = self.components(separatedBy: subStr)
                BSLog(commpentArr)
                var location = 0
                for index in 0..<commpentArr.count {
                    let str = commpentArr[index]
                    location = location + (index > 0 ? (str.count + subStr.count) : str.count)
                    attr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location: location, length: subStr.count))
                    
                }
                
            }
//        }
        return attr
    }
    
    func nsRange(from range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }
    func richText(_ subString: String, _ subFont: CGFloat, _ subColor: String = "A98054") -> NSAttributedString? {
        if self == "" {
            return nil
        }
        let attStr = NSMutableAttributedString.init(string: self)
        if let rangeSwift = self.range(of: subString) {
            let rangeOc = nsRange(from: rangeSwift)
            attStr.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: subFont),
                                  NSAttributedString.Key.foregroundColor: UIColor.colorWidthHexString(hex: subColor)], range: rangeOc)

        }
        return attStr
    }
    func rich_paragraph_text(lineSpace: CGFloat, kern: CGFloat?) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        paragraphStyle.alignment = .center
        let attStr = NSMutableAttributedString.init(string: self)
        if kern != nil {
            attStr.addAttribute(NSAttributedString.Key.kern, value: kern!, range: NSRange(location: 0, length: self.count))
        }
        attStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: self.count))

        return attStr
    }
    
    func heightString(font: UIFont, width: CGFloat) -> CGFloat {
        let stringSize = size(font, CGSize(width: width, height: CGFloat(HUGE)), NSLineBreakMode.byWordWrapping)
        return stringSize.height
    }
    
    func size(_ font: UIFont,_ size: CGSize,_ lineBreakMode: NSLineBreakMode) -> CGSize {
        
        let attr = NSMutableDictionary.init()
        attr[NSAttributedString.Key.font] = font
        if lineBreakMode != NSLineBreakMode.byWordWrapping {
            let paragraphStyle = NSMutableParagraphStyle.init()
            paragraphStyle.lineBreakMode = lineBreakMode
            attr[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        }
        let rect = (self as NSString).boundingRect(with: size, options: [NSStringDrawingOptions.usesLineFragmentOrigin,NSStringDrawingOptions.usesFontLeading], attributes: attr as? [NSAttributedString.Key : Any], context: nil)
        
        return rect.size
    }
}
