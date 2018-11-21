//
//  BSSettingCell.swift
//  ben_son
//
//  Created by ZS on 2018/10/12.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift

class BSSettingCell: BSCommentCell {


    override func setupUI() {
        super.setupUI()
        contentView.backgroundColor = kMainBackBgColor
        contentView.addSubview(labelName)
        contentView.addSubview(imageArrow)
        contentView.addSubview(imageHead)
        contentView.addSubview(labelDesc)
        line.backgroundColor = UIColor.colorWidthHexString(hex: "322A21").cgColor
        contentView.layer.addSublayer(line)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        labelName.top = (contentView.height - 20) * 0.5
        imageArrow.top = (contentView.height - 20) * 0.5
        imageHead.top = (contentView.height - 42) * 0.5
        labelDesc.top = labelName.top
        line.top = contentView.height - 0.5
        
    }
    
    var seting: BSSeetingModel? {
        didSet{
            labelName.text = seting?.name
            labelDesc.text = seting?.describe
            imageHead.isHidden = seting?.type == 0 ? false : true
            labelDesc.isHidden = seting?.type == 0 ? true : false
            imageHead.zs_setImage(urlString: seting?.headUrl, placerHolder: seting?.image)
//            labelDesc.textColor = UIColor.colorWidthHexString(hex: (seting?.colorString)!)
        }
    }
    
    
    private lazy var labelName: UILabel = {
        let name = UILabel.init()
        name.left = kSpacing
        name.size = CGSize(width: 80, height: 20)
        name.textColor = kMainColor
        name.font = UIFont.systemFont(ofSize: 15)
        return name
    }()
    
    private lazy var labelDesc: UILabel = {
        let name = UILabel.init()
        name.left = labelName.right + 10
        name.size = CGSize(width: kScreenWidth - 150, height: 20)
        name.textColor = kMainColor
        name.font = UIFont.systemFont(ofSize: 15)
        name.textAlignment = .right
        return name
    }()
    
    private lazy var imageArrow: UIImageView = {
        let arrow = UIImageView()
        arrow.size = CGSize(width: 20, height: 20)
        arrow.left = kScreenWidth - 35
        arrow.contentMode = UIView.ContentMode.scaleAspectFit
        arrow.image = UIImage(named: "setting_icon_arrow")
        return arrow
    }()
    
    private lazy var imageHead: UIImageView = {
        let head = UIImageView()
        head.size = CGSize(width: 42, height: 42)
        head.left = kScreenWidth - 85
        head.zs_corner()
        return head
    }()

}

class BSSettingSexView: UIView {
    let disposeBag = DisposeBag()

    private var complete:((_ gender: Int) -> ())?
    
    private var selected: Int? {
        didSet {
            if selected == 1 {
                btnMan.isSelected = true
                btnWoMan.isSelected = false
            }else{
                btnMan.isSelected = false
                btnWoMan.isSelected = true
            }
        }
    }

    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        super.init(frame: selfFrame)
        
        backgroundColor = UIColor.init(white: 0.3, alpha: 0.3)
        addSubview(viewBg)
        viewBg.addSubview(btnMan)
        viewBg.layer.addSublayer(line)
        viewBg.addSubview(btnWoMan)
        
        if selected == 1 {
            btnMan.isSelected = true
            btnWoMan.isSelected = false
        }else{
            btnMan.isSelected = false
            btnWoMan.isSelected = true
        }
        
        let tap = UITapGestureRecognizer()
        tap.rx.event.subscribe(onNext: {[weak self] (sender) in
            self?.disMiss()
        }).disposed(by: disposeBag)
        addGestureRecognizer(tap)
        
    }
    
    class func showView(view: UIView = (kRootVc?.view)!,type: Int, completion:@escaping (_ gender: Int) -> ()) {
        let sexView = BSSettingSexView()
        sexView.complete = completion
        sexView.selected = type
        view.addSubview(sexView)
        UIView.animate(withDuration: 0.25) {
            sexView.viewBg.top = sexView.height - sexView.viewBg.height
        }
        
    }
    
    func disMiss() {
        UIView.animate(withDuration: 0.25, animations: {
            self.viewBg.top = self.height
        }) { (finish) in
            self.removeFromSuperview()
        }
    }
    
    @objc func clickBtn(btnC: UIButton) {
        if btnC == btnMan {
            btnMan.isSelected = true
            btnWoMan.isSelected = false
            
            
        }else{
            btnMan.isSelected = false
            btnWoMan.isSelected = true
        }
        
        disMiss()
        if complete != nil {
            complete!(btnC.tag)
        }
    }
    private lazy var viewBg: UIView = {
        let bg = UIView()
        bg.backgroundColor = UIColor.white
        bg.size = CGSize(width: kScreenWidth, height: UIDevice.current.tabbarBottomHeight() + 110)
        bg.origin = CGPoint(x: 0, y: height)
        return bg
    }()
    
    private lazy var btnMan: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 50)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitle("男", for: UIControl.State.normal)
        btn.backgroundColor = UIColor.white
        btn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        btn.setTitleColor(kMainColor, for: UIControl.State.selected)
        btn.isSelected = true
        btn.addTarget(self, action: #selector(clickBtn(btnC:)), for: UIControl.Event.touchUpInside)
        btn.tag = 1
        return btn
    }()
    private lazy var line: CALayer = {
        let l = CALayer()
        l.backgroundColor = UIColor.colorWidthHexString(hex: "FCFCFC").cgColor
        l.frame = CGRect(x: 0, y: btnMan.bottom, width: kScreenWidth, height: 5)
        return l
    }()
    private lazy var btnWoMan: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.frame = CGRect(x: 0, y: line.bottom, width: kScreenWidth, height: 50)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitle("女", for: UIControl.State.normal)
        btn.backgroundColor = UIColor.white
        btn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        btn.setTitleColor(kMainColor, for: UIControl.State.selected)
        btn.addTarget(self, action: #selector(clickBtn(btnC:)), for: UIControl.Event.touchUpInside)
        btn.tag = 2
        return btn
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
