//
//  BSPayResultController.swift
//  ben_son
//
//  Created by ZS on 2018/11/8.
//  Copyright © 2018 ZS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BSPayResultController: BSBaseController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    var prace: Int = 0
    
    var msg: BSOrderModel? {
        didSet {
            let praceString = "¥" + (msg?.pay_price ?? "")
            labelPrace.attributedText = praceString.richText("¥", 15)
        }
    }
    
    override func setupUI() {
        super.setupUI()
        fd_interactivePopDisabled = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "common_back"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(clickBack))
        view.addSubview(imageIconView)
        view.addSubview(labelSuccess)
        view.addSubview(labelPrace)
        view.addSubview(btnOrder)
        view.addSubview(btnBackHome)
        view.addSubview(labelDesc)
        
        btnOrder.rx.tap.subscribe(onNext: { [weak self] in
            let orderDetailVc = BSOrderDetailController()
            orderDetailVc.orderId = (self?.msg?.order_id)!
            self?.navigationController?.pushViewController(orderDetailVc, animated: true)
            
        }).disposed(by: disposeBag)
        
        btnBackHome.rx.tap.subscribe(onNext: { [weak self] in
           self?.navigationController?.popToRootViewController(animated: true)
            
        }).disposed(by: disposeBag)

    }
    
    @objc func clickBack() {
      self.navigationController?.popToRootViewController(animated: true)
    }

    
    private lazy var imageIconView: UIImageView = {
        let iconView = UIImageView()
        iconView.width = 200
        iconView.height = iconView.width * 0.75
        iconView.origin = CGPoint(x: (kScreenWidth - iconView.width) * 0.5, y: kSpacing)
        iconView.image = UIImage(named: "mine_pay_success")
        return iconView
    }()
    
    private lazy var labelSuccess: UILabel = {
        let success = UILabel()
        success.top = imageIconView.bottom + 5
        success.left = kSpacing
        success.width = kContentWidth
        success.height = 20
        success.textAlignment = .center
        success.font = UIFont.systemFont(ofSize: 16)
        success.text = "支付成功"
        success.textColor = UIColor.colorWidthHexString(hex: "BFBFBF")
        return success
    }()
    
    private lazy var labelPrace: UILabel = {
        let prace = UILabel()
        prace.setupAttribute(24,
                             nil,
                             "A98054",
                             CGSize(width: kContentWidth, height: 22),
                             CGPoint(x: kSpacing, y: labelSuccess.bottom + 15))
        prace.textAlignment = .center
       
        return prace
    }()
    
    private lazy var btnOrder: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.backgroundColor = kMainColor
        btn.size = CGSize(width: 100, height: 32)
        btn.origin = CGPoint(x: 50, y: labelPrace.bottom + 100)
        btn.zs_cutCorner(sizeHeigt: CGSize(width: 2, height: 2))
        btn.setTitle("查看订单", for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(UIColor.colorWidthHexString(hex: "D9D9D9"), for: UIControl.State.normal)
        return btn
    }()
    
    private lazy var btnBackHome: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.backgroundColor = kMainColor
        btn.size = CGSize(width: 100, height: 32)
        btn.origin = CGPoint(x: kScreenWidth - 150, y: labelPrace.bottom + 100)
        btn.zs_cutCorner(sizeHeigt: CGSize(width: 2, height: 2))
        btn.setTitle("回首页", for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(UIColor.colorWidthHexString(hex: "D9D9D9"), for: UIControl.State.normal)
        return btn
    }()
    
    private lazy var labelDesc: UILabel = {
        let desc = UILabel()
        desc.numberOfLines = 0
        desc.height = 80
        desc.width = kContentWidth
        desc.font = UIFont.systemFont(ofSize: 13)
        desc.textColor = UIColor.colorWidthHexString(hex: "5C5C5C")
        desc.origin = CGPoint(x: kSpacing, y: UIDevice.current.contentNoTabBarHeight() - 100)
        desc.text = "说明：\n\n支付完成后，我们的工作人员将会尽快与您取得联系，请注意您的来电提醒。"
        return desc
    }()

}
