//
//  BSFeedbackView.swift
//  ben_son
//
//  Created by ZS on 2018/9/20.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift
class BSFeedbackView: UIView {

    let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kContentWidth, height: 50)
        
        super.init(frame: selfFrame)
        
        setupUI()
    }
    
    
    func zs_setImageAndTitle(imageName: String, title: String) {
        imageIcon.image = UIImage(named: imageName)
        labelTitle.text = title
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var imageIcon: UIImageView = {
        let icon = UIImageView()
        icon.size = CGSize(width: 20, height: 20)
        icon.left = kSpacing
        icon.top = kSpacing
        return icon
    }()
    
    private lazy var labelTitle: UILabel = {
        let label = UILabel.init()
        label.left = imageIcon.right + 12
        label.size = CGSize(width: 50, height: 20)
        label.top = imageIcon.top
        label.backgroundColor = UIColor.black
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = kMainColor
        return label
    }()
    
    lazy var texteField: UITextField = {
        let field = UITextField.init()
        field.textColor = UIColor.white
        field.placeholder = "便于将反馈结果告诉您"
        let attr = NSAttributedString.init(string: "便于将反馈结果告诉您", attributes: [NSAttributedString.Key.foregroundColor : kMainColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
        field.font = UIFont.systemFont(ofSize: 15)
        field.attributedPlaceholder = attr
        field.top = 10
        field.left = labelTitle.right
        field.size = CGSize(width: width - labelTitle.right - 15, height: 30)
        return field
    }()
}

extension BSFeedbackView {
    
    private func setupUI() {
        zs_setBorder()
        addSubview(imageIcon)
        addSubview(labelTitle)
        addSubview(texteField)
        
    }
}
