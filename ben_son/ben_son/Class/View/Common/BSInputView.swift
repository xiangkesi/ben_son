//
//  BSInputView.swift
//  ben_son
//
//  Created by ZS on 2018/11/21.
//  Copyright © 2018 ZS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BSInputView: UIView {

    let disposeBag = DisposeBag()
    private var isTop: Bool = false
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 60)
        
        super.init(frame: selfFrame)
        backgroundColor = kMainBackBgColor
        addSubview(textField)
        addSubview(labelPlacholder)
        addBottomLine(UIEdgeInsets(top: 0, left: kSpacing, bottom: 0, right: kSpacing), UIColor.colorWidthHexString(hex: "1E1E1E"), 0.5)
    textField.rx.controlEvent(UIControlEvents.editingDidBegin).asObservable().subscribe(onNext: {[weak self] (text) in
            if self?.isTop == false {
                self?.isTop = true
                UIView.animate(withDuration: 0.1, animations: {
                    self?.labelPlacholder.font = UIFont.systemFont(ofSize: 12)
                    self?.labelPlacholder.top = 5
                    self?.textField.top = (self?.labelPlacholder.bottom)!
                })
            }
        }).disposed(by: disposeBag)
    textField.rx.controlEvent(UIControlEvents.editingDidEnd).asObservable().subscribe(onNext: {[weak self] (text) in
        if self?.textField.text == nil || self?.textField.text?.count == 0 {
            self?.isTop = false
            UIView.animate(withDuration: 0.1, animations: {
                self?.labelPlacholder.font = UIFont.systemFont(ofSize: 15)
                self?.labelPlacholder.top = 20
                self?.textField.top = 15
            })
        }
        }).disposed(by: disposeBag)
        
    }
    var placerholder: String? {
        didSet {
            labelPlacholder.text = placerholder
        }
    }
    
    
    private lazy var labelPlacholder: UILabel = {
        let placholder = UILabel()
        placholder.font = UIFont.systemFont(ofSize: 15)
        placholder.textColor = UIColor.colorWidthHexString(hex: "53402F")
        placholder.origin = CGPoint(x: kSpacing, y: 20)
        placholder.size = CGSize(width: kContentWidth, height: 20)
        return placholder
    }()
    
    lazy var textField: UITextField = {
        let field = UITextField()
        field.origin = CGPoint(x: kSpacing, y: 15)
        field.size = CGSize(width: kContentWidth, height: 30)
        field.font = UIFont.systemFont(ofSize: 15)
        field.textColor = kMainColor
        return field
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class BSClickBtnView: UIView {
    
    let disposeBag = DisposeBag()
    private var isTop: Bool = false
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 60)
        super.init(frame: selfFrame)
        
        backgroundColor = kMainBackBgColor
        addSubview(labelPlacholder)
        addSubview(btnClick)
        addBottomLine(UIEdgeInsets(top: 0, left: kSpacing, bottom: 0, right: kSpacing), UIColor.colorWidthHexString(hex: "1E1E1E"), 0.5)
    }
    
    var title: String? {
        didSet {
            labelPlacholder.text = title
        }
    }
    
    var text: String? {
        didSet {
            btnClick.setTitle(text, for: UIControl.State.normal)
            
            if isTop == false {
                isTop = true
                UIView.animate(withDuration: 0.1, animations: { [weak self] in
                    self?.labelPlacholder.font = UIFont.systemFont(ofSize: 12)
                    self?.labelPlacholder.top = 5
                    self?.btnClick.top = (self?.labelPlacholder.bottom)!
                })
            }
        }
    }
    
    
    
    private lazy var labelPlacholder: UILabel = {
        let placholder = UILabel()
        placholder.font = UIFont.systemFont(ofSize: 15)
        placholder.textColor = UIColor.colorWidthHexString(hex: "53402F")
        placholder.origin = CGPoint(x: kSpacing, y: 20)
        placholder.size = CGSize(width: kContentWidth, height: 20)
        return placholder
    }()
    
    lazy var btnClick: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.origin = CGPoint(x: kSpacing, y: 15)
        btn.size = CGSize(width: kContentWidth, height: 30)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(kMainColor, for: UIControl.State.normal)
        btn.contentHorizontalAlignment = .left
        return btn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
