//
//  BSLoginController.swift
//  ben_son
//
//  Created by ZS on 2018/9/14.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import MBProgressHUD

class BSLoginController: BSAccountController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    override func setupUI() {
        super.setupUI()
        scrollerMain.addSubview(iconView)
        scrollerMain.addSubview(textFieldView)
        scrollerMain.addSubview(buttonSure)
        buttonSure.top = textFieldView.bottom + 60
        buttonSure.rx.tap.subscribe(onNext: { [weak self] in
            let CodeVc = BSAccountCodeController()
            CodeVc.phoneNumber = self?.textFieldView.texteFieldPhone.text
            self?.navigationController?.pushViewController(CodeVc, animated: true)
            
        }).disposed(by: disposeBag)
        buttonClose.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController!.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        let viewModel = BSLoginViewModel.init(input: (phoneNumber: textFieldView.texteFieldPhone.rx.text.orEmpty.asDriver(), loginTaps: buttonSure.rx.tap.asSignal()), dependency: BSLoginService())
        
        viewModel.signupEnabled.drive(onNext: {[weak self] (value) in
            self?.buttonSure.isEnabled = value
            self?.buttonSure.alpha = value ? 1.0 : 0.7
        }).disposed(by: disposeBag)
        
    }

    
    private lazy var textFieldView: BSLoginTextFieldView = {
        let textView = BSLoginTextFieldView()
        textView.origin = CGPoint(x: 40, y: iconView.bottom + 10)
        return textView
    }()
    

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//
//    private lazy var phoneTextField: UITextField = {
//        let field = UITextField.init()
//        field.size = CGSize(width: kScreenWidth - 60, height: 30)
//        field.origin = CGPoint(x: 30, y: 100)
//        field.backgroundColor = UIColor.red
//        return field
//    }()
//
//    private lazy var codeTextField: UITextField = {
//        let code = UITextField.init()
//        code.size = phoneTextField.size
//        code.left = phoneTextField.left
//        code.top = phoneTextField.bottom + 20
//        code.backgroundColor = UIColor.yellow
//        return code
//    }()
//
//    private lazy var buttonLogin: UIButton = {
//        let btn = UIButton(type: UIButton.ButtonType.custom)
//        btn.size = codeTextField.size
//        btn.left = codeTextField.left
//        btn.top = codeTextField.bottom + 50
//        btn.backgroundColor = UIColor.orange
//        return btn
//    }()
//
//    private lazy var buttonGetCode: UIButton = {
//        let code = UIButton(type: UIButton.ButtonType.custom)
//        code.backgroundColor = UIColor.yellow
//        code.size = CGSize(width: 100, height: 40)
//        code.origin = CGPoint(x: 100, y: 500)
//        code.setTitleColor(UIColor.black, for: UIControl.State.normal)
//        return code
//    }()
//

}

extension BSLoginController {
    
//    private func setupUI() {
//        view.backgroundColor = UIColor.white
////        view.addSubview(imageViewBg)
////        view.addSubview(scrollerMain)
////        view.addSubview(buttonClose)
////
////        scrollerMain.addSubview(iconView)
////        scrollerMain.addSubview(codeTextField)
////        scrollerMain.addSubview(buttonLogin)
////        scrollerMain.addSubview(buttonGetCode)
//
//
////        let viewModel = BSLoginViewModel.init(input: (phoneNumber: phoneTextField.rx.text.orEmpty.asDriver(), code: codeTextField.rx.text.orEmpty.asDriver(), loginTaps: buttonLogin.rx.tap.asSignal()), dependency: BSLoginService())
////
////        viewModel.signupEnabled.drive(onNext: {[weak self] (value) in
////            self?.buttonLogin.isEnabled = value
////            self?.buttonLogin.alpha = value ? 1.0 : 0.3
////        }).disposed(by: disposeBag)
////
////        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
////
////        viewModel.signingIn.map{ !$0 }.drive(hud.rx.isHidden).disposed(by: disposeBag)
////
////        viewModel.signupResult.drive(onNext: {[weak self] (result) in
////            self?.showMessage(result ? "成功" : "失败")
////        }).disposed(by: disposeBag)
////        //按钮点击响应
////        buttonGetCode.rx.tap
////            .subscribe(onNext: { [weak self] in
////                Observable<TimeInterval>.timer(duration: 60, interval: 1).map({ (a) -> String in
////                    let time = Int(a)
////                    return time == 0 ? "60" : String(time)
////                }).bind(to: self!.buttonClose.rx.title()).disposed(by: (self?.disposeBag)!)
////            }).disposed(by: disposeBag)
////
////        buttonClose.rx.tap
////            .subscribe(onNext: { [weak self] in
////                self?.dismiss(animated: true, completion: nil)
////            })
////            .disposed(by: disposeBag)
//
//    }
}
