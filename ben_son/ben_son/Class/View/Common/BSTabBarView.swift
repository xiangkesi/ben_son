//
//  BSTabBarView.swift
//  ben_son
//
//  Created by ZS on 2018/9/20.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BSTabBarView: UITabBar {
    let disposeBag = DisposeBag()

    private lazy var addView: BSAddBtnView = {
        let add = BSAddBtnView()
        let tap = UITapGestureRecognizer()
        add.addGestureRecognizer(tap)
        tap.rx.event.subscribe(onNext: { (tap) in
            let vc = BSConsultingController()
            let nav = BSNavgationController.init(rootViewController: vc)
            kRootVc?.present(nav, animated: true, completion: nil)
        }).disposed(by: disposeBag)
        return add
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(addView)
    }
    
    override func layoutSubviews() {

        super.layoutSubviews()
        setupLayout()


    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BSTabBarView {
    
    private func setupLayout() {
        addView.top = -30
        addView.left = width * 0.5 - addView.width * 0.5
        
        let normalWidth = kScreenWidth * 0.2
        let centerWidth = kScreenWidth * 0.2
        
        var lastView: UIView? = nil
        var index = 0
        for btn in subviews {
             if btn.isKind(of: NSClassFromString("UITabBarButton")!){
                btn.width = index == 2 ? centerWidth : normalWidth
                btn.left = lastView == nil ? 0 : (lastView?.right)!
                index = index + 1
                lastView = btn
            }
        }
        bringSubviewToFront(addView)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if isHidden == false {
            let newA = convert(point, to: addView)
            if addView.point(inside: newA, with: event){
                return addView
            }else{
                return super.hitTest(point, with: event)
            }
        }else{
            return super.hitTest(point, with: event)
        }
    }
    
}

class BSAddBtnView: UIView {
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth * 0.2, height: 79)
        super.init(frame: selfFrame)
        
        addSubview(imageTopBg)
        addSubview(labelTitle)
        addSubview(imageView)
    }
    
    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white
        label.text = "一键咨询"
        label.left = 5
        label.width = width - 10
        label.textAlignment = NSTextAlignment.center
        label.height = 15
        label.top = height - 19
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let viewImage = UIImageView()
        viewImage.size = CGSize(width: 60, height: 60)
        viewImage.left = (width - viewImage.width) * 0.5
        viewImage.top = 4
        viewImage.isUserInteractionEnabled = true
        viewImage.image = UIImage(named: "tabbar_add_image")
        return viewImage
    }()
    
    private lazy var imageTopBg: UIImageView = {
        let imageTop = UIImageView()
        imageTop.contentMode = UIView.ContentMode.scaleAspectFit
        imageTop.size = CGSize(width: kScreenWidth, height: 30)
        imageTop.top = 0
        imageTop.left = -(kScreenWidth - width) * 0.5
        imageTop.image = UIImage(named: "tabbar_top_image")
        imageTop.isUserInteractionEnabled = true
        return imageTop
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
