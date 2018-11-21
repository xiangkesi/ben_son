//
//  BSSearchView.swift
//  ben_son
//
//  Created by ZS on 2018/10/18.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit

class BSSearchView: UIView {

    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: UIDevice.current.contentNoTabBarHeight())
        super.init(frame: selfFrame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableViewCarList: UITableView = {
        let carList = UITableView.init(frame: frame, style: UITableView.Style.plain)
        
        return carList
    }()
    
}
