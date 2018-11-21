//
//  PhoneAddressCell.swift
//  ben_son
//
//  Created by ZS on 2018/10/16.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift

class PhoneAddressCell: BSCommentCell {

    var disposeBag = DisposeBag()
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    override func setupUI() {
        super.setupUI()
        contentView.backgroundColor = kMainBackBgColor
        contentView.addSubview(labelName)
        contentView.addSubview(labelAddress)
        contentView.addSubview(btnCall)
        contentView.addSubview(btnAddress)
        line.top = 75
        contentView.layer.addSublayer(line)
        
     
    }
    
    var model: PhoneAddressModel? {
        didSet{
            labelName.text = model?.name
            labelName.textColor = (model?.isFirst ?? false) ? kMainColor : UIColor.colorWidthHexString(hex: "BFBFBF")
            labelAddress.text = model?.address
            
        }
    }
    
    
    private lazy var labelName: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.colorWidthHexString(hex: "BFBFBF")
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "上海总部"
        label.size = CGSize(width: 100, height: 22)
        label.left = kSpacing
        label.top = 16
        return label
    }()
    
    private lazy var labelAddress: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.colorWidthHexString(hex: "5C5C5C")
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "上总市中山南路1029号幸福码头4号榜"
        label.size = CGSize(width: kScreenWidth - 100, height: 22)
        label.top = labelName.bottom + 5
        label.left = kSpacing
        return label
    }()
    
    lazy var btnAddress: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.size = CGSize(width: 30, height: 30)
        btn.setImage(UIImage(named: "consulting_address"), for: UIControl.State.normal)
        btn.setImage(UIImage(named: "consulting_address"), for: UIControl.State.highlighted)
        btn.top = btnCall.top
        btn.left = btnCall.left - 45
        return btn
    }()

    lazy var btnCall: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.size = CGSize(width: 30, height: 30)
        btn.top = 23
        btn.left = kScreenWidth - 45
        btn.setImage(UIImage(named: "consulting_phone"), for: UIControl.State.normal)
        btn.setImage(UIImage(named: "consulting_phone"), for: UIControl.State.highlighted)
        return btn
    }()
}

class PhoneAddressFooterView: UIView {
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 76)
        super.init(frame: selfFrame)
        backgroundColor = kMainBackBgColor
        layer.addSublayer(line)
        addSubview(labelTitle)
    }
    
    private lazy var line: CALayer = {
        let l = CALayer()
        l.backgroundColor = UIColor.colorWidthHexString(hex: "383838").cgColor
        l.frameSize = CGSize(width: 250, height: 1)
        l.origin = CGPoint(x: (kScreenWidth - 250) * 0.5, y: 38)
        return l
    }()
    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: (kScreenWidth - 150) * 0.5, y: 30, width: 150, height: 16)
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.colorWidthHexString(hex: "383838")
        label.text = "更多门店，尽请期待"
        label.textAlignment = .center
        label.backgroundColor = kMainBackBgColor
        label.layer.masksToBounds = true
        return label
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
