//
//  BSAccountCodeController.swift
//  ben_son
//
//  Created by ZS on 2018/9/17.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift
import MBProgressHUD
class BSAccountCodeController: BSAccountController {

    
    private var viewModel: BSAccountCodeViewModel?
    
    var phoneNumber: String? {
        didSet{
            labelTitlePromat.text = "验证码已经发至" + phoneNumber!
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        buttonClose.setImage(UIImage(named: "common_back"), for: UIControl.State.normal)
        buttonClose.setImage(UIImage(named: "common_back"), for: UIControl.State.highlighted)
        iconView.titleString = "验证码"
        scrollerMain.addSubview(mainView)
        mainView.addSubview(iconView)
        mainView.addSubview(buttonGetCode)
        mainView.addSubview(inputCodeView)
        mainView.addSubview(labelTitlePromat)
        mainView.addSubview(buttonSure)
        buttonSure.top = labelTitlePromat.bottom + 40
        inputCodeView.textField.becomeFirstResponder()
        
        viewModel = BSAccountCodeViewModel.init(input: (phoneNumber: phoneNumber!, code: inputCodeView.textField.rx.text.orEmpty.asDriver(), loginTaps: buttonSure.rx.tap.asSignal()), dependency: BSLoginService())        
        viewModel!.signupEnabled.drive(onNext: {[weak self] (value) in
            self?.buttonSure.isEnabled = value
            self?.buttonSure.alpha = value ? 1.0 : 0.7
        }).disposed(by: disposeBag)
        
        //按钮点击响应
        buttonGetCode.rx.tap.subscribe(onNext: { [weak self] in
            self?.buttonGetCode.isUserInteractionEnabled = false
            self?.setupTimer()
        }).disposed(by: disposeBag)
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        //当前是否正在注册，决定指示器是否显示
        viewModel!.signingIn
            .map{ !$0 }
            .drive(hud.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel!.signupResult.drive(onNext: {[weak self] (finish) in
            if finish {
            
                self?.navigationController?.dismiss(animated: true, completion: nil)
            }
        }).disposed(by: disposeBag)
        
        buttonClose.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }

    
    private lazy var mainView: UIView = {
        let main = UIView()
        main.origin = CGPoint(x: 0, y: 0)
        main.size = CGSize(width: kScreenWidth, height: kScreenHeight)
        return main
    }()
    
    private lazy var buttonGetCode: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.size = CGSize(width: 100, height:   23)
        btn.top = iconView.top
        btn.left = kScreenWidth - 140
        btn.contentHorizontalAlignment = .right
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(UIColor.colorWidthHexString(hex: "604F3E"), for: UIControl.State.normal)
        btn.setTitleColor(UIColor.colorWidthHexString(hex: "604F3E"), for: UIControl.State.highlighted)
        btn.setTitle("点击获取验证码", for: UIControl.State.normal)
        return btn
    }()
    
    private lazy var inputCodeView: CodeInputView = {
        let input = CodeInputView()
        input.left = 60
        input.top = iconView.bottom + 30
        return input
    }()
    
    private lazy var labelTitlePromat: UILabel = {
        let promat = UILabel.init()
        promat.font = UIFont.systemFont(ofSize: 14)
        promat.textColor = UIColor.colorWidthHexString(hex: "604F3E")
        promat.top = inputCodeView.bottom + 16
        promat.left = 60
        promat.size = CGSize(width: kScreenWidth - 120, height: 20)
        promat.textAlignment = NSTextAlignment.center
        return promat
    }()
}

extension BSAccountCodeController {
    
    private func setupTimer() {
        viewModel?.getCode(phone: phoneNumber!)
        Observable<TimeInterval>.timer(duration: 60, interval: 1).map({ (a) -> String in
            let time = Int(a)
            return time == 0 ? "重新发送" : (String(time) + "后重发")
        }).subscribe(onNext: {[weak self] (timeStr) in
            self?.buttonGetCode.setTitle(timeStr, for: UIControl.State.normal)
        }, onCompleted: {[weak self] in
            self?.buttonGetCode.isUserInteractionEnabled = true
        }).disposed(by: disposeBag)
    }
}
