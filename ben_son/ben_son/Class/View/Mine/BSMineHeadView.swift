//
//  BSMineHeadView.swift
//  ben_son
//
//  Created by ZS on 2018/9/17.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift

class BSMineHeadView: UIView {

    let disposeBag = DisposeBag()
    
    let subjectClickBtn = PublishSubject<Int>()
    

    var pointImageHeadView = CGPoint(x: 0, y: 0)
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth * 0.65)
        super.init(frame: selfFrame)
        setupUI()
    }
    
    var login_user: Login_user? {
        didSet{
            if login_user == nil {
                imageHeadIcon.image = head_image_placholder
                labelNickName.text = "点击进行登录"
                labelDesc.text = ""
                labelCount.isHidden = true
            }else{
                imageHeadIcon.zs_setImage(urlString: login_user?.avatar, placerHolder: head_image_placholder)
                labelNickName.text = (login_user?.username != nil ? login_user?.username : login_user?.telephone)
                labelDesc.text = login_user?.signature != nil ? login_user?.signature : "这家伙很懒,什么也没有留下"
                if login_user?.order_progress_count == nil || login_user?.order_progress_count == 0 {
                    labelCount.isHidden = true
                }else{
                    labelCount.isHidden = false
                    labelCount.text = String(login_user?.order_progress_count ?? 0)
                }
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private lazy var headIconBg: UIView = {
        let headIcon = UIView()
        headIcon.origin = CGPoint(x: 0, y: 0)
        headIcon.size = CGSize(width: width, height: width * 0.42)
        headIcon.backgroundColor = UIColor.colorWidthHexString(hex: "202020")
        return headIcon
    }()
    
    private lazy var imageHeadIcon: UIImageView = {
        let icon = UIImageView()
        icon.size = CGSize(width: 50, height: 50)
        icon.origin = CGPoint(x: 16, y: headIconBg.height * 0.5 - (UIDevice.current.isX() ? 10 : 25))
        icon.image = head_image_placholder
        icon.isUserInteractionEnabled = true
        icon.zs_corner()
        return icon
    }()
    
    private lazy var buttonLogin: UIButton = {
        let login = UIButton(type: UIButton.ButtonType.custom)
        login.origin = CGPoint(x: kSpacing, y: imageHeadIcon.top)
        login.size = CGSize(width: kContentWidth, height: imageHeadIcon.height)
        return login
    }()
    
    private lazy var labelNickName: UILabel = {
        let nickName = UILabel()
        nickName.font = UIFont.init(name: "PingFangSC-Medium", size: 18)
        nickName.textColor = UIColor.white
        nickName.text = ""
        nickName.origin = CGPoint(x: imageHeadIcon.right + 16, y: imageHeadIcon.top + 5)
        nickName.size = CGSize(width: width - 120, height: 20)
        return nickName
    }()
    
    private lazy var labelDesc: UILabel = {
        let desc = UILabel()
        desc.left = labelNickName.left
        desc.size = CGSize(width: labelNickName.width, height: 17)
        desc.top = imageHeadIcon.bottom - 17
        desc.textColor = UIColor.colorWidthHexString(hex: "999999")
        desc.font = UIFont.systemFont(ofSize: 12)
        return desc
    }()
    
    private lazy var viewClickBg: UIView = {
        let bg = UIView()
        bg.left = 0
        bg.top = headIconBg.bottom
        bg.size = CGSize(width: kScreenWidth, height: height - headIconBg.height)
        bg.backgroundColor = kMainBackBgColor
        return bg
    }()
    
    private lazy var moveView: UIView = {
        let moveBg = UIView()
        moveBg.frame = (kRootVc?.view.frame)!
        return moveBg
    }()
    private lazy var labelCount: UILabel = {
        let label = UILabel()
        label.size = CGSize(width: 16, height: 16)
        label.backgroundColor = UIColor.red
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 11)
        label.top = 10
        label.left = kScreenWidth * 0.25 - 15
        label.zs_corner()
        label.text = "5"
        label.textColor = UIColor.white
        label.isHidden = true
        return label
    }()
}

extension BSMineHeadView {
    
    private func setupUI() {
        backgroundColor = UIColor.colorWidthHexString(hex: "202020")
        addSubview(headIconBg)
        addSubview(viewClickBg)
        headIconBg.addSubview(imageHeadIcon)
        headIconBg.addSubview(labelNickName)
        headIconBg.addSubview(labelDesc)
        headIconBg.addSubview(buttonLogin)
        creatBtns()
        let pan = UIPanGestureRecognizer()
        pan.minimumNumberOfTouches = 1
        pan.maximumNumberOfTouches = 1
        imageHeadIcon.addGestureRecognizer(pan)
        pan.rx.event.subscribe(onNext: {[weak self] (recognizer) in
            if recognizer.state == UIGestureRecognizer.State.changed {
            let translation = recognizer.translation(in: self?.superview)
            var newCenter = CGPoint(x: (recognizer.view?.center.x)! + translation.x, y: (recognizer.view?.center.y)! + translation.y)
            newCenter.y = max((recognizer.view?.frame.size.height)! * 0.5, newCenter.y)
                newCenter.y = min((self?.superview!.size.height)! - recognizer.view!.frame.size.height * 0.5, newCenter.y)
            newCenter.x = max(recognizer.view!.frame.size.width * 0.5, newCenter.x)
                newCenter.x = min(self!.superview!.frame.size.width - recognizer.view!.frame.size.width * 0.5,newCenter.x);
            recognizer.view!.center = newCenter
            recognizer.setTranslation(CGPoint(), in: self)
            } else if recognizer.state == UIGestureRecognizer.State.began {
                kRootVc?.view.addSubview(self!.moveView)
                self!.moveView.addSubview((self?.imageHeadIcon)!)
            }else if recognizer.state == UIGestureRecognizer.State.ended {
                self?.endMove()
            }
        }, onError: { (error) in
            
        }, onCompleted: {
            
        }) {
            
        }.disposed(by: disposeBag)
        
        buttonLogin.rx.tap.subscribe(onNext: {[weak self] in
            if AccountManager.shareManager().isLogin {
                return
            }
            self?.subjectClickBtn.onNext(1000)
        }).disposed(by: disposeBag)
        
    }
    

    
    private func creatBtns() {
        let dicArray = [["icon":"bs_mine_mileage","title":"积分里程"],["icon":"bs_mine_wallet","title":"我的钱包"],["icon":"bs_mine_bankcard","title":"我的会员"],["icon":"bs_mine_order","title":"我的订单"]]
        var btnLast: UIButton? = nil
        for (index, dic) in dicArray.enumerated() {
            let btn = UIButton(type: UIButton.ButtonType.custom)
            btn.width = kScreenWidth * 0.25
            btn.height = viewClickBg.height
            btn.top = 0
            btn.left = btnLast == nil ? 0 : (btnLast?.right)!
            btn.setImage(UIImage(named: dic["icon"]!), for: UIControl.State.normal)
            btn.setImage(UIImage(named: dic["icon"]!), for: UIControl.State.highlighted)
            btn.setTitle(dic["title"], for: UIControl.State.normal)
            btn.setTitleColor(UIColor.colorWidthHexString(hex: "BFBFBF"), for: UIControl.State.normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            btn.zs_setImagePositionType(type: ImagePositionType.top, spacing: 10)
            viewClickBg.addSubview(btn)
            btn.imageView?.addSubview(labelCount)
            btn.tag = index + 100
            btn.rx.tap.subscribe(onNext: {[weak self] in
                self?.subjectClickBtn.onNext(btn.tag)
            }).disposed(by: disposeBag)
            btnLast = btn
        }
        if let _ = btnLast {
            btnLast?.addSubview(labelCount)
            labelCount.left = (btnLast?.width)! - 45
        }
    }
    
    private func endMove() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.imageHeadIcon.origin = CGPoint(x: 16, y: self.headIconBg.height * 0.5 - 25)
        }, completion: { (finish) in
            self.headIconBg.addSubview(self.imageHeadIcon)
            self.moveView.removeFromSuperview()
        })
    }
}


class BSMineCell: BSCommentCell {
    
    
    override func setupUI() {
        super.setupUI()
        contentView.backgroundColor = kMainBackBgColor
        line.top = 61.5
        
        contentView.addSubview(labelMineTitle)
        contentView.layer.addSublayer(line)
    }
    
    var title: String?{
        didSet{
            labelMineTitle.text = title
        }
    }
    
    
    private lazy var labelMineTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 15)
        title.textColor = UIColor.colorWidthHexString(hex: "BFBFBF")
        title.left = kSpacing
        title.size = CGSize(width: 200, height: 22)
        title.top = 20
        title.text = "给我一首歌的十几件"
        return title
    }()
}

