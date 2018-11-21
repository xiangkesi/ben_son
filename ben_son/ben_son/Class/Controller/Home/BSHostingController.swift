//
//  BSHostingController.swift
//  ben_son
//
//  Created by ZS on 2018/9/26.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BSHostingController: BSInputViewController {

    let viewModel = BSHostingViewModel.init()
    let paramModel = BSHostingModel()
    private let disposeBag = DisposeBag()
    private let choose = ChooseImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindEvent()
    }
    
    override func setupUI() {
        super.setupUI()
        title = "本森托管"
        scrollViewMain.addSubview(nameView)
        scrollViewMain.addSubview(phoneView)
        scrollViewMain.addSubview(brandView)
        scrollViewMain.addSubview(modelView)
        scrollViewMain.addSubview(buyYearView)
        scrollViewMain.addSubview(addressView)
        scrollViewMain.addSubview(photoView)
        scrollViewMain.addSubview(praceView)
//        scrollViewMain.addSubview(carUseView)
        scrollViewMain.addSubview(noteView)
        view.addSubview(bottomView)
        
        nameView.textField.rx.text.orEmpty.bind(to: paramModel.name).disposed(by: nameView.disposeBag)
        phoneView.textField.rx.text.orEmpty.bind(to: paramModel.contact).disposed(by: phoneView.disposeBag)
        brandView.textField.rx.text.orEmpty.bind(to: paramModel.brand).disposed(by: brandView.disposeBag)
        modelView.textField.rx.text.orEmpty.bind(to: paramModel.model).disposed(by: modelView.disposeBag)
        praceView.textField.rx.text.orEmpty.bind(to: paramModel.price).disposed(by: praceView.disposeBag)
        noteView.textView.rx.text.orEmpty.bind(to: paramModel.remark).disposed(by: noteView.disposeBag)

    }
    
//    private lazy var nameView: BSHostingInputView = {
//        let name = BSHostingInputView()
//        name.setup(title: "名字", placerHolder: "请输入您的姓名")
//        name.origin = CGPoint(x: 0, y: 0)
//        return name
//    }()
    
    private lazy var nameView: BSInputView = {
        let name = BSInputView()
        name.placerholder = "姓名 / NAME"
        name.top = 0
        return name
    }()
//    private lazy var phoneView: BSHostingInputView = {
//        let phone = BSHostingInputView()
//        phone.setup(title: "联系方式", placerHolder: "请输入您的联系方式")
//        phone.origin = CGPoint(x: 0, y: nameView.bottom)
//        phone.textField.keyboardType = UIKeyboardType.numberPad
//        return phone
//    }()
    private lazy var phoneView: BSInputView = {
        let phone = BSInputView()
        phone.placerholder = "联系方式 / CONTACT"
        phone.origin = CGPoint(x: 0, y: nameView.bottom)
        phone.textField.keyboardType = UIKeyboardType.numberPad
        return phone
    }()
//    private lazy var brandView: BSHostingInputView = {
//        let brand = BSHostingInputView()
//        brand.setup(title: "车辆品牌", placerHolder: "请输入车辆品牌")
//        brand.origin = CGPoint(x: 0, y: phoneView.bottom)
//        return brand
//    }()
    private lazy var brandView: BSInputView = {
        let brand = BSInputView()
        brand.placerholder = "车辆品牌 / Brand"
        brand.origin = CGPoint(x: 0, y: phoneView.bottom)
        return brand
    }()
    
//    private lazy var modelView: BSHostingInputView = {
//        let model = BSHostingInputView()
//        model.setup(title: "车辆型号", placerHolder: "请输入车辆型号")
//        model.origin = CGPoint(x: 0, y: brandView.bottom)
//        return model
//    }()
    private lazy var modelView: BSInputView = {
        let model = BSInputView()
        model.placerholder = "车辆型号 / Model"
        model.origin = CGPoint(x: 0, y: brandView.bottom)
        return model
    }()
    
//    private lazy var buyYearView: BSHostingClickView = {
//        let buyYear = BSHostingClickView()
//        buyYear.setup(title: "购置年份", placerHolder: "购置年份")
//        buyYear.origin = CGPoint(x: 0, y: modelView.bottom)
//        return buyYear
//    }()
    
    private lazy var buyYearView: BSClickBtnView = {
        let buyYear = BSClickBtnView()
        buyYear.title = "购置年份 / Buy Year"
        buyYear.origin = CGPoint(x: 0, y: modelView.bottom)
        return buyYear
    }()
    
//    private lazy var addressView: BSHostingClickView = {
//        let address = BSHostingClickView()
//        address.setup(title: "车辆属地", placerHolder: "选择车辆归属地")
//        address.origin = CGPoint(x: 0, y: buyYearView.bottom)
//        return address
//    }()
    private lazy var addressView: BSClickBtnView = {
        let address = BSClickBtnView()
        address.title = "车辆归属地 / Address"
        address.origin = CGPoint(x: 0, y: buyYearView.bottom)
        return address
    }()
    
    private lazy var photoView: BSHostingCarPhoto = {
        let photo = BSHostingCarPhoto()
        photo.origin = CGPoint(x: 0, y: addressView.bottom)
        return photo
    }()
    
//    private lazy var praceView: BSHostingInputView = {
//        let name = BSHostingInputView()
//        name.setup(title: "期望价格", placerHolder: "请输入期望价格(元/天)")
//        name.origin = CGPoint(x: 0, y: photoView.bottom)
//        name.textField.keyboardType = UIKeyboardType.numberPad
//        return name
//    }()
    private lazy var praceView: BSInputView = {
        let prace = BSInputView()
        prace.placerholder = "期望价格 / Prace"
        prace.origin = CGPoint(x: 0, y: photoView.bottom)
        prace.textField.keyboardType = UIKeyboardType.numberPad
        return prace
    }()
    
//    private lazy var carUseView: BSHostingUseTypeView = {
//        let userView = BSHostingUseTypeView()
//        userView.origin = CGPoint(x: 0, y: praceView.bottom)
//        return userView
//    }()
    
    private lazy var noteView: BSHostingNoteView = {
        let note = BSHostingNoteView()
        note.origin = CGPoint(x: 0, y: praceView.bottom)
        scrollViewMain.contentSize = CGSize(width: 0, height: note.bottom + 40)

        return note
    }()
    
    private lazy var bottomView: BSHostingBottomView = {
        let bottomV = BSHostingBottomView()
        bottomV.top = scrollViewMain.height - bottomV.height
        return bottomV
    }()
}

extension BSHostingController {
    
    
    private func bindEvent() {
        
        buyYearView.btnClick.rx.tap.subscribe(onNext: { [weak self] in
            self?.view.endEditing(true)
            BSChooseDateView.show(showView: (self?.navigationController?.view)!, complete: { (dateStr) in
                self?.buyYearView.text = dateStr
                self?.paramModel.year = dateStr
            })
        }).disposed(by: buyYearView.disposeBag)
        
        
        photoView.subjectPhoto.subscribe(onNext: {[weak self] (tag) in
            self?.choose.controller = self
            self?.choose.btn_type = tag
            BSPhotoView.showBtnView(view: self?.navigationController?.view, completion: {[weak self] (index) in
                if index == 100 {
                    self?.choose.isCamera = false
                }else{
                    self?.choose.isCamera = true
                }
                self?.viewModel.sub.onNext((self?.choose)!)
            })
        }).disposed(by: photoView.disposeBag)
        
//        bottomView.btnSummit.rx.tap.subscribe(onNext: { [weak self] in
//            self?.paramModel.use_type = self?.carUseView.titleString
//            self?.viewModel.subjectSent.onNext((self?.paramModel)!)
//        }).disposed(by: bottomView.disposeBag)
        
        viewModel.summitResult.subscribe(onNext: {[weak self] (finish) in
        
            if finish {
                RSProgressHUD.showSuccessOrFailureHud(titleStr: "提交成功,我们会尽快审核", (kRootVc?.view)!)
                self?.navigationController?.popViewController(animated: true)
            }else{
                RSProgressHUD.showSuccessOrFailureHud(titleStr: "提交失败,请重试", (self?.view)!)
            }
            
        }).disposed(by: viewModel.disposeBag)
        addressView.btnClick.rx.tap.subscribe(onNext: { [weak self] in
            self?.view.endEditing(true)
            BSAddressChooseView.showAddressView(view: (self?.navigationController?.view)!, completion: { (address) in
                self?.addressView.text = address
                self?.paramModel.attribution = address
            })
        }).disposed(by: addressView.disposeBag)
        

        
        viewModel.resultImage.subscribe(onNext: {[weak self] (image) in
            if image == nil {return}
            switch self?.choose.btn_type {
            case 100:
                self?.photoView.btnCarPhoto.image = image
                self?.paramModel.img_car = UIImage.jpegData(image!)(compressionQuality: 0.5)
                break
            case 200:
                self?.photoView.btnLicensePhoto.image = image
                self?.paramModel.img_driving_license = UIImage.jpegData(image!)(compressionQuality: 0.5)
                break
            case 300:
                self?.photoView.btnInsurancePhoto.image = image
                self?.paramModel.img_traffic_insurance = UIImage.jpegData(image!)(compressionQuality: 0.5)
                break
            default:
                self?.photoView.btnBusinessPhoto.image = image
                self?.paramModel.img_commercial_insurance = UIImage.jpegData(image!)(compressionQuality: 0.5)
                break
            }
        }).disposed(by: viewModel.disposeBag)
    
    }
}
