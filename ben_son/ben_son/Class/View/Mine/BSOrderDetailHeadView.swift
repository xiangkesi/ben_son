//
//  BSOrderDetailHeadView.swift
//  ben_son
//
//  Created by ZS on 2018/11/9.
//  Copyright © 2018 ZS. All rights reserved.
//

import UIKit

class BSOrderDetailHeadView: UIView {

    
    override init(frame: CGRect) {
        
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 261)
        
        super.init(frame: selfFrame)
        
        setupUI()
    }
    
    var order: BSOrderModel? {
        didSet {
            imageIconView.zs_setImage(urlString: order?.car_cover, placerHolder: image_placholder)
            labelBrandName.text = order?.brand_name
            labelModelName.text = order?.car_model
            labelPrace.text = order?.pay_price
            labelLeftAddress.attributedText = order?.remove_address_attstr
            labelRightAddress.attributedText = order?.return_address_attstr
            labelDayCount.text = String(order?.days ?? 0) + "天"
            labelOrderStatus.text = order?.pay_type
        }
    }
    
    
    private lazy var viewBg: UIView = {
        let bg = UIView()
        bg.origin = CGPoint(x: 0, y: 0)
        bg.size = CGSize(width: kScreenWidth, height: 100)
        bg.backgroundColor = kMainBackBgColor
        bg.addBottomLine(UIEdgeInsets(top: 0, left: kSpacing, bottom: 0, right: kSpacing), UIColor.colorWidthHexString(hex: "322A21"), 0.5)
        return bg
    }()
    
    private lazy var imageIconView: UIImageView = {
        let iconView = UIImageView()
        iconView.origin = CGPoint(x: kSpacing, y: kSpacing)
        iconView.height = viewBg.height - 30
        iconView.width = iconView.height * 1.6
        return iconView
    }()
    
    private lazy var labelOrderStatus: UILabel = {
        let status = UILabel()
        status.top = imageIconView.top
        status.size = CGSize(width: 50, height: 22)
        status.left = viewBg.width - status.width - kSpacing
        status.font = UIFont.systemFont(ofSize: 16)
        status.textColor = kMainColor
        return status
    }()
    
    private lazy var labelBrandName: UILabel = {
        let status = UILabel()
        status.top = imageIconView.top
        status.size = CGSize(width: viewBg.width - imageIconView.right - 75, height: 22)
        status.left = imageIconView.right + 10
        status.font = UIFont.systemFont(ofSize: 16)
        status.textColor = UIColor.colorWidthHexString(hex: "BFBFBF")
        return status
    }()
    
    private lazy var labelModelName: UILabel = {
        let status = UILabel()
        status.top = labelBrandName.bottom + 4
        status.size = CGSize(width: viewBg.width - imageIconView.right - 25, height: 16)
        status.left = imageIconView.right + 10
        status.font = UIFont.systemFont(ofSize: 13)
        status.textColor = UIColor.colorWidthHexString(hex: "5C5C5C")
        return status
    }()
    
    private lazy var labelPrace: UILabel = {
        let prace = UILabel()
        prace.setupAttribute(15,
                             nil,
                             "A98054",
                             CGSize(width: 180, height: 20),
                             CGPoint(x: imageIconView.right + 10, y: labelModelName.bottom + 4))
        return prace
    }()
    
    private lazy var viewAddressBg: UIView = {
        let bg = UIView()
        bg.origin = CGPoint(x: 0, y: viewBg.bottom)
        bg.size = CGSize(width: kScreenWidth, height: 75)
        bg.backgroundColor = kMainBackBgColor
        bg.addBottomLine(UIEdgeInsets(top: 0, left: kSpacing, bottom: 0, right: kSpacing), UIColor.colorWidthHexString(hex: "322A21"), 0.5)
        return bg
    }()
    
    private lazy var imageArrowView: UIImageView = {
        let arrowView = UIImageView()
        arrowView.size = CGSize(width: 80, height: 6)
        arrowView.left = labelLeftAddress.right + 20
        arrowView.top = (viewAddressBg.height) * 0.5
        arrowView.image = UIImage(named: "reservation_timelength")
        return arrowView
    }()
    
    private lazy var labelDayCount: UILabel = {
        let status = UILabel()
        status.top = imageArrowView.top - 20
        status.left = imageArrowView.left
        status.size = CGSize(width: imageArrowView.width, height: 20)
        status.font = UIFont.systemFont(ofSize: 13)
        status.textColor = UIColor.colorWidthHexString(hex: "5C5C5C")
        status.textAlignment = .center
        return status
    }()
    
    private lazy var labelLeftAddress: UILabel = {
        let l = UILabel()
        l.setupAttribute(13,
                         nil,
                         "5C5C5C",
                         CGSize(width: kScreenWidth * 0.5 - 75, height: 75),
                         CGPoint(x: kSpacing, y: 0))
        l.numberOfLines = 2
        return l
    }()
    
    private lazy var labelRightAddress: UILabel = {
        let l = UILabel()
        l.setupAttribute(13,
                         nil,
                         "5C5C5C",
                         labelLeftAddress.size,
                         CGPoint(x: imageArrowView.right + 20, y: 0))
        l.numberOfLines = 2
        return l
    }()
    
    
    
    private lazy var viewContactBg: UIView = {
        let bg = UIView()
        bg.size = CGSize(width: kScreenWidth, height: 50)
        bg.origin = CGPoint(x: 0, y: viewAddressBg.bottom)
        bg.backgroundColor = kMainBackBgColor
        return bg
    }()
    lazy var btnLeft: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "order_detail_kefu"), for: UIControl.State.normal)
        btn.setTitle("联系客服", for: UIControl.State.normal)
        btn.contentHorizontalAlignment = .left
        btn.setTitleColor(UIColor.colorWidthHexString(hex: "5C5C5C"), for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.size = CGSize(width: 100, height: 50)
        btn.left = 20
        btn.top = 0
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return btn
    }()
    lazy var btnRight: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "order_detail_call"), for: UIControl.State.normal)
        btn.setTitle("拨打电话", for: UIControl.State.normal)
        btn.setTitleColor(UIColor.colorWidthHexString(hex: "5C5C5C"), for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.contentHorizontalAlignment = .right
        btn.size = CGSize(width: 100, height: 50)
        btn.left = kScreenWidth - 120
        btn.top = 0
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return btn
    }()
    
    private lazy var viewBottomBg: UIView = {
        let bg = UIView()
        bg.backgroundColor = UIColor.colorWidthHexString(hex: "111111")
        bg.origin = CGPoint(x: 0, y: viewContactBg.bottom)
        bg.size = CGSize(width: kScreenWidth, height: 36)
        let label = UILabel()
        label.text = "取车信息"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.colorWidthHexString(hex: "444444")
        label.size = CGSize(width: 100, height: 36)
        label.origin = CGPoint(x: kSpacing, y: 0)
        bg.addSubview(label)
        return bg
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BSOrderDetailHeadView {
    
    private func setupUI() {
        addSubview(viewBg)
        viewBg.addSubview(imageIconView)
        viewBg.addSubview(labelOrderStatus)
        viewBg.addSubview(labelBrandName)
        viewBg.addSubview(labelModelName)
        viewBg.addSubview(labelPrace)
        
        addSubview(viewAddressBg)
        viewAddressBg.addSubview(labelLeftAddress)
        viewAddressBg.addSubview(imageArrowView)
        viewAddressBg.addSubview(labelDayCount)
        viewAddressBg.addSubview(labelRightAddress)
        
        
        addSubview(viewContactBg)
        viewContactBg.addSubview(btnLeft)
        viewContactBg.addSubview(btnRight)
        
        addSubview(viewBottomBg)
    }
}


class BSOrderDetailCell: BSCommentCell {
    
    override func setupUI() {
        super.setupUI()
        contentView.backgroundColor = kMainBackBgColor
        contentView.addSubview(label_title)
        contentView.addSubview(label_Value)
    }
    
    var order: OrderDetailMsg? {
        didSet {
            label_title.text = order?.order_title
            label_Value.text = order?.order_value
        }
    }
    
    
    private lazy var label_title: UILabel = {
        let title = UILabel()
        title.setupAttribute(13,
                             nil,
                             "5C5C5C",
                             CGSize(width: 80, height: 20),
                             CGPoint(x: kSpacing, y: kSpacing))
        return title
    }()
    
    private lazy var label_Value: UILabel = {
        let title = UILabel()
        title.setupAttribute(13,
                             nil,
                             "5C5C5C",
                             CGSize(width: kScreenWidth - 110, height: 20),
                             CGPoint(x: label_title.right, y: kSpacing))
        return title
    }()
}

class BSOrderDetailBottomView: UIView {
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: UIDevice.current.isX() ? 100 : 70)
        super.init(frame: selfFrame)
        
        addSubview(btnClick)
    }
    
    var order: BSOrderModel? {
        didSet {
            if order?.order_status == "unfinished" {
                btnClick.isHidden = false
                btnClick.setTitle("去支付", for: UIControl.State.normal)
            }else{
                btnClick.isHidden = true
            }
        }
    }
    
    lazy var btnClick: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.size = CGSize(width: 100, height: 32)
        btn.origin = CGPoint(x: width - 115, y: 20)
        btn.backgroundColor = UIColor.colorWidthHexString(hex: "A98054")
        btn.zs_corner()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return btn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
