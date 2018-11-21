//
//  BSReservationController.swift
//  ben_son
//
//  Created by ZS on 2018/9/26.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BSReservationController: BSInputViewController {

    
    private let viewModel = BSReservationViewModel()
    private let param = BSReservationParam()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var detail: CarDetailModel? {
        didSet{
            carNameView.labelDetail.text = detail?.brand
            brandView.labelDetail.text = detail?.model
            praceView.deposit = String(detail?.car_deposit ?? 10000)
            bottomView.btnCall.setTitle("需支付定金¥\(detail?.car_deposit ?? 10000)", for: UIControl.State.normal)
            if let colors = detail?.colors {
                colors.first?.isSelected = true
                param.car_id = (colors.first?.colorId)!
                colorView.colors = colors
            }
        }
    }
    
    
    override func setupUI() {
        super.setupUI()
        title = "在线预定"
        scrollViewMain.addSubview(carNameView)
        scrollViewMain.addSubview(brandView)
        scrollViewMain.addSubview(colorView)
        scrollViewMain.addSubview(colorChangeView)
        scrollViewMain.addSubview(praceView)
        scrollViewMain.addSubview(locationView)
        scrollViewMain.addSubview(userNameView)
        scrollViewMain.addSubview(phoneView)
        scrollViewMain.addSubview(contactAddressView)
        scrollViewMain.addSubview(wechatView)
        scrollViewMain.addSubview(noteView)
        scrollViewMain.addSubview(argueView)
        view.addSubview(bottomView)
        
        colorChangeView.switchView.rx.isOn
            .bind(to: param.is_exchange_color)
            .disposed(by: colorChangeView.disposeBag)
        
        locationView.locationView.btnLeftAddress.rx.tap.subscribe(onNext: {[weak self] in
            self?.view.endEditing(true)
            BSAddressChooseView.showAddressView(view: (kRootVc?.view)!, true, completion: {[weak self] (address) in
                self?.locationView.locationView.btnLeftAddress.setTitle(address, for: UIControl.State.normal)
                self?.param.removed_city = address
            })
        }).disposed(by: locationView.disposeBag)
        locationView.locationView.btnRightAddress.rx.tap.subscribe(onNext: {[weak self] in
            self?.view.endEditing(true)
            BSAddressChooseView.showAddressView(view: (kRootVc?.view)!, true, completion: {[weak self] (address) in
                self?.locationView.locationView.btnRightAddress.setTitle(address, for: UIControl.State.normal)
                self?.param.returned_city = address
            })
        }).disposed(by: locationView.disposeBag)
        locationView.carWayView.subjectCarWay.subscribe(onNext: {[weak self] (type) in
            self?.param.remove_type = type
        }).disposed(by: locationView.disposeBag)
        
        userNameView.textField.rx.text.orEmpty.bind(to: param.name).disposed(by: userNameView.disposeBag)
        phoneView.textField.rx.text.orEmpty.bind(to: param.telephone).disposed(by: phoneView.disposeBag)
        contactAddressView.textField.rx.text.orEmpty.bind(to: param.address).disposed(by: contactAddressView.disposeBag)
        wechatView.textField.rx.text.orEmpty.bind(to: param.wechat_id).disposed(by: wechatView.disposeBag)

        noteView.textView.rx.text.orEmpty.bind(to: param.remark).disposed(by: noteView.disposeBag)
        bottomView.btnSummit.rx.tap.subscribe(onNext: {[weak self] in
            if !(self?.param.judjeEmpty())! { return }
            self?.viewModel.subjectSent.onNext((self?.param)!)
        }).disposed(by: bottomView.disposeBag)
        viewModel.summitResult!.subscribe(onNext: {[weak self] (finish) in
            if finish {
                let vc = BSChoosePayController()
                vc.isPopToHome = true
                vc.msg = self?.viewModel.orderModel
                self?.navigationController?.pushViewController(vc, animated: true)
            }else{
                RSProgressHUD.showSuccessOrFailureHud(titleStr: "提交失败,请重试", (self?.view)!)
            }
            
           
        }).disposed(by: viewModel.disposeBag)
        
        locationView.addressView.btnView.rx.tap.subscribe(onNext: {[weak self] in
            self?.view.endEditing(true)
            let addressList = BSAddressListController()
            addressList.publish_sent.subscribe(onNext: {[weak self] (address) in
                self?.param.removed_address = address
                self?.locationView.addressView.btnView.setTitle(address, for: UIControl.State.normal)
            }).disposed(by: addressList.disposeBag)
            self?.navigationController?.pushViewController(addressList, animated: true)
        }).disposed(by: locationView.disposeBag)
        locationView.btnDate.rx.tap.subscribe(onNext: {[weak self] in
            self?.view.endEditing(true)
            let searchVc = CalendarController()
            searchVc.calendarControllerBlock = {(dic) in
                if let dicMsg = dic as? [String: String] {
                    self?.param.removed_time = dicMsg["begin_time"]
                    self?.param.returned_time = dicMsg["end_time"]
                    self?.param.days = Int(dicMsg["days"]!)!
                    self?.praceView.allPrace = String(Int(dicMsg["days"] ?? "1")! * (self?.detail?.car_deposit ?? 1))
                    self?.locationView.dic = dicMsg
                }
            }
            let nav = BSNavgationController.init(rootViewController: searchVc)
            self?.present(nav, animated: true, completion: nil)
        }).disposed(by: locationView.disposeBag)
        
        colorView.selectedCarId.subscribe(onNext: {[weak self] (colorId) in
            self?.param.car_id = colorId.colorId
        }).disposed(by: colorView.disposeBag)
    }

    
    private lazy var carNameView: BSReservationView = {
        let name = BSReservationView()
        name.setup(title: "名字")
        name.origin = CGPoint(x: 0, y: 0)
        return name
    }()
    
    private lazy var brandView: BSReservationView = {
        let brand = BSReservationView()
        brand.setup(title: "车辆型号")
        brand.origin = CGPoint(x: 0, y: carNameView.bottom)
        return brand
    }()
    
    private lazy var colorView: BSReservationColorView = {
        let color = BSReservationColorView()
        color.setup(title: "车辆颜色", isColor: true)
        color.origin = CGPoint(x: 0, y: brandView.bottom)
        return color
    }()
    
    private lazy var colorChangeView: BSReservationColorView = {
        let color = BSReservationColorView()
        color.setup(title: "是否接受颜色调换", isColor: false)
        color.origin = CGPoint(x: 0, y: colorView.bottom)
        return color
    }()
    
  
    
    
    private lazy var locationView: BSReservationLocationView = {
        let location = BSReservationLocationView()
        location.top = colorChangeView.bottom
        return location
    }()
    
    private lazy var praceView: BSOrderAllPraceView = {
        let prace = BSOrderAllPraceView()
        prace.top = locationView.bottom
        return prace
    }()
    
    private lazy var userNameView: BSHostingInputView = {
        let name = BSHostingInputView()
        name.setup(title: "名字", placerHolder: "请输入您的姓名")
        name.origin = CGPoint(x: 0, y: praceView.bottom)
        return name
    }()
    
    private lazy var phoneView: BSHostingInputView = {
        let phone = BSHostingInputView()
        phone.setup(title: "手机号码", placerHolder: "请输入您的手机号")
        phone.origin = CGPoint(x: 0, y: userNameView.bottom)
        phone.textField.keyboardType = .numberPad
        return phone
    }()
    
    private lazy var contactAddressView: BSHostingInputView = {
        let contactAddress = BSHostingInputView()
        contactAddress.setup(title: "联系地址", placerHolder: "请输入您的联系地址(选填)")
        contactAddress.origin = CGPoint(x: 0, y: phoneView.bottom)
        return contactAddress
    }()
    
    private lazy var wechatView: BSHostingInputView = {
        let wechat = BSHostingInputView()
        wechat.setup(title: "微信", placerHolder: "请输入您的微信(选填)")
        wechat.origin = CGPoint(x: 0, y: contactAddressView.bottom)
        wechat.textField.keyboardType = .asciiCapable

        return wechat
    }()
    
    private lazy var noteView: BSHostingNoteView = {
        let note = BSHostingNoteView()
        note.origin = CGPoint(x: 0, y: wechatView.bottom)
        note.titleString = "特殊要求"
        return note
    }()
    
    private lazy var argueView: BSReservationAgreementView = {
        let argue = BSReservationAgreementView()
        argue.top = noteView.bottom
        argue.isHidden = true
        scrollViewMain.contentSize = CGSize(width: 0, height: argue.bottom + 50)
        return argue
    }()
    
    private lazy var bottomView: BSReservationBottomView = {
        let bottomV = BSReservationBottomView()
        bottomV.top = scrollViewMain.height - bottomV.height
        return bottomV
    }()
}
