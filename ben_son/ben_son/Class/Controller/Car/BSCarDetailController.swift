//
//  BSCarDetailController.swift
//  ben_son
//
//  Created by ZS on 2018/10/15.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit

class BSCarDetailController: BSBaseController {

    
    let viewModel = CarDetailViewModel.init()
    var car_id: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.loadCarDetailData.onNext(car_id)
    }

    override func setupUI() {
        super.setupUI()
        title = "车辆详情"
        fd_prefersNavigationBarHidden = true
        view.addSubview(scrollerMain)
        view.addSubview(btnBg)
        view.addSubview(placerHolderView)
        view.addSubview(navView)
        scrollerMain.addSubview(banderView)
        scrollerMain.addSubview(carName)
        scrollerMain.addSubview(priceList)
        scrollerMain.addSubview(instructionsView)
        scrollerMain.addSubview(msgView)
        scrollerMain.addSubview(rentalView)
        scrollerMain.addSubview(serviceGuaranteeView)
        setupBind()
    }
    
    private lazy var scrollerMain: UIScrollView = {
        let scroller = UIScrollView()
        scroller.origin = CGPoint(x: 0, y: 0)
        scroller.size = CGSize(width: kScreenWidth, height: kScreenHeight - btnBg.height)
        scroller.alwaysBounceVertical = true
        if #available(iOS 11.0, *) {
            scroller.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        return scroller
    }()

    private lazy var banderView: BSCarDetailBanderView = {
        let bander = BSCarDetailBanderView()
        bander.origin = CGPoint(x: 0, y: 0)
        return bander
    }()
    
    private lazy var carName: BSCarDetailCarNameView = {
        let name = BSCarDetailCarNameView()
        name.origin = CGPoint(x: 0, y: banderView.bottom)
        return name
    }()
    
    private lazy var priceList: BSCarDetailPriceListView = {
        let price = BSCarDetailPriceListView()
        price.origin = CGPoint(x: 0, y: carName.bottom)
        return price
    }()
    
    private lazy var instructionsView: BSCarDetailInstructionsView = {
        let instructions = BSCarDetailInstructionsView()
        instructions.top = priceList.bottom
        instructions.left = 0
        
        return instructions
    }()
    
    private lazy var msgView: BSCarDetailMsgView = {
        let msg = BSCarDetailMsgView()
        msg.origin = CGPoint(x: 0, y: instructionsView.bottom)
        return msg
    }()
    
    private lazy var rentalView: CarDetailRentalView = {
        let rental = CarDetailRentalView()
        rental.origin = CGPoint(x: 0, y: msgView.bottom)
        return rental
    }()
    
    private lazy var serviceGuaranteeView: CarDetailServiceGuaranteeView = {
        let guarant = CarDetailServiceGuaranteeView()
        guarant.origin = CGPoint(x: 0, y: rentalView.bottom)
        scrollerMain.contentSize = CGSize(width: 0, height: guarant.bottom)
        return guarant
    }()
    
    private lazy var btnBg: CarDetailFootView = {
        let bg = CarDetailFootView()
        bg.origin = CGPoint(x: 0, y: kScreenHeight - bg.height)
        return bg
    }()
    
    private lazy var navView: CarDetailNavView = {
        let nav = CarDetailNavView()
        nav.origin = CGPoint(x: 0, y: 0)
        return nav
    }()
    
    private lazy var placerHolderView: RSPlacerHolderView = {
        let holderView = RSPlacerHolderView()
        holderView.startAnimal()
        return holderView
    }()
    
    deinit {
        BSLog("难倒车辆详情也没有销毁吗")
    }
}

extension BSCarDetailController {
    
    private func setupBind() {
        navView.buttonBack.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: navView.disposeBag)
        navView.buttonJoinVip.rx.tap.subscribe(onNext: {

        }).disposed(by: navView.disposeBag)
        navView.shareBtn.rx.tap.subscribe(onNext: { [weak self] in
            BSShareView.showShareView(complete: {(shareType) in
                let shareModel = ShareModel()
                shareModel.title = "本森超跑"
                shareModel.desc = (self?.viewModel.detail?.brand ?? "") + (self?.viewModel.detail?.model ?? "")
                shareModel.webUrl = "https://www.baidu.com/"
                RSUmenManager.share(platformtype: shareType, sharemodel: shareModel, shareType: ShareType.shareWeb)
            })
        }).disposed(by: navView.disposeBag)
        navView.collectionBtn.rx.tap.subscribe(onNext: { [weak self] in
            if !AccountManager.shareManager().isLogin {
                AccountManager.shareManager().showLoginController()
                return
            }
            if let _ = self?.viewModel.detail {
                self?.navView.collectionBtn.isSelected = !(self?.navView.collectionBtn.isSelected)!
                self?.playAnimationBounce()
                let requestUrl = (self?.viewModel.detail?.isMark)! ? BSServiceAPI.car_collection_cancel(carId: (self?.car_id)!) : BSServiceAPI.car_collection_creat(carId: (self?.car_id)!)
                self?.viewModel.signingIn.onNext(requestUrl)
            }

        }).disposed(by: navView.disposeBag)
        btnBg.btnCall.rx.tap.subscribe(onNext: {
            BSTool.callPhone(phone: ben_son_number)
        }).disposed(by: btnBg.disposeBag)
        btnBg.btnSummit.rx.tap.subscribe(onNext: { [weak self] in
            if !AccountManager.shareManager().isLogin {
                AccountManager.shareManager().showLoginController()
                return
            }

            let vc = BSReservationController()
            vc.detail = self?.viewModel.detail
            self?.navigationController?.pushViewController(vc, animated: true)

        }).disposed(by: btnBg.disposeBag)

        banderView.clickSubject.subscribe(onNext: {[weak self] (index) in
            BSBigPhoto.showBigPhoto(vc: self!, images: (self?.viewModel.detail?.carPhotos)!, currentIndex: index)
        }).disposed(by: banderView.disposeBag)

        viewModel.signupResult?.subscribe(onNext: {[weak self] (finish) in
            if finish {
                self?.viewModel.detail?.isMark = !(self?.viewModel.detail?.isMark)!
            }
        }).disposed(by: viewModel.disposeBag)
        viewModel.resultCarDetail?.subscribe(onNext: {[weak self] (finish) in
            DispatchQueue.main.async(execute: {
                if finish {
                    self?.banderView.images = self?.viewModel.detail?.carPhotos
                    self?.carName.labelTitle.text = (self?.viewModel.detail?.brand ?? "") + "--" + (self?.viewModel.detail?.model ?? "")
                    self?.priceList.subjectPrace.onNext((self?.viewModel.detail?.car_praces)!)
                    self?.msgView.subjectCarMsg.onNext((self?.viewModel.detail?.car_msgs)!)
                    self?.msgView.labelHeadDesc.text = self?.viewModel.detail?.car_engine
                    self?.msgView.labelFooterDesc.text = self?.viewModel.detail?.car_ceiling
                    self?.navView.collectionBtn.isSelected = (self?.viewModel.detail?.isMark)!
                }
                self?.placerHolderView.showType(finish)
            })
        }).disposed(by: viewModel.disposeBag)

        placerHolderView.click_subject.subscribe(onNext: {[weak self] (finish) in
            self?.viewModel.loadCarDetailData.onNext((self?.car_id)!)
        }).disposed(by: placerHolderView.disposeBag)
    }
    
    private func playAnimationBounce() {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = 1.0
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        bounceAnimation.isRemovedOnCompletion = true
        self.navView.collectionBtn.layer.add(bounceAnimation, forKey: nil)
    }
}
