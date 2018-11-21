//
//  BSChoosePayHeadView.swift
//  ben_son
//
//  Created by ZS on 2018/10/29.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit

class BSChoosePayHeadView: UIView {

    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 190)
        
        super.init(frame: selfFrame)
        
        addSubview(labelCarModel)
        addSubview(labelCarDesc)
        addSubview(labelCarColor)
        addSubview(colorLine)
        addSubview(labelReceiveAddress)
        addSubview(labelAddressSesc)
        addSubview(labelName)
        addSubview(labelNameDesc)
        addSubview(labelPhone)
        addSubview(labelPhoneDesc)
        
        addBottomLine(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), UIColor.colorWidthHexString(hex: "1A1A1A"), 10)
    }
    
    private lazy var labelCarModel: UILabel = {
        let label = UILabel()
        label.setupAttribute(15,
                             nil,
                             "A98054",
                             CGSize(width: 50, height: 20),
                             CGPoint(x: kSpacing, y: 20))
        label.text = "车型:"
        return label
    }()
    
    lazy var labelCarDesc: UILabel = {
        let label = UILabel()
        label.setupAttribute(15,
                             nil,
                             "A98054",
                             CGSize(width: kContentWidth - 60, height: 20),
                             CGPoint(x: labelCarModel.right + 10, y: labelCarModel.top))
        label.text = "法拉利-F12"
        label.textAlignment = .right
        return label
    }()
    
    private lazy var labelCarColor: UILabel = {
        let label = UILabel()
        label.setupAttribute(15,
                             nil,
                             "A98054",
                             CGSize(width: 50, height: 20),
                             CGPoint(x: kSpacing, y: labelCarModel.bottom + 10))
        label.text = "颜色: "
        return label
    }()
    lazy var colorLine: UIView = {
        let line = UIView()
        line.origin = CGPoint(x: kScreenWidth - 35, y: labelCarColor.top)
        line.size = CGSize(width: 20, height: 20)
        line.zs_corner()
        return line
    }()
    
    private lazy var labelReceiveAddress: UILabel = {
        let label = UILabel()
        label.setupAttribute(15,
                             nil,
                             "A98054",
                             CGSize(width: 80, height: 20),
                             CGPoint(x: kSpacing, y: labelCarColor.bottom + 10))
        label.text = "收货地址:"
        return label
    }()
    
    lazy var labelAddressSesc: UILabel = {
        let label = UILabel()
        label.setupAttribute(15,
                             nil,
                             "A98054",
                             CGSize(width: kContentWidth - 90, height: 20),
                             CGPoint(x: labelReceiveAddress.right + 10, y: labelReceiveAddress.top))
        label.text = "上海市徐汇区广元西路帝逸阁"
        label.textAlignment = .right
        return label
    }()
    
    private lazy var labelName: UILabel = {
        let label = UILabel()
        label.setupAttribute(15,
                             nil,
                             "A98054",
                             CGSize(width: 50, height: 20),
                             CGPoint(x: kSpacing, y: labelReceiveAddress.bottom + 10))
        label.text = "姓名:"
        return label
    }()
    lazy var labelNameDesc: UILabel = {
        let label = UILabel()
        label.setupAttribute(15,
                             nil,
                             "A98054",
                             CGSize(width: kContentWidth - 60, height: 20),
                             CGPoint(x: labelName.right + 10, y: labelName.top))
        label.text = "王力宏"
        label.textAlignment = .right

        return label
    }()
    private lazy var labelPhone: UILabel = {
        let label = UILabel()
        label.setupAttribute(15,
                             nil,
                             "A98054",
                             CGSize(width: 80, height: 20),
                             CGPoint(x: kSpacing, y: labelName.bottom + 10))
        label.text = "联系电话:"
        return label
    }()
    
    lazy var labelPhoneDesc: UILabel = {
        let label = UILabel()
        label.setupAttribute(15,
                             nil,
                             "A98054",
                             CGSize(width: kContentWidth - 90, height: 20),
                             CGPoint(x: labelPhone.right + 10, y: labelPhone.top))
        label.text = "17602177967"
        label.textAlignment = .right
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class BSPayOrderChooseCell: BSCommentCell {
    
    override func setupUI() {
        super.setupUI()
        contentView.addSubview(imageIconView)
        contentView.addSubview(labelType)
        contentView.addSubview(imageIconChooseView)
        line.top = 61.5
        contentView.layer.addSublayer(line)
    }
    
    var model: BSChoosePayModel? {
        didSet{
            imageIconView.image = UIImage(named: (model?.imageName)!)
            labelType.text = model?.title
            imageIconChooseView.image = UIImage(named: (model?.isSelected)! ? "pay_selected" : "pay_unselected")
        }
    }
    
    
    private lazy var imageIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.zs_setAttribute(CGSize(width: 32, height: 32),
                                  CGPoint(x: kSpacing, y: kSpacing),
                                  nil,
                                  nil)
        return imageView
    }()
    
    private lazy var labelType: UILabel = {
        let label = UILabel()
        label.setupAttribute(15,
                             nil,
                             "BFBFBF",
                             CGSize(width: kContentWidth - 52, height: 20),
                             CGPoint(x: imageIconView.right + 20, y: 21))
        return label
    }()
    
    
    private lazy var imageIconChooseView: UIImageView = {
        let imageView = UIImageView()
        imageView.zs_setAttribute(CGSize(width: 20, height: 20),
                                  CGPoint(x: kScreenWidth - 35, y: 21),
                                  nil,
                                  nil)
        return imageView
    }()
}
