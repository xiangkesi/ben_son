//
//  StayTunedController.swift
//  ben_son
//
//  Created by ZS on 2018/11/19.
//  Copyright © 2018 ZS. All rights reserved.
//

import UIKit

class StayTunedController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = kMainBackBgColor
        title = "敬请期待"
        view.addSubview(imageIconView)
        view.addSubview(labelTitle)
        // Do any additional setup after loading the view.
    }
    
    private lazy var imageIconView: UIImageView = {
        let iconView = UIImageView()
        iconView.image = UIImage(named: "coming_soon")
        iconView.size = CGSize(width: 200, height: 200)
        iconView.top = 100
        iconView.left = view.width * 0.5 - 100
        return iconView
    }()
    
    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.top = imageIconView.bottom
        label.size = CGSize(width: kContentWidth, height: 20)
        label.left = kSpacing
        label.textColor = kMainColor
        label.text = "程序员MM正在努力开发中..."
        return label
    }()
}
