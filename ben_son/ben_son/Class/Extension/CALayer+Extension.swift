//
//  CALayer+Extension.swift
//  ben_son
//
//  Created by ZS on 2018/8/31.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit


extension CALayer {
    
    var left: CGFloat {
        get {
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
    
    public var center: CGPoint {
        get {
            return CGPoint(x: frame.origin.x + frame.size.width * 0.5, y: frame.origin.y + frame.size.height * 0.5)
        }
        
        set {
            var f = frame
            f.origin.x = newValue.x - f.size.width * 0.5
            f.origin.y = newValue.y - f.size.height * 0.5
            frame = f
        }
    }
    
    public var centerX: CGFloat {
        get {
            
            return frame.origin.x + frame.size.width
        }
        
        set {
            var f = frame
            f.origin.x = newValue - f.size.width * 0.5
            frame = f
        }
    }
    
    public var centerY: CGFloat {
        get{
            return frame.origin.y + frame.size.height
        }
        
        set {
            var f = frame
            f.origin.y = newValue - f.size.height * 0.5
            frame = f
        }
    }
    
    public var origin: CGPoint {
        get {
            return frame.origin
        }
        
        set {
            var f = frame
            f.origin = newValue
            frame = f
            
        }
    }
    
    public var frameSize: CGSize {
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
