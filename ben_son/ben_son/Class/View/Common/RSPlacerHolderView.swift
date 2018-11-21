//
//  RSPlacerHolderView.swift
//  ben_son
//
//  Created by ZS on 2018/11/5.
//  Copyright © 2018 ZS. All rights reserved.
//

import UIKit
import RxSwift

class RSPlacerHolderView: UIView {

    let disposeBag = DisposeBag()
    
    let click_subject = PublishSubject<Bool>()
    

    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        super.init(frame: selfFrame)
        backgroundColor = UIColor.black
        addSubview(imageIconView)
        addSubview(labelTitle)
        addSubview(btn)
    }
    
    @objc func click_load() {
        startAnimal()
        click_subject.onNext(true)
    }
    
    func startAnimal() {
        labelTitle.isHidden = true
        btn.isHidden = true
        imageIconView.origin = CGPoint(x: (kScreenWidth - 200) * 0.5, y: kScreenHeight * 0.4)
        imageIconView.size = CGSize(width: 200, height: 62)
        imageIconView.animationImages = images
        imageIconView.animationRepeatCount = 1000
        imageIconView.animationDuration = 1
        imageIconView.startAnimating()
        
    }
    
    func stopAnimation() {
        imageIconView.stopAnimating()
        self.removeFromSuperview()
    }
    
    func showType(_ finish: Bool) {
        if finish {
            stopAnimation()
        }else{
            netError()
        }
    }
    
    func netError() {
        imageIconView.stopAnimating()
        imageIconView.animationImages = nil
        imageIconView.size = CGSize(width: 200, height: 200)
        imageIconView.origin = CGPoint(x: (kScreenWidth - 200) * 0.4, y: kScreenWidth * 0.4)
        imageIconView.image = UIImage(named: "net_error")
        labelTitle.top = imageIconView.bottom + 20
        btn.top = labelTitle.bottom + 20
        btn.isHidden = false
        labelTitle.isHidden = false
        
    }
    
    func noMoreData() {
        imageIconView.animationImages = nil
        imageIconView.size = CGSize(width: 200, height: 200)
        imageIconView.origin = CGPoint(x: (kScreenWidth - 200) * 0.4, y: kScreenWidth * 0.4)
        imageIconView.image = UIImage(named: "net_error")
        labelTitle.top = imageIconView.bottom + 20
        labelTitle.text = "暂时没有数据,请重试"
        btn.top = labelTitle.bottom + 20
        btn.isHidden = true
        labelTitle.isHidden = false
    }
    
    private lazy var imageIconView: UIImageView = {
        let iconView = UIImageView()
        iconView.size = CGSize(width: 200, height: 62)
        iconView.origin = CGPoint(x: (kScreenWidth - 200) * 0.5, y: kScreenHeight * 0.4)
        return iconView
    }()
    
    private lazy var labelTitle: UILabel = {
        let title = UILabel()
        title.left = kSpacing
        title.size = CGSize(width: kContentWidth, height: 20)
        title.textAlignment = .center
        title.text = "页面加载失败，请检查你的手机网络"
        title.textColor = UIColor.colorWidthHexString(hex: "53402F")
        title.isHidden = true
        return title
    }()
    lazy var btn: UIButton = {
        let b = UIButton(type: UIButton.ButtonType.custom)
        b.size = CGSize(width: 100, height: 32)
        b.left = (kScreenWidth - 100) * 0.5
        b.setTitle("重新加载", for: UIControl.State.normal)
        b.backgroundColor = kMainColor
        b.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        b.setTitleColor(UIColor.white, for: UIControl.State.normal)
        b.isHidden = true
        b.addTarget(self, action: #selector(click_load), for: UIControl.Event.touchUpInside)
        return b
    }()
    
    private lazy var images: [UIImage] = {
        var photos = [UIImage]()
        for index in 0...29 {
            let imageName = "loading" + String(index)
            photos.append(UIImage(named: imageName)!)
        }
        return photos
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
