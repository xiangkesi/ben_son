//
//  BSShareView.swift
//  ben_son
//
//  Created by ZS on 2018/10/29.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BSShareView: UIView {

    private let disposeBag = DisposeBag()
    
    private var com:((_ tag: PlatformType) -> ())?

    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        super.init(frame: selfFrame)
        
        setupUI()
    }
    
    
    @objc func clickBtn(btn: UIButton) {
        
        dismiss()
        if com != nil {
            switch btn.tag {
            case 100:
                com!(PlatformType.wechatType)
                break
            case 101:
                com!(PlatformType.WechatTimeLine)
                break
            case 102:
                com!(PlatformType.sinaType)
                break
            case 103:
                com!(PlatformType.qqType)
                break
            default:
                break
            }
        }
        
        
    }
    
    class func showShareView(_ view: UIView = (kRootVc?.view)!, complete:@escaping ((_ index: PlatformType) -> ())) {
        let showView = BSShareView()
        showView.com = complete
        view.addSubview(showView)
        UIView.animate(withDuration: 0.25) {
            showView.viewBottom.top = showView.height - showView.viewBottom.height
        }
    }
    
    
    private func dismiss() {
        UIView.animate(withDuration: 0.25, animations: {
            self.viewBottom.top = kScreenHeight
        }) { (finish) in
            self.removeFromSuperview()
        }
    }
    

    
    private lazy var line: CALayer = {
        let l = CALayer()
        l.frameSize = CGSize(width: kScreenWidth, height: 10)
        l.backgroundColor = UIColor.colorWidthHexString(hex: "F5F5F5").cgColor
        l.left = 0
        return l
    }()
    private lazy var viewBottom: UIView = {
        let bootom = UIView()
        bootom.backgroundColor = UIColor.white
        bootom.size = CGSize(width: kScreenWidth, height: kScreenWidth * 0.25 + 110 + UIDevice.current.tabbarBottomHeight())
        bootom.origin = CGPoint(x: 0, y: kScreenHeight)
        return bootom
    }()
    private lazy var labelTitle: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 30)
        title.font = UIFont.systemFont(ofSize: 13)
        title.text = "分享"
        title.textColor = UIColor.colorWidthHexString(hex: "333333")
        title.textAlignment = .center
        return title
    }()
    private lazy var btnCancel: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setTitle("取消", for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(UIColor.colorWidthHexString(hex: "333333"), for: UIControl.State.normal)
        btn.frame = CGRect(x: 0, y: line.bottom, width: kScreenWidth, height: 50)
        return btn
    }()
    private func creatBtns() {
        let dicArray = [["title":"好友","image":"share_wechat"], ["title":"朋友圈","image":"share_wechat_line"], ["title":"微博","image":"share_sina"], ["title":"QQ","image":"share_qq"]]
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
            btn.top = labelTitle.bottom
            btn.tag = index + 100
            btn.addTarget(self, action: #selector(clickBtn(btn:)), for: UIControl.Event.touchUpInside)
            viewBottom.addSubview(btn)
            lastBtn = btn
        }
        line.top = (lastBtn?.bottom)! + 20
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BSShareView {
    
    private func setupUI() {
        backgroundColor = UIColor.init(white: 0.2, alpha: 0.3)
        addSubview(viewBottom)
        viewBottom.addSubview(labelTitle)
        creatBtns()
        viewBottom.layer.addSublayer(line)
        viewBottom.addSubview(btnCancel)
        
        btnCancel.rx.tap.subscribe(onNext: {[weak self] in
            self?.dismiss()
        }).disposed(by: disposeBag)
    }
    

    
}
