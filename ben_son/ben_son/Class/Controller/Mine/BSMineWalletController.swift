//
//  BSMineWalletController.swift
//  ben_son
//
//  Created by ZS on 2018/10/25.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit

class BSMineWalletController: BSBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    var score: Int? {
        didSet {
            labelTitle.text = String(score ?? 0)
        }
    }
    
    override func setupUI() {
        super.setupUI()
        title = "我的钱包"
        view.addSubview(labelTitle)
        view.addSubview(labelDesc)
        view.addSubview(labelOther)
    }
    
    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.setupAttribute(32,
                             "ArialMT",
                             "A98054",
                             CGSize(width: kScreenWidth, height: 40),
                             CGPoint(x: 0, y: 50))
        label.textAlignment = .center
        return label
    }()
    
    private lazy var labelDesc: UILabel = {
        let label = UILabel()
        label.setupAttribute(15,
                             nil,
                             "53402F",
                             CGSize(width: kScreenWidth , height: 20),
                             CGPoint(x: 0, y: labelTitle.bottom + 6))
        label.text = "账户余额(元)"
        label.textAlignment = .center
        return label
    }()

    private lazy var labelOther: UILabel = {
        let label = UILabel()
        label.setupAttribute(15,
                             nil,
                             "5C5C5C",
                             CGSize(width: kScreenWidth - 80 , height: 100),
                             CGPoint(x: 40, y: UIDevice.current.contentNoTabBarHeight() - 150))
        label.text = "温馨提示: 此余额不参与任何线上交易,仅供参考,如果对余额有意义请拨打线下热线  400643099  咨询"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
}
