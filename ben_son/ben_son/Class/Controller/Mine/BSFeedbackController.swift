//
//  BSFeedbackController.swift
//  ben_son
//
//  Created by ZS on 2018/9/20.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import RxSwift
import RxCocoa
class BSFeedbackController: BSBaseController {

    let viewModel = BSFeedbackViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setupUI() {
        super.setupUI()
        title = "帮助与反馈"
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(textView)
        mainScrollView.addSubview(emailView)
        mainScrollView.addSubview(phoneView)
        mainScrollView.addSubview(buttonSummit)
        
        
        emailView.texteField.rx.text.orEmpty.bind(to: viewModel.param.email).disposed(by: emailView.disposeBag)
        phoneView.texteField.rx.text.orEmpty.bind(to: viewModel.param.telephone).disposed(by: phoneView.disposeBag)
        textView.rx.text.orEmpty.bind(to: viewModel.param.proposal).disposed(by: disposeBag)
        
        buttonSummit.rx.tap.subscribe(onNext: { [weak self] in
            if self?.viewModel.param.proposal.value == "" {
                RSProgressHUD.showSuccessOrFailureHud(titleStr: "请输入要反馈的内容", (self?.view)!)
                return
            }
            self?.viewModel.publish_load.onNext(1)
        }).disposed(by: disposeBag)
        viewModel.result_request?.subscribe(onNext: {[weak self] (finish) in
            RSProgressHUD.showSuccessOrFailureHud(titleStr: "举报成功", (kRootVc?.view)!)
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    private lazy var mainScrollView: UIScrollView = {
        let mainScroll = TPKeyboardAvoidingScrollView.init()
        mainScroll.frame = view.frame
        mainScroll.alwaysBounceVertical = true
        return mainScroll
    }()
    
    private lazy var textView: UITextView = {
        let text = UITextView()
        text.origin = CGPoint(x: kSpacing, y: kSpacing)
        text.size = CGSize(width: kContentWidth, height: kContentWidth * 0.46)
        text.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        text.backgroundColor = kMainBackBgColor
        text.textColor = kMainColor
        text.font = UIFont.systemFont(ofSize: 15)
        text.placeHolderTextColor(placeholdStr: "请输入您的建议", placeholdColor: kMainColor)
        text.zs_setBorder()
        return text
    }()
    
    private lazy var emailView: BSFeedbackView = {
        let email = BSFeedbackView()
        email.left = kSpacing
        email.top = textView.bottom + 15
        email.zs_setImageAndTitle(imageName: "feedback_email", title: "邮箱")
        email.texteField.keyboardType = .emailAddress
        return email
    }()
    
    private lazy var phoneView: BSFeedbackView = {
        let phone = BSFeedbackView()
        phone.left = kSpacing
        phone.top = emailView.bottom + 15
        phone.zs_setImageAndTitle(imageName: "feedback_phone", title: "手机")
        phone.texteField.keyboardType = .numberPad
        return phone
    }()
    
    private lazy var buttonSummit: UIButton = {
        let summit = UIButton(type: UIButton.ButtonType.custom)
        summit.origin = CGPoint(x: kSpacing, y: phoneView.bottom + 60)
        summit.size = CGSize(width: kContentWidth, height: 48)
        summit.backgroundColor = kMainColor
        summit.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        summit.setTitleColor(UIColor.white, for: UIControl.State.normal)
        summit.setTitle("提交", for: UIControl.State.normal)
        return summit
    }()

}
