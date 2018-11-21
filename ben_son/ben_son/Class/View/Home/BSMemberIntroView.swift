//
//  BSMemberIntroView.swift
//  ben_son
//
//  Created by ZS on 2018/10/25.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift
private let btnWidth = kScreenWidth * 0.33

class BSMemberIntroView: UIView {

    let disposeBag = DisposeBag()
    
    let btnClick = PublishSubject<Int>()
    
    
    var currentIndex: Int = 0
    
    private var btns = [UIButton]()
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 70)
        super.init(frame: selfFrame)
        backgroundColor = kMainBackBgColor
        creatBtns()
        layer.addSublayer(lineBottom)
        addBottomLine(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), UIColor.colorWidthHexString(hex: "53402F"), 0.5)
    }
    
    @objc func actionClick(btn: UIButton) {
        if btn.tag == currentIndex {
            return
        }
        for clickBtn in btns {
            clickBtn.isSelected = false
        }
        let lineLeft = btn.left + (btn.width - lineBottom.width) * 0.5
        UIView.animate(withDuration: 0.05, animations: {
            self.lineBottom.left = lineLeft
            btn.isSelected = true
        }) {[weak self] (finish) in
            self!.currentIndex = btn.tag
            self?.btnClick.onNext((self?.currentIndex)!)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func creatBtns() {
        let titles = ["金卡特权","黑卡特权","普通会员"]
        var lastBtn: UIButton? = nil
        for (index, title) in titles.enumerated() {
            let btn = UIButton(type: UIButton.ButtonType.custom)
            btn.top = 20
            btn.height = 30
            btn.width = btnWidth
            btn.left = (lastBtn == nil ? 0 : lastBtn!.right)
            btn.setTitle(title, for: UIControl.State.normal)
            btn.titleLabel?.font = UIFont.init(name: "PingFangSC-Semibold", size: 16)
            btn.setTitleColor(kMainColor, for: UIControl.State.selected)
            btn.setTitleColor(UIColor.colorWidthHexString(hex: "BFBFBF"), for: UIControl.State.normal)
            btn.isSelected = lastBtn == nil ? true : false
            btn.addTarget(self, action: #selector(actionClick(btn:)), for: UIControl.Event.touchUpInside)
            btn.tag = index
            btns.append(btn)
            addSubview(btn)
            lastBtn = btn
        }
    }
    
    private lazy var lineBottom: CALayer = {
        let line = CALayer()
        line.width = 64
        line.height = 1
        line.top = 50
        line.left = (btnWidth - line.width) * 0.5
        line.backgroundColor = kMainColor.cgColor
        return line
    }()
    
}

class BSMemberIntroCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = kMainBackBgColor
        contentView.addSubview(imageIconView)
        contentView.addSubview(labelTitle)
        contentView.layer.addSublayer(lineBottom)
        contentView.layer.addSublayer(lineRight)
        setupLayout()
    }
    
    var intro: BSMemberIntroModel? {
        didSet{
            imageIconView.image = UIImage(named: (intro?.normalIcon)!)
            labelTitle.text = intro?.title
            labelTitle.textColor = UIColor.colorWidthHexString(hex: (intro?.colorString)!)
            lineBottom.left = !(intro?.showBottomLeft)! ? kSpacing : 0
            lineRight.isHidden = !(intro?.showrightLine)!
        }
    }
    
    
    
    private lazy var imageIconView: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    private lazy var lineBottom: CALayer = {
        let line = CALayer()
        line.left = 0
        line.height = 0.5
        line.width = kScreenWidth * 0.5 - kSpacing
        line.top = kScreenWidth * 0.4 - line.height
        line.backgroundColor = UIColor.colorWidthHexString(hex: "53402F").cgColor
        return line
    }()
    
    private lazy var lineRight: CALayer = {
        let line = CALayer()
        line.width = 0.5
        line.left = kScreenWidth * 0.5 - line.width
        line.height = kScreenWidth * 0.4
        line.top = 0
        line.backgroundColor = UIColor.colorWidthHexString(hex: "53402F").cgColor
        return line
    }()
    
    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = kMainColor
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BSMemberIntroCell {
    private func setupLayout() {
        contentView.addSubview(imageIconView)
        
        contentView.addConstraint(NSLayoutConstraint(item: imageIconView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 20))
        contentView.addConstraint(NSLayoutConstraint(item: imageIconView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0))
        imageIconView.addConstraint(NSLayoutConstraint(item: imageIconView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1.0, constant: 36))
        imageIconView.addConstraint(NSLayoutConstraint(item: imageIconView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1.0, constant: 36))
        
        contentView.addConstraint(NSLayoutConstraint(item: labelTitle, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: imageIconView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 5))
        contentView.addConstraint(NSLayoutConstraint(item: labelTitle, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: 15))
        contentView.addConstraint(NSLayoutConstraint(item: labelTitle, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1.0, constant: -15))
        contentView.addConstraint(NSLayoutConstraint(item: labelTitle, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual, toItem: contentView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: -15))

    }
}

class MyMemberIntroHeadView: UIView {
    
    override init(frame: CGRect) {
        
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 240 + UIDevice.current.statusHeight())
        
        super.init(frame: selfFrame)
        
        backgroundColor = UIColor.colorWidthHexString(hex: "202020")
        addSubview(imageHeadView)
        addSubview(labelHi)
        addSubview(labelName)
        addSubview(labelType)
        
        addSubview(bg)
        bg.addSubview(labelFirst)
        bg.addSubview(labelSecond)
        
        addBottomLine(UIEdgeInsets(top: 0, left: kSpacing, bottom: 0, right: 0), UIColor.colorWidthHexString(hex: "53402F"), 0.5)
        
    }
    
    var user: Login_user? {
        didSet {
            imageHeadView.zs_setImage(urlString: user?.avatar, placerHolder: head_image_placholder)
            labelName.text = user?.username
            labelName.sizeToFit()
            labelName.width = labelName.width > kScreenWidth - 180 ? kScreenWidth - 180 : labelName.width
            labelName.height = 20
            labelType.left = labelName.right + 10
            labelType.top = labelName.top
            if user?.level == 1 {
                labelType.text = "普通会员"
            }else if user?.level == 2 {
                labelType.text = "金卡会员"
            }else {
                labelType.text = "黑卡会员"
            }
            
        }
    }
    
    private lazy var labelType: UILabel = {
        let label = UILabel()
        label.size = CGSize(width: 80, height: 20)
        label.textColor = UIColor.colorWidthHexString(hex: "333333")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.backgroundColor = UIColor.white
        label.zs_corner()
        
        return label
    }()
    
    private lazy var imageHeadView: UIImageView = {
        let head = UIImageView()
        head.size = CGSize(width: 60, height: 60)
        head.zs_corner()
        head.origin = CGPoint(x: kSpacing, y: 40 + UIDevice.current.statusHeight())
        return head
    }()
    
    private lazy var labelHi: UILabel = {
        let label = UILabel()
        label.size = CGSize(width: kContentWidth - 70, height: 20)
        label.top = imageHeadView.top + 5
        label.left = imageHeadView.right + 10
        label.textColor = UIColor.colorWidthHexString(hex: "FCFCFC")
        label.font = UIFont.init(name: "PingFangSC-Medium", size: 18)
        label.text = "Hi~"
        return label
    }()
    
    private lazy var labelName: UILabel = {
        let label = UILabel()
        label.size = CGSize(width: kContentWidth - 70, height: 20)
        label.top = labelHi.bottom + 5
        label.left = imageHeadView.right + 10
        label.textColor = UIColor.colorWidthHexString(hex: "FCFCFC")
        label.font = UIFont.init(name: "PingFangSC-Medium", size: 18)
        label.text = "香克斯的小草帽"
        return label
    }()
    
    private lazy var bg: UIView = {
        let b = UIView()
        b.backgroundColor = kMainBackBgColor
        b.size = CGSize(width: kScreenWidth, height: 80)
        b.origin = CGPoint(x: 0, y: height - 80)
        return b
    }()
    
    private lazy var labelFirst: UILabel = {
        let label = UILabel()
        label.size = CGSize(width: kContentWidth, height: 24)
        label.top = 20
        label.left = kSpacing
        label.textColor = UIColor.colorWidthHexString(hex: "D9D9D9")
        label.font = UIFont.init(name: "PingFangSC-Semibold", size: 18)
        label.text = "您的会员权益"
        return label
    }()
    
    private lazy var labelSecond: UILabel = {
        let label = UILabel()
        label.size = CGSize(width: kContentWidth, height: 16)
        label.top = labelFirst.bottom
        label.left = kSpacing
        label.textColor = UIColor.colorWidthHexString(hex: "383838")
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "YOUR VIP member benefits"
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
