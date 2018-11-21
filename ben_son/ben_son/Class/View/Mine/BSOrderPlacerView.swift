//
//  BSOrderPlacerView.swift
//  ben_son
//
//  Created by ZS on 2018/11/5.
//  Copyright © 2018 ZS. All rights reserved.
//

import UIKit

enum BSOrderPlacerType: Int {
    case orderPlacerTypeOrder
    
    case orderPlacerTypeOther
}
class BSOrderPlacerView: UIView {
    
    func showType(_ type: BSOrderPlacerType ,_ finish: Bool,_ count: Int) {
        if finish {
            if count == 0 {
                self.isHidden = false
                imageView.image = UIImage(named: "order_nomore_data")
                labelTitle.text = (type == BSOrderPlacerType.orderPlacerTypeOrder ? "暂无订单，快去车库逛逛吧O(∩_∩)O~~" : "暂无收藏,赶快去收藏一下吧O(∩_∩)O~~")
            }else{
                self.isHidden = true
            }
        }else{
            self.isHidden = false
            imageView.image = UIImage(named: "net_error")
            labelTitle.text = "网络连接失败,请下拉重试"
        }
    }
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: UIDevice.current.contentNoTabBarHeight() - 50)
        
        super.init(frame: selfFrame)
        isHidden = true
        addSubview(imageView)
        addSubview(labelTitle)
    }
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.size = CGSize(width: 150, height: 150)
        image.origin = CGPoint(x: (width - 150) * 0.5, y: kScreenWidth * 0.4)
        return image
    }()
    
    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.origin = CGPoint(x: kSpacing, y: imageView.bottom + 15)
        label.size = CGSize(width: kContentWidth, height: 20)
        label.textColor = kMainColor
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
