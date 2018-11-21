//
//  BSAddressListCell.swift
//  ben_son
//
//  Created by ZS on 2018/9/26.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit

class BSAddressListCell: BSCommentCell {

    override func setupUI() {
        super.setupUI()
        contentView.backgroundColor = UIColor.colorWidthHexString(hex: "171717")
        contentView.addSubview(labelAddress)
        contentView.addSubview(labelMsg)
        
        contentView.layer.addSublayer(line)
    }
    
    var address: AddressList? {
        didSet {
            line.top = (address?.rowHeight)! - 0.5
            labelAddress.text = address?.address_final
            labelAddress.height = (address?.titleHeight)!
            labelMsg.top = labelAddress.bottom + 4
            labelMsg.text = (address?.name ?? "") + (address?.telephone ?? "")
            
        }
    }
    
    
    private lazy var labelAddress: UILabel = {
        let address = UILabel()
        address.left = 20
        address.top = kSpacing
        address.width = kScreenWidth - 40
        address.height = 20
        address.numberOfLines = 0
        address.textColor = UIColor.white
        address.font = UIFont.systemFont(ofSize: 15)
        return address
    }()
    
    private lazy var labelMsg: UILabel = {
        let msg = UILabel.init()
        msg.left = 20
        msg.top = labelAddress.bottom + 8
        msg.width = labelAddress.width
        msg.height = 16
        msg.text = "刘先生 17602177967"
        msg.textColor = UIColor.colorWidthHexString(hex: "5C5C5C")
        msg.font = UIFont.systemFont(ofSize: 13)
        return msg
    }()
}



class BSAddressMsgView: UIView {
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 60)
        super.init(frame: selfFrame)
        
        addSubview(labelTitle)
        addSubview(textField)
        layer.addSublayer(lineBottom)
    }
    
    func setup(title: String, placerHolder: String) {
        let attrString = NSAttributedString(string: placerHolder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.colorWidthHexString(hex: "53402F")])
        textField.attributedPlaceholder = attrString
        labelTitle.text = title
    }
    
    
    private lazy var labelTitle: UILabel = {
        let title = UILabel()
        title.left = kSpacing
        title.height = 40
        title.top = 10
        title.width = 85
        title.textColor = kMainColor
        title.backgroundColor = UIColor.colorWidthHexString(hex: "141414")
        title.layer.masksToBounds = true
        title.font = UIFont.systemFont(ofSize: 15)
        return title
    }()
    
    lazy var textField: UITextField = {
        let field = UITextField()
        field.left = labelTitle.right
        field.top = labelTitle.top
        field.height = labelTitle.height
        field.width = kScreenWidth - 200
        field.font = UIFont.systemFont(ofSize: 15)
        field.textColor = UIColor.white
        field.backgroundColor = UIColor.colorWidthHexString(hex: "141414")
        field.layer.masksToBounds = true
        return field
    }()
    
    private lazy var lineBottom: CALayer = {
        let line = CALayer.init()
        line.left = 0
        line.width = kScreenWidth
        line.height = 0.5
        line.top = height - line.height
        line.backgroundColor = UIColor.colorWidthHexString(hex: "1E1E1E").cgColor
        return line
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class BSAddressUseMsgView: UIView {
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 120)
        super.init(frame: selfFrame)
        
        addSubview(userNameView)
        addSubview(phoneView)
        addSubview(btnChoosePeople)
    }
    
    
    lazy var userNameView: BSAddressMsgView = {
        let name = BSAddressMsgView()
        name.origin = CGPoint(x: 0, y: 0)
        name.setup(title: "收货人:", placerHolder: "请输入")
        return name
    }()
    
    lazy var phoneView: BSAddressMsgView = {
        let name = BSAddressMsgView()
        name.origin = CGPoint(x: 0, y: userNameView.bottom)
        name.setup(title: "手机号码:", placerHolder: "请输入")
        name.textField.keyboardType = .numberPad
        return name
    }()
    
    lazy var btnChoosePeople: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.size = CGSize(width: 100, height: 120)
        btn.origin = CGPoint(x: kScreenWidth - 100, y: 0)
        btn.backgroundColor = UIColor.red
        return btn
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class BSAddAreaView: UIView {
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 60)
        super.init(frame: selfFrame)
        
        addSubview(labelTitle)
        addSubview(btnChooseAddress)
        layer.addSublayer(lineBottom)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var labelTitle: UILabel = {
        let title = UILabel()
        title.left = kSpacing
        title.height = 40
        title.top = 10
        title.width = 85
        title.textColor = kMainColor
        title.backgroundColor = UIColor.colorWidthHexString(hex: "141414")
        title.layer.masksToBounds = true
        title.font = UIFont.systemFont(ofSize: 15)
        title.text = "所在地区:"
        return title
    }()
    
    
    private lazy var lineBottom: CALayer = {
        let line = CALayer.init()
        line.left = 0
        line.width = kScreenWidth
        line.height = 0.5
        line.top = height - line.height
        line.backgroundColor = UIColor.colorWidthHexString(hex: "1E1E1E").cgColor
        return line
    }()
    
    lazy var btnChooseAddress: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.size = CGSize(width: kScreenWidth - 115, height: 40)
        btn.origin = CGPoint(x: labelTitle.right, y: 10)
        btn.setTitleColor(UIColor.colorWidthHexString(hex: "53402F"), for: UIControl.State.normal)
        btn.setTitleColor(kMainColor, for: UIControl.State.selected)
        btn.setTitle("请选择", for: UIControl.State.normal)
        btn.setTitle("请选择", for: UIControl.State.highlighted)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.contentHorizontalAlignment = .right
        return btn
    }()
}

class BSDetailAddressView: UIView {
    
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 80)
        super.init(frame: selfFrame)
        
        layer.addSublayer(lineBottom)
        addSubview(labelTitle)
        addSubview(textView)
    }
    private lazy var labelTitle: UILabel = {
        let title = UILabel()
        title.left = kSpacing
        title.height = 20
        title.top = 20
        title.width = 85
        title.textColor = kMainColor
        title.backgroundColor = UIColor.colorWidthHexString(hex: "141414")
        title.layer.masksToBounds = true
        title.font = UIFont.systemFont(ofSize: 15)
        title.text = "详细地址:"
        return title
    }()
    
    private lazy var lineBottom: CALayer = {
        let line = CALayer.init()
        line.left = 0
        line.width = kScreenWidth
        line.height = 0.5
        line.top = height - line.height
        line.backgroundColor = UIColor.colorWidthHexString(hex: "1E1E1E").cgColor
        return line
    }()
    
    
    lazy var textView: UITextView = {
        let text = UITextView()
        text.left = labelTitle.right
        text.top = labelTitle.top
        text.width = kScreenWidth - 115
        text.height = 40
        text.font = UIFont.systemFont(ofSize: 15)
        text.textColor = kMainColor
        text.placeHolderTextColor(placeholdStr: "街道楼牌等", placeholdColor: UIColor.colorWidthHexString(hex: "53402F"))
        text.textContainerInset = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        text.backgroundColor = UIColor.colorWidthHexString(hex: "141414")
        return text
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
