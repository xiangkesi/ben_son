//
//  BSHostingInputView.swift
//  ben_son
//
//  Created by ZS on 2018/9/26.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import YYText
import RxSwift

class BSHostingInputView: UIView {

    let disposeBag = DisposeBag()
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 60)
        
        super.init(frame: selfFrame)
        backgroundColor = UIColor.colorWidthHexString(hex: "141414")
        addSubview(labelTitle)
        addSubview(textField)
        layer.addSublayer(lineBottom)
    }
    
    func setup(title: String, placerHolder: String) {
        let attrString = NSAttributedString(string: placerHolder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.colorWidthHexString(hex: "53402F")])
        textField.attributedPlaceholder = attrString
        labelTitle.text = title
    }
    
    
    private lazy var labelTitle: UILabel = {
        let title = UILabel()
        title.left = kSpacing
        title.height = 40
        title.top = 10
        title.width = 85
        title.textColor = kMainColor
        title.backgroundColor = UIColor.colorWidthHexString(hex: "141414")
        title.layer.masksToBounds = true
        title.font = UIFont.systemFont(ofSize: 15)
        return title
    }()
    
    lazy var textField: UITextField = {
        let field = UITextField()
        field.left = labelTitle.right
        field.top = labelTitle.top
        field.height = labelTitle.height
        field.width = kScreenWidth - 115
        field.font = UIFont.systemFont(ofSize: 15)
        field.textColor = kMainColor
        field.backgroundColor = UIColor.colorWidthHexString(hex: "141414")
        field.layer.masksToBounds = true
        return field
    }()
    
    private lazy var lineBottom: CALayer = {
        let line = CALayer.init()
        line.left = 0
        line.width = kScreenWidth
        line.height = 0.5
        line.top = height - line.height
        line.backgroundColor = UIColor.colorWidthHexString(hex: "1E1E1E").cgColor
        return line
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class BSHostingClickView: UIView {
    
    let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 60)
        
        super.init(frame: selfFrame)
        backgroundColor = UIColor.colorWidthHexString(hex: "141414")
        addSubview(labelTitle)
        addSubview(btnView)
        layer.addSublayer(lineBottom)
    }
    
    func setup(title: String, placerHolder: String) {
        labelTitle.text = title
        btnView.setTitle(placerHolder, for: UIControl.State.normal)
    }
    
    
    private lazy var labelTitle: UILabel = {
        let title = UILabel()
        title.left = kSpacing
        title.height = 40
        title.top = 10
        title.width = 85
        title.textColor = kMainColor
        title.backgroundColor = UIColor.colorWidthHexString(hex: "141414")
        title.layer.masksToBounds = true
        title.font = UIFont.systemFont(ofSize: 15)
        return title
    }()
    
    lazy var btnView: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.left = labelTitle.right
        btn.size = CGSize(width: kScreenWidth - 100, height: 40)
        btn.top = labelTitle.top
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(UIColor.colorWidthHexString(hex: "53402F"), for: UIControl.State.normal)
        btn.setTitleColor(kMainColor, for: UIControl.State.selected)
        btn.contentHorizontalAlignment = .left
        btn.backgroundColor = UIColor.colorWidthHexString(hex: "141414")
        btn.layer.masksToBounds = true
        return btn
    }()
    
    private lazy var lineBottom: CALayer = {
        let line = CALayer.init()
        line.left = 0
        line.width = kScreenWidth
        line.height = 0.5
        line.top = height - line.height
        line.backgroundColor = UIColor.colorWidthHexString(hex: "1E1E1E").cgColor
        return line
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class BSHostingCarPhoto: UIView {
    
    let disposeBag = DisposeBag()
    
    let subjectPhoto = PublishSubject<Int>()
    
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: (kContentWidth - 15) * 0.75 + 110)
        super.init(frame: selfFrame)
        
        layer.addSublayer(lineTop)
        addSubview(labelTitle)
        addSubview(btnCarPhoto)
        addSubview(btnLicensePhoto)
        addSubview(btnInsurancePhoto)
        addSubview(btnBusinessPhoto)
        
        layer.addSublayer(lineBottom)
        
        
    }
    
    @objc func tapGesAction(btn: UITapGestureRecognizer) {
        subjectPhoto.onNext((btn.view?.tag)!)
//        subjectPhoto.onNext(btn.tag)
    }
    
    private lazy var lineTop: CALayer = {
        let line = CALayer.init()
        line.frameSize = CGSize(width: kScreenWidth, height: 10)
        line.backgroundColor = UIColor.colorWidthHexString(hex: "181818").cgColor
        line.origin = CGPoint(x: 0, y: 0)
        return line
    }()
    private lazy var labelTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 15)
        title.textColor = kMainColor
        title.text = "车辆照片"
        title.left = kSpacing
        title.size = CGSize(width: 100, height: 60)
        title.top = lineTop.bottom
        return title
    }()
    
    lazy var btnCarPhoto: UIImageView = {
        let btn = UIImageView()
        btn.left = kSpacing
        btn.width = (kContentWidth - 15) * 0.5
        btn.height = (kContentWidth - 15) * 0.375
        btn.top = labelTitle.bottom
        btn.zs_cutCornerAndBorder(sizeHeigt: CGSize(width: 5, height: 5), boderColor: kMainColor)
        btn.image = UIImage(named: "image_cert_01")
        btn.tag = 100
        btn.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesAction(btn:)))
        btn.addGestureRecognizer(tap)
        btn.contentMode = UIView.ContentMode.scaleAspectFit
        return btn
    }()
    
    lazy var btnLicensePhoto: UIImageView = {
        let btn = UIImageView()
        btn.left = btnCarPhoto.right + kSpacing
        btn.width = (kContentWidth - 15) * 0.5
        btn.height = (kContentWidth - 15) * 0.375
        btn.top = labelTitle.bottom
        btn.zs_cutCornerAndBorder(sizeHeigt: CGSize(width: 5, height: 5), boderColor: kMainColor)
        btn.image = UIImage(named: "image_cert_02")
        btn.tag = 200
        btn.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesAction(btn:)))
        btn.addGestureRecognizer(tap)
        btn.contentMode = UIView.ContentMode.scaleAspectFit
        return btn
    }()
    
    lazy var btnInsurancePhoto: UIImageView = {
        let btn = UIImageView()
        btn.left = kSpacing
        btn.width = (kContentWidth - 15) * 0.5
        btn.height = (kContentWidth - 15) * 0.375
        btn.top = btnCarPhoto.bottom + 15
        btn.zs_cutCornerAndBorder(sizeHeigt: CGSize(width: 5, height: 5), boderColor: kMainColor)
        btn.image = UIImage(named: "image_cert_03")
        btn.tag = 300
        btn.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesAction(btn:)))
        btn.addGestureRecognizer(tap)
        btn.contentMode = UIView.ContentMode.scaleAspectFit
        return btn
    }()
    
    lazy var btnBusinessPhoto: UIImageView = {
        let btn = UIImageView()
        btn.left = btnInsurancePhoto.right + kSpacing
        btn.width = (kContentWidth - 15) * 0.5
        btn.height = (kContentWidth - 15) * 0.375
        btn.top = btnLicensePhoto.bottom + kSpacing
        btn.zs_cutCornerAndBorder(sizeHeigt: CGSize(width: 5, height: 5), boderColor: kMainColor)
        btn.tag = 400
        btn.image = UIImage(named: "image_cert_04")
        btn.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesAction(btn:)))
        btn.addGestureRecognizer(tap)
        btn.contentMode = UIView.ContentMode.scaleAspectFit
        return btn
    }()
    
    private lazy var lineBottom: CALayer = {
        let line = CALayer.init()
        line.frameSize = CGSize(width: kScreenWidth, height: 10)
        line.backgroundColor = UIColor.colorWidthHexString(hex: "181818").cgColor
        line.origin = CGPoint(x: 0, y: height - 10)
        return line
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


class BSHostingUseTypeView: UIView {
    
    private let disposeBag = DisposeBag()
    
    var titleString: String?
    
    private var btnArrays = [UIButton]()
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 167)
        super.init(frame: selfFrame)
        
        layer.addSublayer(lineBottom)
        addSubview(labelTitle)
        
        creatBtns()
    }
    
    @objc func actionClick(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        titleString = ""
        for btn in btnArrays {
            if btn.isSelected {titleString = titleString! + String(btn.tag) + ","}
        }
    }
    
    private lazy var labelTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 15)
        title.textColor = kMainColor
        title.text = "使用范围"
        title.left = kSpacing
        title.size = CGSize(width: 100, height: 55)
        title.top = 0
        return title
    }()
    
    private func creatBtns() {
        let arrays = ["自驾用车","婚庆用车","商务用车","展示用车","机场用车","影视用车"]
        for (index, stringTitle) in arrays.enumerated() {
            let btn = UIButton.init(type: UIButton.ButtonType.custom)
            btnArrays.append(btn)
            btn.height = 36
            btn.width = (kContentWidth - 30) * 0.33
            btn.left = kSpacing + CGFloat(index % 3) * (btn.width + kSpacing)
            btn.top = labelTitle.height + CGFloat(Int(index / 3)) * btn.height + CGFloat(Int(index / 3)) * kSpacing
            btn.zs_cutCornerAndBorder(sizeHeigt: CGSize(width: 4, height: 4), boderColor: kMainColor)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            btn.setTitleColor(UIColor.white, for: UIControl.State.selected)
            btn.setTitleColor(kMainColor, for: UIControl.State.normal)
            btn.setTitle(stringTitle, for: UIControl.State.normal)
            btn.setTitle(stringTitle, for: UIControl.State.highlighted)
            btn.addTarget(self, action: #selector(actionClick(btn:)), for: UIControl.Event.touchUpInside)
            btn.tag = index
            addSubview(btn)
        }
        
    }
    
    private lazy var lineBottom: CALayer = {
        let line = CALayer.init()
        line.frameSize = CGSize(width: kScreenWidth, height: 10)
        line.backgroundColor = UIColor.colorWidthHexString(hex: "1E1E1E").cgColor
        line.origin = CGPoint(x: 0, y: height - 10)
        return line
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class BSHostingNoteView: UIView {
    let disposeBag = DisposeBag()
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 200)
        super.init(frame: selfFrame)
        addSubview(labelTitle)
        addSubview(textView)
    }
    
    
    var titleString: String?{
        didSet{
            labelTitle.text = titleString
        }
    }
    
    private lazy var labelTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 15)
        title.textColor = kMainColor
        title.text = "备注"
        title.left = kSpacing
        title.size = CGSize(width: 100, height: 55)
        title.top = 0
        return title
    }()
    
    lazy var textView: UITextView = {
        let text = UITextView()
        text.left = kSpacing
        text.top = labelTitle.bottom
        text.width = kContentWidth
        text.height = 100
        text.font = UIFont.systemFont(ofSize: 15)
        text.textColor = kMainColor
        text.placeHolderTextColor(placeholdStr: "如: 车中配备香薰;车中配备雨伞", placeholdColor: UIColor.colorWidthHexString(hex: "53402F"))
        text.backgroundColor = kMainBackBgColor
        return text
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class BSHostingBottomView: UIView {
    
    let disposeBag = DisposeBag()

    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: UIDevice.current.isX() ? 94 : 50)
        super.init(frame: selfFrame)
        backgroundColor = UIColor.colorWidthHexString(hex: "000000")
        addSubview(btnCall)
        addSubview(btnSummit)
    }
    
    
    private lazy var btnCall: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.left = 0
        btn.height = height
        btn.width = kScreenWidth * 0.33
        btn.top = 0
        btn.backgroundColor = UIColor.colorWidthHexString(hex: "E3D0B1")
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        btn.setTitle("电话咨询", for: UIControl.State.normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: UIDevice.current.isX() ? -30 : 0, left: 0, bottom: 0, right: 0)
        return btn
    }()
    
    lazy var btnSummit: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.left = btnCall.right
        btn.height = height
        btn.width = kScreenWidth - btnCall.width
        btn.top = btnCall.top
        btn.backgroundColor = kMainColor
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(UIColor.colorWidthHexString(hex: "D9D9D9"), for: UIControl.State.normal)
        btn.setTitle("立即提交", for: UIControl.State.normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: UIDevice.current.isX() ? -30 : 0, left: 0, bottom: 0, right: 0)

        return btn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
