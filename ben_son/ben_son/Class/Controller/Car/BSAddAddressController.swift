//
//  BSAddAddressController.swift
//  ben_son
//
//  Created by ZS on 2018/9/26.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift
import ContactsUI


class BSAddAddressController: BSInputViewController {

    let disposeBag = DisposeBag()
    
    let publish_sent = PublishSubject<AddressList>()
    

    let viewModel = BSAddAddressViewModel()
    
    let param = BSAddAddressParam()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setupUI() {
        super.setupUI()
        title = "添加地址"
        scrollViewMain.addSubview(namePhoneView)
        scrollViewMain.addSubview(areaView)
        scrollViewMain.addSubview(detailAddressView)
        view.addSubview(btnSave)
        
        namePhoneView.userNameView.textField.rx.text.orEmpty.bind(to: param.userName).disposed(by: disposeBag)
        namePhoneView.phoneView.textField.rx.text.orEmpty.bind(to: param.phoneNumber).disposed(by: disposeBag)
        detailAddressView.textView.rx.text.orEmpty.bind(to: param.detailAddress).disposed(by: disposeBag)

        
        btnSave.rx.tap.subscribe(onNext: {
            
        }).disposed(by: disposeBag)
        
        namePhoneView.btnChoosePeople.rx.tap.subscribe(onNext: { [weak self] in
            BSTool.requestAuthorizationAddressBook(completion: { (isSuccess) in
                if isSuccess {
                    self?.openContactController()
                }
            })
        }).disposed(by: disposeBag)
        
        areaView.btnChooseAddress.rx.tap.subscribe(onNext: { [weak self] in
            self?.view.endEditing(true)
            BSAddressChooseView.showAddressView(view: (self?.navigationController?.view)!, completion: { (address) in
                self?.param.address = address
               self?.areaView.btnChooseAddress.setTitle(address, for: UIControl.State.normal)
            })
        }).disposed(by: disposeBag)
        
        viewModel.result_Request?.subscribe(onNext: {[weak self] (finish) in
            if finish {
                self?.publish_sent.onNext((self?.viewModel.address)!)
                self?.navigationController?.popViewController(animated: true)
            }
        }).disposed(by: disposeBag)
        btnSave.rx.tap.subscribe(onNext: { [weak self] in
            if !(self?.param.judgeEmpty())! {
                return
            }
            self?.viewModel.publish_SentRequest.onNext((self?.param)!)
        }).disposed(by: disposeBag)
    }
    
    private lazy var namePhoneView: BSAddressUseMsgView = {
        let name = BSAddressUseMsgView()
        name.origin = CGPoint(x: 0, y: 0)
        return name
    }()
    
    private lazy var areaView: BSAddAreaView = {
        let area = BSAddAreaView()
        area.top = namePhoneView.bottom
        return area
    }()
    
    private lazy var detailAddressView: BSDetailAddressView = {
        let address = BSDetailAddressView()
        address.top = areaView.bottom
        return address
    }()
    
    
    private lazy var btnSave: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.size = CGSize(width: kScreenWidth, height: 50 + UIDevice.current.tabbarBottomHeight())
        btn.origin = CGPoint(x: 0, y: scrollViewMain.height - btn.height)
        btn.backgroundColor = kMainColor
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn.setTitle("保存并使用", for: UIControl.State.normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: UIDevice.current.isX() ? -34 : 0, left: 0, bottom: 0, right: 0)
        return btn
    }()

}

extension BSAddAddressController: CNContactPickerDelegate {
    
    
    private func openContactController() {
        let picker = CNContactPickerViewController.init()
        picker.delegate = self
        picker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
        self.present(picker, animated: true, completion: nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        if  let phoneNumber = contactProperty.value as? CNPhoneNumber {
            namePhoneView.phoneView.textField.text = phoneNumber.stringValue
            self.param.phoneNumber.value = phoneNumber.stringValue
        }
        let contact = contactProperty.contact
        namePhoneView.userNameView.textField.text = contact.familyName + contact.givenName
        param.userName.value = namePhoneView.userNameView.textField.text ?? ""
    }
}
