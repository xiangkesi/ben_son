//
//  UIbutton+Extension.swift
//  sinaSwift
//
//  Created by ZS on 2018/4/27.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit

@objc public enum ImagePositionType: Int{
    
    case left //图片在左,标题在右,默认
    
    case right // 图片在右,标题在左
    
    case top //图片在上,标题在下
    
    case bottom //图片在下,标题在上
    
}

@objc public enum BtnEdgeInsetsType: Int{
    case title //标题
    
    case image // 图片
}

@objc public enum BtnMarginType: Int{
    case top
    
    case bottom
    
    case left
    
    case right
    
    case topLeft
    
    case topRight
    
    case bottomLeft
    
    case bottomRight
}
extension UIButton{
    
    
    /// button文字图片排版
    ///
    /// - Parameters:
    ///   - type: 位置类型
    ///   - spacing: 间距
        @objc func zs_setImagePositionType(type: ImagePositionType, spacing:CGFloat = 2) -> () {
        guard let text = titleLabel?.text, let imageSize = image(for: .normal)?.size else {
            return
        }
        
        
            let titleSize = (text as NSString).size(withAttributes: [NSAttributedString.Key.font:  titleLabel?.font ?? UIFont.systemFont(ofSize: 15)])
        
//        let titleSizes = text.boundin
        
        
        switch type {
        case .left:
            titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
            break
        case .right:
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: 0, right: imageSize.width + spacing)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: titleSize.width + spacing, bottom: 0, right: -titleSize.width)
            break
        case .top:
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0)
            imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
            break
        default:
            titleEdgeInsets = UIEdgeInsets(top: -(imageSize.height + spacing), left: -imageSize.width, bottom: 0, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -(titleSize.height + spacing), right: -titleSize.width)
            break
        }
    }
    
    /// 只是图片和文字显示的文字
    ///
    /// - Parameters:
    ///   - edgeInsetsType: 是图片还是文字
    ///   - marginType: 位置
    ///   - margin: 距离
    @objc func zs_setEdgeInsetsWithType(edgeInsetsType: BtnEdgeInsetsType, marginType: BtnMarginType, margin: CGFloat) -> () {
        var itemSize = CGSize()
        if edgeInsetsType == .image{
            guard let imageSize = image(for: .normal)?.size else{
                return
            }
            itemSize = imageSize
        }else{
            guard let text = titleLabel?.text else{
                return
            }
           itemSize = (text as NSString).size(withAttributes: [.font:  titleLabel?.font ?? UIFont.systemFont(ofSize: 15)])
        }
        
        let horizontalDelta = (bounds.size.width - itemSize.width) * 0.5 - margin
        let vertivalDelta = ((bounds.size.height) - itemSize.height) * 0.5 - margin
        
        var horizontalSignFlag = 1
        var verticalSignFlag = 1
        
        switch marginType {
        case .top:
            horizontalSignFlag = 0
            verticalSignFlag = -1
            break
        case .bottom:
            horizontalSignFlag = 0
            verticalSignFlag = 1
            break
        case .left:
            horizontalSignFlag = -1
            verticalSignFlag = 0
            break
        case .right:
            horizontalSignFlag = 1
            verticalSignFlag = 0
            break
        case .topLeft:
            horizontalSignFlag = -1
            verticalSignFlag = -1
            break
        case .topRight:
            horizontalSignFlag = 1
            verticalSignFlag = -1
            break
        case .bottomLeft:
            horizontalSignFlag = -1
            verticalSignFlag = 1
            break
        default:
            horizontalSignFlag = 1
            verticalSignFlag = 1
            break
        }
        
        let edgeInsets = UIEdgeInsets(top: vertivalDelta * CGFloat(verticalSignFlag), left: horizontalDelta * CGFloat(horizontalSignFlag),  bottom: -(vertivalDelta * CGFloat(verticalSignFlag)), right: -(horizontalDelta * CGFloat(horizontalSignFlag)))
        if edgeInsetsType == .title {
            titleEdgeInsets = edgeInsets
        }else{
            imageEdgeInsets = edgeInsets
        }
        
        
    }
    
    public func zs_setAttribute(_ fontSize: CGFloat = 0.0,
                                _ imageName: String?,
                                _ backImageName: String?,
                                _ btnTitle: String?,
                                _ btnSIze: CGSize,
                                _ btnOrigin: CGPoint,
                                _ aligment: UIControl.ContentHorizontalAlignment?) {
        
        if fontSize != 0.0 {
            titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        }
        if imageName != nil {
            setImage(UIImage(named: imageName!), for: UIControl.State.normal)
        }
        if backImageName != nil {
            setBackgroundImage(UIImage(named: backImageName!), for: UIControl.State.normal)
        }
        setTitle(btnTitle, for: UIControl.State.normal)
        size = btnSIze
        origin = btnOrigin
        if aligment != nil {
            contentHorizontalAlignment = aligment!
        }
    }
    
}
