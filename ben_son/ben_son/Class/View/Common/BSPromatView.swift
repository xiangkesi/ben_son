//
//  BSPromatView.swift
//  ben_son
//
//  Created by ZS on 2018/11/7.
//  Copyright © 2018 ZS. All rights reserved.
//

import UIKit

enum Prompt_type: Int {
    case prompt_type_sure
    
    case prompt_type_cancel
    
    case prompt_type_all
}

class BSPromatView: UIView {
    
    private var prompt_type: Prompt_type = .prompt_type_all
    private var click_btn:((_ prompt: Prompt_type) -> ())?
    
    class func show_prompt(_ type: Prompt_type,_ title: String,_ view: UIView = (kRootVc?.view)!, complete:@escaping ((_ type: Prompt_type) -> ())) {
        let showView = BSPromatView()
        showView.prompt_type = type
        showView.click_btn = complete
        showView.labelTitle.text = title
        view.addSubview(showView)
        showView.playAnimationBounce()
    }
    
    private func playAnimationBounce() {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [0.1, 1.1]
        bounceAnimation.duration = 0.25
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        bounceAnimation.isRemovedOnCompletion = true
        viewBg.layer.add(bounceAnimation, forKey: nil)
    }
    
    @objc func click_sure() {
        click_btn!(prompt_type)
        self.removeFromSuperview()
    }
    
    @objc func click_cancel() {
        self.removeFromSuperview()
    }


    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        super.init(frame: selfFrame)
        
        addSubview(viewBg)
        viewBg.addSubview(labelTitle)
        if prompt_type == .prompt_type_all {
            viewBg.addSubview(btnCancel)
            viewBg.addSubview(btnSure)
            btnCancel.origin = CGPoint(x: 0, y: viewBg.height - 50)
            btnCancel.size = CGSize(width: viewBg.width * 0.5, height: 50)
            
            btnSure.origin = CGPoint(x: btnCancel.right, y: btnCancel.top)
            btnSure.size = CGSize(width: viewBg.width * 0.5, height: 50)

        }else if prompt_type == .prompt_type_sure {
            viewBg.addSubview(btnSure)
            btnSure.origin = CGPoint(x: 0, y: viewBg.height - 50)
            btnSure.size = CGSize(width: viewBg.width, height: 50)
        }else{
            viewBg.addSubview(btnCancel)
            btnCancel.origin = CGPoint(x: 0, y: viewBg.height - 50)
            btnCancel.size = CGSize(width: viewBg.width, height: 50)
        }
        viewBg.layer.addSublayer(lineTop)
        
    }
    
    private lazy var viewBg: UIView = {
        let bg = UIView()
        bg.size = CGSize(width: kScreenWidth - 100, height: (kScreenWidth - 100) * 0.55)
        bg.origin = CGPoint(x: 50, y: (kScreenHeight - bg.height) * 0.5)
        bg.backgroundColor = UIColor.white
        bg.zs_cutCorner(sizeHeigt: CGSize(width: 5, height: 5))
        return bg
    }()
    
    private lazy var labelTitle: UILabel = {
        let title = UILabel()
        title.origin = CGPoint(x: 20, y: 10)
        title.size = CGSize(width: viewBg.width - 40, height: viewBg.height - 70)
        title.font = UIFont.systemFont(ofSize: 14)
        title.numberOfLines = 0
        title.textAlignment = .center
        return title
    }()
    
    private lazy var btnCancel: UIButton = {
        let cancel = UIButton(type: UIButton.ButtonType.custom)
        cancel.size = CGSize(width: viewBg.width * 0.5, height: 50)
        cancel.origin = CGPoint(x: 0, y: viewBg.height - 50)
        let line = CALayer()
        line.origin = CGPoint(x: cancel.right - 0.5, y: 0)
        line.frameSize = CGSize(width: 0.5, height: 50)
        line.backgroundColor = UIColor.colorWidthHexString(hex: "DDDDDD").cgColor
        cancel.layer.addSublayer(line)
        cancel.addTarget(self, action: #selector(click_cancel), for: UIControl.Event.touchUpInside)
        cancel.setTitle("取消", for: UIControl.State.normal)
        cancel.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cancel.setTitleColor(UIColor.colorWidthHexString(hex: "333333"), for: UIControl.State.normal)
        return cancel
    }()
    
    private lazy var btnSure: UIButton = {
        let sure = UIButton(type: UIButton.ButtonType.custom)
        sure.size = CGSize(width: viewBg.width * 0.5, height: 50)
        sure.origin = CGPoint(x: 0, y: viewBg.height - 50)
        sure.addTarget(self, action: #selector(click_sure), for: UIControl.Event.touchUpInside)
        sure.setTitle("确定", for: UIControl.State.normal)
        sure.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        sure.setTitleColor(kMainColor, for: UIControl.State.normal)
        return sure
    }()
    
    private lazy var lineTop: CALayer = {
        let line = CALayer()
        line.origin = CGPoint(x: 0, y: viewBg.height - 50)
        line.frameSize = CGSize(width: viewBg.width, height: 0.5)
        line.backgroundColor = UIColor.colorWidthHexString(hex: "DDDDDD").cgColor
        return line
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
