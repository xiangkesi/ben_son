//
//  UIView+Extension.swift
//  ben_son
//
//  Created by ZS on 2018/8/28.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit

extension UIView {
    
    
    @objc func zs_corner() {
        let maskPath = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: bounds.size)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
    @objc func zs_cutCorner(sizeHeigt: CGSize) {
        let maskPath = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: sizeHeigt)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
    @objc func zs_cutCornerDirection(sizeHeigt: CGSize, corners: UIRectCorner) {
        
        let maskPath = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: sizeHeigt)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
    func zs_cutCornerAndBorder(sizeHeigt: CGSize, boderColor: UIColor, boderWidth: CGFloat = 1) {
//
//        let layerPath = CAShapeLayer.init()
//        layerPath.frame = CGRect(x: 0, y: 0, width: sizeHeigt.width, height: sizeHeigt.height)
//
        
        let borderLayer = CAShapeLayer.init()
        borderLayer.frame = CGRect(x: 0, y: 0, width: sizeHeigt.width, height: sizeHeigt.height)
        borderLayer.lineWidth = boderWidth
        borderLayer.strokeColor = boderColor.cgColor
        borderLayer.fillColor = backgroundColor?.cgColor
        
        let maskPath = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: sizeHeigt)
//        layerPath.path = maskPath.cgPath
        borderLayer.path = maskPath.cgPath
        
        layer.addSublayer(borderLayer)
//        layerPath.path = maskPath.cgPath
//        layer.borderWidth = boderWidth
//        layerPath.lineCap = CAShapeLayerLineCap.round
//        layerPath.strokeColor = boderColor.cgColor
//        layerPath.fillColor = backgroundColor?.cgColor
//        layer.addSublayer(layerPath)
        
    }
    
    func zs_setBorder(boderColor: UIColor = kMainColor, boderWidth: CGFloat = 1) {
        let borderLayer = CAShapeLayer.init()
        borderLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        borderLayer.lineWidth = boderWidth
        borderLayer.strokeColor = boderColor.cgColor
        borderLayer.fillColor = backgroundColor?.cgColor
        
        let maskPath = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 0, height: 0))
        borderLayer.path = maskPath.cgPath
        layer.insertSublayer(borderLayer, at: 0)
//        layer.addSublayer(borderLayer)
    }
    
    func addBottomLine(_ edgeInsets: UIEdgeInsets,_ lineColor: UIColor = UIColor.colorWidthHexString(hex: "322A21"),_ lineHeight: CGFloat = 0.5) {
        
        let lineBottom = CALayer()
        lineBottom.backgroundColor = lineColor.cgColor
        lineBottom.left = edgeInsets.left
        lineBottom.height = lineHeight
        lineBottom.top = height - lineHeight
        lineBottom.width = width - edgeInsets.left - edgeInsets.right
        layer.addSublayer(lineBottom)
        
    }
    
    func addTopLine(edgeInsets: UIEdgeInsets,lineColor: UIColor = UIColor.colorWidthHexString(hex: "322A21"), lineHeight: CGFloat = 0.5) {
//        UIEdgeInsets(top: <#T##CGFloat#>, left: <#T##CGFloat#>, bottom: <#T##CGFloat#>, right: <#T##CGFloat#>)
        let lineBottom = CALayer()
        lineBottom.left = edgeInsets.left
        lineBottom.height = lineHeight
        lineBottom.top = 0
        lineBottom.width = width - edgeInsets.left - edgeInsets.right
        layer.addSublayer(lineBottom)
    }
    
    func addLeftLine(edgeInsets: UIEdgeInsets,lineColor: UIColor = UIColor.colorWidthHexString(hex: "322A21"), lineWidth: CGFloat = 0.5) {
        let lineBottom = CALayer()
        lineBottom.left = edgeInsets.left
        lineBottom.height = lineWidth
        lineBottom.top = 0
        lineBottom.height = height - edgeInsets.top - edgeInsets.bottom
        layer.addSublayer(lineBottom)
    }
    
    
    
    
    
    
    public var left: CGFloat {
        get{
            return frame.origin.x
        }
        
        set {
            var f = frame
            f.origin.x = newValue
            frame = f
        }
    }
    
    public var top: CGFloat {
        get {
            return frame.origin.y
        }
        
        set {
            var f = frame
            f.origin.y = newValue
            frame = f
        }
    }
    
    public var right: CGFloat {
        get {
            return frame.origin.x + frame.size.width
        }
        
        set {
            var f = frame
            f.origin.x = newValue - f.size.width
            frame = f
        }
    }
    
    public var bottom: CGFloat {
        get {
            return frame.origin.y + frame.size.height
        }
        
        set {
            var f = frame
            f.origin.y = newValue - f.size.height
            frame = f
        }
    }
    
    public var width: CGFloat {
        get {
            return frame.size.width
        }
        
        set {
            var f = frame
            f.size.width = newValue
            frame = f
        }
    }
    
    public var height: CGFloat {
        get {
            return frame.size.height
        }
        
        set {
            var f = frame
            f.size.height = newValue
            frame = f
            
        }
    }
    
    var centerX: CGFloat {
        get {
            return frame.origin.x + frame.size.width
        }
        
        set {
            center = CGPoint(x:newValue , y: center.y)
        }
    }
    
    var centerY: CGFloat {
        get {
            return center.y
        }
        
        set {
            center = CGPoint(x: center.x, y: newValue)
        }
    }
    
    var origin: CGPoint {
        get {
            return frame.origin
        }
        
        set {
            var f = frame
            f.origin = newValue
            frame = f
        }
    }
    
    var size: CGSize {
        get {
            return frame.size
        }
        
        set {
            var f = frame
            f.size = newValue
            frame = f
        }
    }
    
    
    
    
}
