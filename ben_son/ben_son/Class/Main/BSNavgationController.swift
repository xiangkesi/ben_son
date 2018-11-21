//
//  BSNavgationController.swift
//  ben_son
//
//  Created by ZS on 2018/8/28.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit

class BSNavgationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.tintColor = UIColor.colorWidthHexString(hex: "ffffff")
        navigationBar.barTintColor = UIColor.colorWidthHexString(hex: "202020")
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.colorWidthHexString(hex: "ffffff")]
        navigationBar.isTranslucent = false
        navigationBar.barStyle = .black
    }
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0 {
            let btnBack = UIButton(type: .custom)
            btnBack.setImage(UIImage(named: "common_back"), for: .normal)
            btnBack.setImage(UIImage(named: "common_back"), for: .selected)
            btnBack.bounds.size = CGSize(width: 50, height: 30)
            btnBack.contentHorizontalAlignment = .left
            btnBack.imageView?.isUserInteractionEnabled = false
            btnBack.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            btnBack.addTarget(self, action: #selector(backPop), for: .touchUpInside)
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)

    }
    
    @objc func backPop() {
        popViewController(animated: true)
    }
}
