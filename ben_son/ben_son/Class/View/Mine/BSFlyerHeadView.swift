//
//  BSFlyerHeadView.swift
//  ben_son
//
//  Created by ZS on 2018/10/25.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift

class BSFlyerHeadView: UIView {

    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth * 0.7)
        super.init(frame: selfFrame)
        
        addSubview(headImageView)
        addSubview(viewBottom)
        addSubview(labelDesc)
        addSubview(labelTitle)
    }
    
    private lazy var headImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.zs_setAttribute(size,
                                  origin,
                                  "flyer_head_image",
                                  UIView.ContentMode.scaleAspectFill)
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.setupAttribute(32,
                             "ArialMT",
                             "A98054",
                             CGSize(width: width, height: 40),
                             CGPoint(x: 0, y: labelDesc.top - 45))
        label.textAlignment = .center
        return label
    }()
    
    private lazy var labelDesc: UILabel = {
        let label = UILabel()
        label.setupAttribute(15,
                             nil,
                             "A98054",
                             CGSize(width: width, height: 20),
                             CGPoint(x: 0, y: viewBottom.top - 70))
        label.text = "当前里程"
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var viewBottom: UIView = {
        let bg = UIView()
        bg.origin = CGPoint(x: 0, y: height - 57)
        bg.size = CGSize(width: kScreenWidth, height: 57)
        bg.backgroundColor = UIColor.colorWidthHexString(hex: "202020")
        bg.addBottomLine(UIEdgeInsets(top: 0, left: kSpacing, bottom: 0, right: kSpacing), UIColor.colorWidthHexString(hex: line_color), 0.5)
        let label = UILabel()
        label.setupAttribute(18, "PingFangSC-Semibold", "FFFFFF", CGSize(width: 200, height: 27), CGPoint(x: kSpacing, y: kSpacing))
        label.text = "里程明细"
        bg.addSubview(label)
        return bg
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class BSFlyerNavView: UIView {
    
    let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: UIDevice.current.navigationBarHeight())
        super.init(frame: selfFrame)
        
        addSubview(btnBack)
        addSubview(btnRules)
    }
    
    lazy var btnBack: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.zs_setAttribute(0.0,
                            "common_back",
                            nil,
                            nil,
                            CGSize(width: 60, height: 30),
                            CGPoint(x: 10, y: UIDevice.current.navigationSubviewY()),
                            UIControl.ContentHorizontalAlignment.left)
        return btn
    }()
    
    lazy var btnRules: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.zs_setAttribute(18,
                            nil,
                            nil,
                            "积分规则",
                            CGSize(width: 80, height: 30),
                            CGPoint(x: width - 95, y: UIDevice.current.navigationSubviewY()),
                            UIControl.ContentHorizontalAlignment.right)
        return btn
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BSFlyerCell: BSCommentCell {
    
    override func setupUI() {
        super.setupUI()
        contentView.backgroundColor = UIColor.colorWidthHexString(hex: "202020")
        contentView.addSubview(labelTime)
        contentView.addSubview(labelName)
        contentView.addSubview(labelType)
        contentView.addSubview(labelSource)
        
        line.top = 74.5
        contentView.layer.addSublayer(line)
    }
    
    var list: BSFlyerListModel? {
        didSet {
            labelTime.text = list?.created_at
            labelName.text = list?.remark
            labelType.text = list?.type == 1 ? "线下充值" : "线上消费"
            labelSource.text = list?.type == 1 ? ("+" + String(list?.money ?? 0)) : ("-" + String(list?.money ?? 0))
        }
    }
    
    
    private lazy var labelTime: UILabel = {
        let label = UILabel()
        label.setupAttribute(13,
                             nil,
                             "5C5C5C",
                             CGSize(width: 200, height: 16),
                             CGPoint(x: kSpacing, y: kSpacing))
        label.text = "2018-9-11"
        return label
    }()
    
    private lazy var labelName: UILabel = {
        let label = UILabel()
        label.setupAttribute(15,
                             nil,
                             "FFFFFF",
                             CGSize(width: kScreenWidth - 150, height: 22),
                             CGPoint(x: kSpacing, y: labelTime.bottom + 6))
        label.text = "2017款 iPhone X 64G 天空灰…"
        return label
    }()
    
    private lazy var labelType: UILabel = {
        let label = UILabel()
        label.setupAttribute(13,
                             nil,
                             "A98054",
                             CGSize(width: 100, height: 16),
                             CGPoint(x: kScreenWidth - 115, y: kSpacing))
        label.text = "线下充值"
        label.textAlignment = .right
        return label
    }()
    
    private lazy var labelSource: UILabel = {
        let label = UILabel()
        label.setupAttribute(15,
                             nil,
                             "A98054",
                             CGSize(width: 120, height: 22),
                             CGPoint(x: kScreenWidth - 135, y: labelType.bottom + 6))
        label.text = "+ 2,000里程"
        label.textAlignment = .right

        return label
    }()
}
