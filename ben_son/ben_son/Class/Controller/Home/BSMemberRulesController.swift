//
//  BSMemberRulesController.swift
//  ben_son
//
//  Created by ZS on 2018/10/24.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit

class BSMemberRulesController: BSBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    override func setupUI() {
        super.setupUI()
        title = "会员规则"
        view.addSubview(labelTitle)
        let str = "• 会员的级别不根据线下消费积累升级\n\n• 用户一次性线下充值 30万 可成为 金卡会员\n\n• 用户一次性线下充值 60万 可成为 黑卡会员\n\n详细可咨询本森客服"
//        labelTitle.attributedText = str.rich_moresubStr("30万", 15, "000000")
        labelTitle.attributedText = str.rich_subStr(["30万","60万"])
        view.addConstraint(NSLayoutConstraint(item: labelTitle, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: kSpacing))
        view.addConstraint(NSLayoutConstraint(item: labelTitle, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: kSpacing))
        view.addConstraint(NSLayoutConstraint(item: labelTitle, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1.0, constant: kSpacing))
//        labelTitle.addConstraint(NSLayoutConstraint(item: labelTitle, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1.0, constant: 100))
        
        
    }
    
    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.colorWidthHexString(hex: "BFBFBF")
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
}
