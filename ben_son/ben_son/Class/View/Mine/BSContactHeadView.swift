//
//  BSContactHeadView.swift
//  ben_son
//
//  Created by ZS on 2018/9/20.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit

class BSContactHeadView: UIView {

    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth * 0.56)
        super.init(frame: selfFrame)
        
        addSubview(imageView)
        addSubview(labelVersion)
    }
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.size = size
        image.origin = CGPoint(x: 0, y: 0)
        image.image = UIImage(named: "contact_banner")
        return image
    }()
    
    private lazy var labelVersion: UILabel = {
        let version = UILabel.init()
        version.textColor = UIColor.colorWidthHexString(hex: "BFBFBF")
        version.font = UIFont.systemFont(ofSize: 13)
        version.textAlignment = .right
        version.size = CGSize(width: 100, height: 18)
        version.origin = CGPoint(x: kScreenWidth - 115, y: height - 26)
        let infoDictionary = Bundle.main.infoDictionary!
        if let app_name = infoDictionary["CFBundleDisplayName"] as? String, let app_Version = infoDictionary["CFBundleShortVersionString"] as? String, let minorVersion = infoDictionary["CFBundleVersion"] as? String  {
            version.text = app_name + ":   " + app_Version + "." + minorVersion
        }
        return version
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BSContactCell: BSCommentCell {
    
    override func setupUI() {
        super.setupUI()
        contentView.backgroundColor = kMainBackBgColor
        contentView.addSubview(imageIcon)
        contentView.addSubview(labelName)
        contentView.addSubview(labelDesc)
        contentView.layer.addSublayer(lineBottom)
    }
    
    var dic: Dictionary<String, String>? {
        didSet{
            imageIcon.image = UIImage(named: dic!["icon"]!)
            labelName.text = dic!["title"]
            labelDesc.text = dic!["desc"]
        }
    }
    
    
    private lazy var imageIcon: UIImageView = {
        let iconView = UIImageView()
        iconView.size = CGSize(width: 24, height: 24)
        iconView.origin = CGPoint(x: 14, y: 16)
        return iconView
    }()
    
    private lazy var labelName: UILabel = {
        let name = UILabel.init()
        name.textColor = UIColor.colorWidthHexString(hex: "BFBFBF")
        name.font = UIFont.systemFont(ofSize: 15)
        name.size = CGSize(width: 80, height: 24)
        name.origin = CGPoint(x: imageIcon.right + 10, y: 16)
        name.backgroundColor = kMainBackBgColor
        name.layer.masksToBounds = true
        return name
    }()
    
    private lazy var labelDesc: UILabel = {
        let desc = UILabel.init()
        desc.textColor = UIColor.colorWidthHexString(hex: "5C5C5C")
        desc.font = UIFont.systemFont(ofSize: 15)
        desc.size = CGSize(width: kScreenWidth - 150, height: 24)
        desc.origin = CGPoint(x: 135, y: 16)
        desc.backgroundColor = kMainBackBgColor
        desc.layer.masksToBounds = true
        desc.textAlignment = .right
        return desc
    }()
    
    private lazy var lineBottom: CALayer = {
        let line = CALayer.init()
        line.left = kSpacing
        line.width = kContentWidth
        line.height = 0.5
        line.top = 55
        line.backgroundColor = UIColor.colorWidthHexString(hex: "1A1A1A").cgColor
        
        return line
    }()

}

class BSContactFootView: UIView {
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - kScreenWidth * 0.56 - 56 * 3)
        super.init(frame: selfFrame)
        
        addSubview(imageView)
        addSubview(labelWechat)
        addSubview(labelMsg)
    }
    
    private lazy var labelMsg: UILabel = {
        let desc = UILabel.init()
        desc.textColor = UIColor.colorWidthHexString(hex: "5C5C5C")
        desc.font = UIFont.systemFont(ofSize: 12)
        desc.size = CGSize(width: kContentWidth, height: 16)
        desc.origin = CGPoint(x: 15, y: height - (UIDevice.current.isX() ? 50 : 32))
        desc.backgroundColor = kMainBackBgColor
        desc.layer.masksToBounds = true
        desc.textAlignment = .center
        desc.text = "@2018 本森集团 all right reserved"
        return desc
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.size = CGSize(width: 120, height: 120)
        image.origin = CGPoint(x: width * 0.5 - 60, y: height * 0.5 - 100)
        image.image = UIImage(named: "image_qrcode")
        return image
    }()
    
    private lazy var labelWechat: UILabel = {
        let desc = UILabel.init()
        desc.textColor = UIColor.colorWidthHexString(hex: "BFBFBF")
        desc.font = UIFont.systemFont(ofSize: 15)
        desc.size = CGSize(width: kContentWidth, height: 22)
        desc.origin = CGPoint(x: 15, y: imageView.bottom + 15)
        desc.backgroundColor = kMainBackBgColor
        desc.layer.masksToBounds = true
        desc.textAlignment = .center
        desc.text = "微信公众号：BensonSupercarClub"
        return desc
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
