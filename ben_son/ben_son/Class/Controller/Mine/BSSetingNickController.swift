//
//  BSSetingNickController.swift
//  ben_son
//
//  Created by ZS on 2018/10/12.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BSSetingNickController: BSBaseController {

    let inputSubject = PublishSubject<String>()
    let disposeBag = DisposeBag()
    var type: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        title = "设置昵称"
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: UIBarButtonItem.Style.plain, target: self, action: #selector(actionSave))
        
        view.addSubview(viewBg)
        viewBg.addSubview(labelName)
        viewBg.addSubview(textField)
        viewBg.addSubview(labelName)
        viewBg.layer.addSublayer(lineBottom)
        view.addSubview(labeldesc)
        
    }
    
    @objc func actionSave() {
        if textField.text != nil && (textField.text?.count)! > 0 {
            inputSubject.onNext(textField.text!)
            navigationController?.popViewController(animated: true)
        }
    }
    private lazy var viewBg: UIView = {
        let bg = UIView()
        bg.size = CGSize(width: kScreenWidth, height: 60)
        bg.origin = CGPoint(x: 0, y: 0)
        return bg
    }()
    
    private lazy var lineBottom: CALayer = {
        let line = CALayer()
        line.left = kSpacing
        line.width = kContentWidth
        line.top = 59.5
        line.height = 0.5
        line.backgroundColor = UIColor.colorWidthHexString(hex: "53402F").cgColor
        return line
    }()
    
    private lazy var labelName: UILabel = {
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 15)
        name.textColor = kMainColor
        name.size = CGSize(width: 40, height: 20)
        name.text = type == 0 ? "昵称" : "签名"
        name.origin = CGPoint(x: kSpacing, y: 20)
        return name
    }()
    
    private lazy var textField: UITextField = {
        let field = UITextField()
        field.font = UIFont.systemFont(ofSize: 15)
        field.textColor = UIColor.white
        field.backgroundColor = UIColor.black
        field.layer.masksToBounds = true
        field.size = CGSize(width: kScreenWidth - 120 , height: 30)
        field.origin = CGPoint(x: labelName.right + 50, y: 15)
        let attrString = NSAttributedString(string: type == 0 ? "请输入昵称" : "请输入个性签名", attributes: [NSAttributedString.Key.foregroundColor: UIColor.colorWidthHexString(hex: "53402F")])
        field.attributedPlaceholder = attrString
        return field
    }()
    
    private lazy var labeldesc: UILabel = {
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 15)
        name.textColor = UIColor.colorWidthHexString(hex: "5C5C5C")
        name.font = UIFont.systemFont(ofSize: 13)
        name.size = CGSize(width: kContentWidth, height: 20)
        name.text = type == 0 ? "设置完成后,其他人可以看到您的昵称" : "设置完成后,其他人可以看到您的签名"
        name.origin = CGPoint(x: kSpacing, y: viewBg.bottom + 10)
        return name
    }()
}
