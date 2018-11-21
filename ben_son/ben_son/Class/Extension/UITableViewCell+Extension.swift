//
//  UITableViewCell+Extension.swift
//  ben_son
//
//  Created by ZS on 2018/11/14.
//  Copyright © 2018 ZS. All rights reserved.
//

import Foundation


private var isAnimation: Bool = false


enum UITableViewCellDisplayAnimationStyle: Int {
    case top = 0
    case left = 1
    case bottom = 2
    case right = 3
    case topTogether = 4
    case leftTogether = 5
    case bottomTogether = 6
    case rightTogether = 7
    case fadeIn = 8
    case fadeInTogether = 9
    case other = 10
}

extension UITableViewCell {
    
    var animation: Bool? {
        get {
            return objc_getAssociatedObject(self, &isAnimation) as? Bool
        }
        set(newValue) {
            objc_setAssociatedObject(self, &isAnimation, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func tableView(_ tableView: UITableView,_ indexPath: IndexPath,_ animationStyle: UITableViewCellDisplayAnimationStyle) {
        
        if animation == nil || !animation! {
            
            let originFrame = frame
            var duration: Double = 0.0

            switch animationStyle {
            case UITableViewCellDisplayAnimationStyle.top:
                top = -height
                duration = 0.5 + TimeInterval(indexPath.row) / 10.0
                break
            case UITableViewCellDisplayAnimationStyle.left:
                left = -width
                duration = 0.5 + TimeInterval(indexPath.row) / 10.0
                break
            case UITableViewCellDisplayAnimationStyle.bottom:
                top = tableView.height
                duration = 0.5 + TimeInterval(indexPath.row) / 10.0
                break
            case UITableViewCellDisplayAnimationStyle.right:
                left = tableView.width
                duration = 0.5 + TimeInterval(indexPath.row) / 10.0
                break
            case UITableViewCellDisplayAnimationStyle.topTogether:
                top = -height
                duration = 0.5
                break
            case UITableViewCellDisplayAnimationStyle.leftTogether:
                left = -width
                duration = 0.5
                break
            case UITableViewCellDisplayAnimationStyle.bottomTogether:
                top = tableView.height
                duration = 0.5
                break
            case UITableViewCellDisplayAnimationStyle.rightTogether:
                left = tableView.width
                duration = 0.5
                break
            case UITableViewCellDisplayAnimationStyle.fadeIn:
                alpha = 0
                duration = 0.5 + TimeInterval(indexPath.row) / 10.0
                break
            case UITableViewCellDisplayAnimationStyle.fadeInTogether:
                alpha = 0
                duration = 0.5
                break
            default:
                break
            }

            if animationStyle == .fadeIn || animationStyle == .fadeInTogether {
                UIView.animate(withDuration: duration, animations: {
                    self.alpha = 1.0
                }, completion: nil)
            }else {
                UIView.animate(withDuration: duration, animations: {
                    self.frame = originFrame
                }, completion: nil)
            }
            animation = true
        }
        
        
    }
}
