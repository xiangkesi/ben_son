//
//  BSAccountController.swift
//  ben_son
//
//  Created by ZS on 2018/9/17.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import RxSwift
import YYText

class BSAccountController: UIViewController {

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    

    
    func setupUI() {
        navigationController?.navigationBar.isHidden = true
        view.addSubview(imageViewBg)
        view.addSubview(scrollerMain)
        view.addSubview(buttonClose)
        view.addSubview(labelNavTitle)
        
        view.addSubview(labelAgreement)
    }
    
    
    private lazy var imageViewBg: UIImageView = {
        let bg = UIImageView()
        bg.origin = CGPoint(x: 0, y: 0)
        bg.size = CGSize(width: kScreenWidth, height: kScreenHeight)
        bg.image = UIImage(named: "account_bg")
        return bg
    }()
    
    
    lazy var scrollerMain: TPKeyboardAvoidingScrollView = {
        let mainScroller = TPKeyboardAvoidingScrollView()
        mainScroller.alwaysBounceVertical = true
        mainScroller.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        return mainScroller
    }()
    
    
    lazy var buttonClose: UIButton = {
        let close = UIButton(type: UIButton.ButtonType.custom)
        close.origin = CGPoint(x: 20, y: UIDevice.current.isX() ? 51 : 27)
        close.size = CGSize(width: 30, height: 30)
        close.setImage(UIImage(named: "common_close"), for: UIControl.State.normal)
        close.setImage(UIImage(named: "common_close"), for: UIControl.State.highlighted)
        return close
    }()
    
    private lazy var labelNavTitle: UILabel = {
        let navTitle = UILabel()
        navTitle.font = UIFont.init(name: "PingFangSC-Semibold", size: 18)
        navTitle.size = CGSize(width: 60, height: 30)
        navTitle.left = kScreenWidth * 0.5 - 30
        navTitle.top = buttonClose.top
        navTitle.textAlignment = NSTextAlignment.center
        navTitle.textColor = UIColor.white
        navTitle.text = "登录"
        return navTitle
    }()
    
    lazy var iconView: BSLoginIconView = {
        let icon = BSLoginIconView()
        icon.left = 40
        icon.top = 178
        icon.titleString = "手机号码"
        return icon
    }()
    
    lazy var buttonSure: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.size = CGSize(width: 160, height: 44)
        btn.zs_corner()
        btn.backgroundColor = UIColor.colorWidthHexString(hex: "A98054")
        btn.left = kScreenWidth * 0.5 - 80
        btn.setTitle("确定", for: UIControl.State.normal)
        btn.setTitle("确定", for: UIControl.State.highlighted)
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn.setTitleColor(UIColor.white, for: UIControl.State.highlighted)
        return btn
    }()
    
    private lazy var labelAgreement: YYLabel = {
        let label = YYLabel()
        label.size = CGSize(width: kContentWidth, height: 30)
        label.left = kSpacing
        label.top = kScreenHeight - (UIDevice.current.isX() ? 90 : 45)
        label.highlightTapAction = {[weak self] (containerView: UIView, text: NSAttributedString, range: NSRange, rect: CGRect) in
            let webVc = BSAgreementController()
            self?.navigationController?.pushViewController(webVc, animated: true)
        }
        
        let agreement = NSMutableAttributedString.init(string: "我已阅读并同意 BENSON用户协议")
        agreement.yy_font = UIFont.systemFont(ofSize: 14)
        agreement.yy_color = UIColor.colorWidthHexString(hex: "5A5A5A")
        let range = NSRange(location: 8, length: 10)
        agreement.yy_setColor(kMainColor, range: range)
        let highlight = YYTextHighlight.init()
        agreement.yy_setTextHighlight(highlight, range: range)
        agreement.yy_setUnderlineStyle(NSUnderlineStyle.single, range: range)
        agreement.yy_setUnderlineColor(kMainColor, range: range)
        label.attributedText = agreement
        label.textAlignment = .center
        return label
    }()
    
    deinit {
        print("\(self.classForCoder)销毁了")
    }
}
