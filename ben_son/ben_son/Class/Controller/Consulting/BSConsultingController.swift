//
//  BSConsultingController.swift
//  ben_son
//
//  Created by ZS on 2018/10/16.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BSConsultingController: BSBaseController {
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setupUI() {
        super.setupUI()
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: buttonClose)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: buttonPhone)
        view.addSubview(scrollerMain)
        scrollerMain.addSubview(labelName)
        scrollerMain.addSubview(labelDesc)
        scrollerMain.addSubview(labelPhone)
        scrollerMain.addSubview(btnCall)
        scrollerMain.addSubview(labelTime)
        scrollerMain.addSubview(btnOtherPhone)
        scrollerMain.layer.addSublayer(line)
        scrollerMain.addSubview(labelWheat)
        scrollerMain.addSubview(labelWheaden)
        scrollerMain.addSubview(btnWechat)
        scrollerMain.addSubview(labelWheatNumber)
        scrollerMain.addSubview(labelWheatintroduce)
        
        
        buttonPhone.rx.tap.subscribe(onNext: { [weak self] in
            let detailVc = RSCommonWebController()
            detailVc.requestUrl = "http://p.qiao.baidu.com/cps2/chatIndex?reqParam=%7B%22from%22%3A0%2C%22sessionid%22%3A%22%22%2C%22siteId%22%3A%226109277%22%2C%22tid%22%3A%22-1%22%2C%22userId%22%3A%225643636%22%2C%22ttype%22%3A1%2C%22siteConfig%22%3A%7B%22eid%22%3A%225643636%22%2C%22queuing%22%3A%22%22%2C%22session%22%3A%7B%22displayName%22%3A%221**6%22%2C%22headUrl%22%3A%22https%3A%2F%2Fss0.bdstatic.com%2F7Ls0a8Sm1A5BphGlnYG%2Fsys%2Fportraitn%2Fitem%2F15881097.jpg%22%2C%22status%22%3A0%2C%22uid%22%3A0%2C%22uname%22%3A%22%22%7D%2C%22siteId%22%3A%226109277%22%2C%22online%22%3A%22true%22%2C%22webRoot%22%3A%22%2F%2Fp.qiao.baidu.com%2Fcps2%2F%22%2C%22bid%22%3A%222534443029061092770%22%2C%22userId%22%3A%225643636%22%2C%22invited%22%3A0%7D%2C%22config%22%3A%7B%22themeColor%22%3A%22000000%22%7D%7D&from=singlemessage&isappinstalled=0"
            self?.navigationController?.pushViewController(detailVc, animated: true)
            
        }).disposed(by: disposeBag)
        buttonClose.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        btnCall.rx.tap.subscribe(onNext: {
            BSTool.callPhone(phone: ben_son_number)
        }).disposed(by: disposeBag)
        
        btnOtherPhone.rx.tap.subscribe(onNext: { [weak self] in
            let phoneListVc = BSPhoneListController()
            self?.navigationController?.pushViewController(phoneListVc, animated: true)
        }).disposed(by: disposeBag)
    }
    
    
    private lazy var scrollerMain: UIScrollView = {
        let scroller = UIScrollView()
        scroller.origin = CGPoint(x: 0, y: 0)
        scroller.size = CGSize(width: kScreenWidth, height: UIDevice.current.contentNoTabBarHeight())
        scroller.alwaysBounceVertical = true
        scroller.backgroundColor = kMainBackBgColor
        return scroller
    }()
    
    private lazy var labelName: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.colorWidthHexString(hex: "D9D9D9")
        label.text = "客服热线"
        label.left = kSpacing
        label.size = CGSize(width: 100, height: 24)
        label.top = 20
        label.font = UIFont.init(name: "PingFangSC-Semibold", size: 18)
        return label
    }()
    
    private lazy var labelDesc: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.colorWidthHexString(hex: "383838")
        label.text = "Customer service telephone"
        label.left = kSpacing
        label.size = CGSize(width: kContentWidth, height: 20)
        label.top = labelName.bottom + 4
        return label
    }()
    
    private lazy var labelPhone: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.colorWidthHexString(hex: "A98054")
        label.text = "400-645-8911（上海总部）"
        label.left = kSpacing
        label.size = CGSize(width: kContentWidth, height: 20)
        label.top = labelDesc.bottom + kSpacing
        return label
    }()
    
    private lazy var btnCall: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.size = CGSize(width: 30, height: 30)
        btn.top = labelPhone.top - 5
        btn.left = kScreenWidth - 45
        btn.setImage(UIImage(named: "consulting_phone"), for: UIControl.State.normal)
        btn.setImage(UIImage(named: "consulting_phone"), for: UIControl.State.highlighted)
        return btn
    }()
    
    private lazy var labelTime: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.colorWidthHexString(hex: "53402F")
        label.text = "服务时间  0:00-24:00"
        label.left = kSpacing
        label.size = CGSize(width: kContentWidth, height: 18)
        label.top = labelPhone.bottom + 4.0
        return label
    }()
    
    private lazy var btnOtherPhone: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.size = CGSize(width: kContentWidth, height: 30)
        btn.top = labelTime.bottom + 15
        btn.left = kSpacing
        btn.contentHorizontalAlignment = .left
        btn.setTitle("查看全国其他门店客服电话 ▶", for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.colorWidthHexString(hex: "5C5C5C"), for: UIControl.State.normal)
        return btn
    }()
    
    private lazy var line: CALayer = {
        let l = CALayer()
        l.backgroundColor = UIColor.colorWidthHexString(hex: "383838").cgColor
        l.frameSize = CGSize(width: kContentWidth, height: 0.5)
        l.origin = CGPoint(x: kSpacing, y: btnOtherPhone.bottom + 15)
        return l
    }()
    
    private lazy var labelWheat: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.colorWidthHexString(hex: "D9D9D9")
        label.text = "微信客服"
        label.left = kSpacing
        label.size = CGSize(width: 100, height: 24)
        label.top = line.bottom + 20
        label.font = UIFont.init(name: "PingFangSC-Semibold", size: 18)
        return label
    }()
    
    private lazy var labelWheaden: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.colorWidthHexString(hex: "383838")
        label.text = "Customer service telephone"
        label.left = kSpacing
        label.size = CGSize(width: kContentWidth, height: 20)
        label.top = labelWheat.bottom + 4
        return label
    }()
    
    private lazy var btnWechat: UIImageView = {
        let btn = UIImageView()
        btn.size = CGSize(width: 120, height: 120)
        btn.top = labelWheaden.bottom + 30
        btn.left = (kScreenWidth - 120) * 0.5
        btn.image = UIImage(named: "image_qrcode")
        btn.isUserInteractionEnabled = true
        let longTap = UILongPressGestureRecognizer()
//        longTap.minimumPressDuration = 2
        btn.addGestureRecognizer(longTap)
        longTap.rx.event.subscribe(onNext: {[weak self] (recognizer) in
            if recognizer.state != UIGestureRecognizer.State.began {
                return
            }
            self?.saveImage()
        }).disposed(by: disposeBag)
        return btn
    }()
    
    private lazy var labelWheatNumber: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.colorWidthHexString(hex: "BFBFBF")
        label.text = "微信公众号：BensonSupercarClub"
        label.left = kSpacing
        label.size = CGSize(width: kContentWidth, height: 24)
        label.top = btnWechat.bottom + 15
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var labelWheatintroduce: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.colorWidthHexString(hex: "5C5C5C")
        label.text = "可长按图片，保存到相册后再扫描"
        label.left = kSpacing
        label.size = CGSize(width: kContentWidth, height: 16)
        label.top = labelWheatNumber.bottom + 5
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var buttonPhone: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "consulting_icon_chat"), for: UIControl.State.normal)
        btn.setImage(UIImage(named: "consulting_icon_chat"), for: UIControl.State.highlighted)
        btn.size = CGSize(width: 90, height: 30)
        btn.setTitle(" 在线咨询", for: UIControl.State.normal)
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return btn
    }()
    private lazy var buttonClose: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "common_close"), for: UIControl.State.normal)
        btn.setImage(UIImage(named: "common_close"), for: UIControl.State.highlighted)
        btn.size = CGSize(width: 30, height: 30)
        return btn
    }()
}

extension BSConsultingController {

    private func saveImage() {
        BSTool.showAlertView(title: "保存图片", message: nil, image: btnWechat.image, vc: self)
    }
}
