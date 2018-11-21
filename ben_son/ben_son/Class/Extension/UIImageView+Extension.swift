//
//  UIImageView+Extension.swift
//  ben_son
//
//  Created by ZS on 2018/8/28.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    public func zs_setImage(urlString: String?, placerHolder: UIImage?) {
        if urlString == nil {
            return
        }
        let ur = urlString!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: ur!) else {
            image = placerHolder
            return
        }
        kf.setImage(with: ImageResource(downloadURL: url), placeholder: placerHolder, options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    public func zs_setAttribute(_ sizeView: CGSize,_ originView: CGPoint,_ imageName: String?,_ model: UIView.ContentMode?) {
        size = sizeView
        origin = originView
        if imageName != nil {
            image = UIImage(named: imageName!)
        }
        if model != nil {
            contentMode = model!
        }
    }
}
