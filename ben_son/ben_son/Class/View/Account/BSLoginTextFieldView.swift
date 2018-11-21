//
//  BSLoginTextFieldView.swift
//  ben_son
//
//  Created by ZS on 2018/9/17.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift

class BSLoginTextFieldView: UIView {
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth - 80, height: 56)
        
        super.init(frame: selfFrame)
        
        
        setupUI()
    }
    
    private lazy var lineBottom: CALayer = {
        let line = CALayer()
        line.left = 0
        line.width = width
        line.height = 0.5
        line.top = height - 0.5
        line.backgroundColor = UIColor.colorWidthHexString(hex: "484037").cgColor
        return line
    }()
    
    lazy var texteFieldPhone: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.white
        textField.left = 0
        textField.size = CGSize(width: kScreenWidth - 135, height: 30)
        textField.placeholder = "在这里输入手机号"
        let attrString = NSAttributedString(string: "在这里输入手机号", attributes: [NSAttributedString.Key.foregroundColor: UIColor.colorWidthHexString(hex: "604F3E")])
        textField.attributedPlaceholder = attrString
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.top = 13
        textField.keyboardType = .numberPad

        return textField
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BSLoginTextFieldView {
    
    private func setupUI() {
        layer.addSublayer(lineBottom)
        addSubview(texteFieldPhone)
    }
    

}


class BSLoginIconView: UIView {
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: 200, height: 23)
        super.init(frame: selfFrame)
        
        
        addSubview(imagePhoneView)
        addSubview(labelTitle)
    }
    
    var titleString: String? {
        didSet{
            labelTitle.text = titleString
        }
    }
    
    
    private lazy var imagePhoneView: UIImageView = {
        let icon = UIImageView()
        icon.origin = CGPoint(x: 0, y: 0)
        icon.size = CGSize(width: 23, height: 23)
        icon.image = UIImage(named: "account_phone")
        return icon
    }()
    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.left = imagePhoneView.right + 16
        label.top = 0
        label.size = CGSize(width: 100, height: 23)
        label.textColor = UIColor.colorWidthHexString(hex: "919191")
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CodeInputView: UIView {
    
    private let disposeBag = DisposeBag()
    
    private var arrayLabels = [UILabel]()

    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth - 120, height: 36)
        super.init(frame: selfFrame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var textField: UITextField = {
        let field = UITextField.init()
        field.origin = CGPoint(x: 0, y: 0)
        field.size = CGSize(width: width, height: height)
        field.textColor = UIColor.clear
        field.tintColor = UIColor.clear
        field.autocapitalizationType = .none
        field.keyboardType = .numberPad
        field.delegate = self
        return field
    }()
}

extension CodeInputView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }else if string.count == 0 {
            return true
        }else if (textField.text?.count)! >= 4 {
            textField.resignFirstResponder()
            return false
        }else{
            return true
        }
    }
    private func setupUI() {
        creatView()
        addSubview(textField)
        
        //当文本框内容改变时，将内容输出到控制台上
        textField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: {
                let text = $0
                for label in self.arrayLabels {
                    label.text = nil
                }
                for (index, t) in text.enumerated() {
                    self.arrayLabels[index].text = String(t)
                }
                
            }).disposed(by: disposeBag)
    }
    
    private func creatView() {
        let space = (width - 36 * 4) / 3
        
        for index in 0...3 {
            let viewInput = UILabel()
            arrayLabels.append(viewInput)
            viewInput.size = CGSize(width: height, height: height)
//            viewInput.zs_cutCorner(sizeHeigt: CGSize(width: 5, height: 5))
            viewInput.top = 0
            viewInput.left = CGFloat(index) * height + CGFloat(index) * space
//            viewInput.backgroundColor = UIColor.white
            viewInput.textAlignment = NSTextAlignment.center
            viewInput.zs_cutCornerAndBorder(sizeHeigt: CGSize(width: 5, height: 5), boderColor: UIColor.colorWidthHexString(hex: "A98054"), boderWidth: 1)
            viewInput.textColor = UIColor.white
            addSubview(viewInput)

        }
    }
}

