//
//  BSNoRxBaseController.swift
//  ben_son
//
//  Created by ZS on 2018/9/13.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit

class BSNoRxBaseController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.black
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.origin = CGPoint(x: 0, y: 0)
        tableView.size = CGSize(width: kScreenWidth, height: kScreenHeight - UIDevice.current.navigationBarHeight())
        return tableView
    }()
    
    deinit {
        print("\(self.classForCoder)销毁了")
    }
}

extension BSNoRxBaseController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
