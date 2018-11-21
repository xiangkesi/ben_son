//
//  BSShareController.swift
//  ben_son
//
//  Created by ZS on 2018/10/25.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BSShareController: BSBaseController {

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func setupUI() {
        super.setupUI()
        title = "分享"
        view.addSubview(viewBottom)
        viewBottom.addSubview(labelTitle)
        view.addSubview(viewTop)
        viewTop.addSubview(imageCodeView)
        viewTop.addSubview(headViewBg)
        headViewBg.addSubview(headImageView)
        headViewBg.addSubview(userLabel)
        headViewBg.addSubview(descLabel)
        creatBtns()
    }
    
    private lazy var viewBottom: UIView = {
        let bottom = UIView()
        bottom.size = CGSize(width: kScreenWidth, height: kScreenWidth * 0.25 + 70 + UIDevice.current.tabbarBottomHeight())
        bottom.backgroundColor = kMainBackBgColor
        bottom.translatesAutoresizingMaskIntoConstraints = false
        bottom.origin = CGPoint(x: 0, y: UIDevice.current.contentNoTabBarHeight() - bottom.height)
        return bottom
    }()
    
    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.colorWidthHexString(hex: "5C5C5C")
        label.top = 0
        label.left = 0
        label.size = CGSize(width: kScreenWidth, height: 20)
        label.textAlignment = .center
        label.text = "更多分享方式"
        return label
    }()
    
    private lazy var viewTop: UIView = {
        let top = UIView()
        top.size = CGSize(width: kScreenWidth - 80, height: kScreenWidth + 10)
        top.backgroundColor = UIColor.colorWidthHexString(hex: "202020")
        top.translatesAutoresizingMaskIntoConstraints = false
        top.origin = CGPoint(x: 40, y: 40)
        return top
    }()
    
    private lazy var imageCodeView: UIImageView = {
        let codeView = UIImageView()
        codeView.size = CGSize(width: viewTop.width - 80, height: viewTop.width - 80)
        codeView.top = viewTop.height - codeView.height - 40
        codeView.left = 40
        codeView.image = UIImage(named: "download_ecode")
        return codeView
    }()
    
    private lazy var headViewBg: UIView = {
        let bg = UIView()
        bg.origin = CGPoint(x: 0, y: 0)
        bg.size = CGSize(width: viewTop.width, height: 88)
        bg.backgroundColor = kMainBackBgColor
        bg.addBottomLine(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10),
                         UIColor.colorWidthHexString(hex: "322A21"),
                         0.5)
        return bg
    }()
    
    private lazy var headImageView: UIImageView = {
        let codeView = UIImageView()
        codeView.size = CGSize(width: 48, height: 48)
        codeView.top = 20
        codeView.left = kSpacing
        codeView.image = head_image_placholder
        codeView.zs_corner()
        return codeView
    }()
    
    private lazy var userLabel: UILabel = {
        let label = UILabel()
        label.setupAttribute(18,
                             "PingFangSC-Medium",
                             "FFFFFF",
                             CGSize(width: headViewBg.width - 86, height: 20),
                             CGPoint(x: headImageView.right + 8, y: headImageView.top))
        label.text = "APP二维码"
        return label
    }()
    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.setupAttribute(13,
                             "PingFangSC-Regular",
                             "5C5C5C",
                             CGSize(width: userLabel.width, height: 18),
                             CGPoint(x: userLabel.left, y: userLabel.bottom + 4))
        label.text = "告诉你的小伙伴你正在使用本森App"
        return label
    }()
}

extension BSShareController {
    
    private func creatBtns() {
        let dicArray = [["title":"好友","image":"share_wechat"],
                        ["title":"朋友圈","image":"share_wechat_line"],
                        ["title":"微博","image":"share_sina"],
                        ["title":"邮件","image":"share_email"]]
        var lastBtn: UIButton? = nil
        for (index, dic) in dicArray.enumerated() {
            let btn = UIButton(type: UIButton.ButtonType.custom)
            btn.size = CGSize(width: kScreenWidth * 0.25, height: kScreenWidth * 0.25)
            btn.setTitleColor(UIColor.colorWidthHexString(hex: "BFBFBF"), for: UIControl.State.normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            btn.setTitle(dic["title"], for: UIControl.State.normal)
            btn.setImage(UIImage(named: dic["image"]!), for: UIControl.State.normal)
            btn.zs_setImagePositionType(type: ImagePositionType.top, spacing: 10)
            btn.left = (lastBtn == nil ? 0 : (lastBtn?.right)!)
            btn.top = labelTitle.bottom + 30
            btn.tag = index
            btn.rx.tap.subscribe(onNext: {[weak self] in
                let share = ShareModel()
                share.title = "本森超跑"
                share.desc = "本森超跑-期待您的加入"
                share.webUrl = "https://itunes.apple.com/cn/app/ben-sen-chao-pao/id1176038542?mt=8"
                
                switch index {
                case 0:
                    RSUmenManager.share(platformtype: PlatformType.wechatType, sharemodel: share, shareType: ShareType.shareWeb)
                    break
                case 1:
                    RSUmenManager.share(platformtype: PlatformType.WechatTimeLine, sharemodel: share, shareType: ShareType.shareWeb)
                    break
                case 2:
                    RSUmenManager.share(platformtype: PlatformType.sinaType, sharemodel: share, shareType: ShareType.shareWeb)
                    break
                default:
                    RSUmenManager.share(platformtype: PlatformType.email, sharemodel: share, shareType: ShareType.shareWeb)

                    break
                }
            }).disposed(by: disposeBag)
            viewBottom.addSubview(btn)
            
            lastBtn = btn
        }
        
        
        
        
    }
}
