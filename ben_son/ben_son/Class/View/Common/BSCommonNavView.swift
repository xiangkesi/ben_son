//
//  BSCommonNavView.swift
//  ben_son
//
//  Created by ZS on 2018/9/20.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit

class BSCommonNavView: UIView {

    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: UIDevice.current.navigationBarHeight())
        super.init(frame: selfFrame)
        
        addSubview(buttonBack)
        addSubview(labelTitle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var buttonBack: UIButton = {
        let location = UIButton.init()
        location.size = CGSize(width: 60, height: 30)
        location.origin = CGPoint(x: 15, y: UIDevice.current.isX() ? 51 : 27)
        location.setImage(UIImage(named: "common_back"), for: UIControl.State.normal)
        location.setImage(UIImage(named: "common_back"), for: UIControl.State.highlighted)
        location.contentHorizontalAlignment = .left
        return location
    }()
    
    private lazy var labelTitle: UILabel = {
        let desc = UILabel.init()
        desc.font = UIFont.init(name: "PingFangSC-Semibold", size: 18)
        desc.textColor = UIColor.white
        desc.size = CGSize(width: 200, height: 30)
        desc.origin = CGPoint(x: kScreenWidth * 0.5 - 100, y: buttonBack.top)
        desc.layer.masksToBounds = true
        desc.textAlignment = .center
        desc.text = "联系我们"
        return desc
    }()
    
    
    
}
