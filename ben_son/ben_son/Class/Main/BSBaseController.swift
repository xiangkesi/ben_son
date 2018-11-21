//
//  BSBaseController.swift
//  ben_son
//
//  Created by ZS on 2018/8/28.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit

class BSBaseController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.colorWidthHexString(hex: "141414")
    }
    
    lazy var tableViewPlainCommon: UITableView = {
        let tableView = UITableView.init(frame: CGRect(), style: .plain)
        tableView.separatorStyle = .none
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
            tableView.estimatedRowHeight = 0;
            tableView.estimatedSectionFooterHeight = 0;
            tableView.estimatedSectionHeaderHeight = 0;
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        tableView.origin = CGPoint(x: 0, y: 0)
        tableView.size = CGSize(width: kScreenWidth, height: kScreenHeight - UIDevice.current.navigationBarHeight())
        tableView.backgroundColor = UIColor.colorWidthHexString(hex: "141414")
        return tableView
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    deinit {
        print("\(self.classForCoder)销毁了")
    }

}

extension BSBaseController {

}
