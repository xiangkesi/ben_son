//
//  BSOrderListCell.swift
//  ben_son
//
//  Created by ZS on 2018/10/24.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

private let btnWidth = kScreenWidth * 0.33

class BSOrderHeadView: UIView {
    
    let disposeBag = DisposeBag()
    
    var currentIndex: Int = 0
    
    let subClickBtn = PublishSubject<String>()
    
    
    private var btns = [UIButton]()


    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 50)
        super.init(frame: selfFrame)
        backgroundColor = kMainBackBgColor
        creatBtns()
        layer.addSublayer(lineBottom)
        
       
    }
    
    @objc func actionClick(btn: UIButton) {
        if btn.tag == currentIndex {
            return
        }
        for clickBtn in btns {
            clickBtn.isSelected = false
        }
        let lineLeft = btn.left + (btn.width - lineBottom.width) * 0.5
        UIView.animate(withDuration: 0.1, animations: {
            self.lineBottom.left = lineLeft
            btn.isSelected = true
        }) { (finish) in
            self.currentIndex = btn.tag
        }
        
        switch btn.tag {
        case 0:
            subClickBtn.onNext("unfinished")
            break
        case 1:
            subClickBtn.onNext("progress")
        case 2:
            subClickBtn.onNext("finished")
            break
        default:
            subClickBtn.onNext("finished")
        }
        
        
    }
    
    private func creatBtns() {
        let titles = ["待支付","进行中","已完成"]
        var lastBtn: UIButton? = nil
        for (index, title) in titles.enumerated() {
            let btn = UIButton(type: UIButton.ButtonType.custom)
            btn.top = 10
            btn.height = height - 10
            btn.width = btnWidth
            btn.left = (lastBtn == nil ? 0 : lastBtn!.right)
            btn.setTitle(title, for: UIControl.State.normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            btn.setTitleColor(kMainColor, for: UIControl.State.selected)
            btn.setTitleColor(UIColor.colorWidthHexString(hex: "BFBFBF"), for: UIControl.State.normal)
            btn.isSelected = lastBtn == nil ? true : false
            btn.addTarget(self, action: #selector(actionClick(btn:)), for: UIControl.Event.touchUpInside)
            btn.tag = index
            btns.append(btn)
            addSubview(btn)
            lastBtn = btn
        }
    }
    
    private lazy var lineBottom: CALayer = {
        let line = CALayer()
        line.width = 32
        line.height = 1
        line.top = height - 1
        line.left = (btnWidth - line.width) * 0.5
        line.backgroundColor = kMainColor.cgColor
        return line
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BSOrderPraceView: UIView {
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 56)
        super.init(frame: selfFrame)
        addSubview(labelPrace)
        addSubview(buttonPay)
    }
    
    lazy var labelPrace: UILabel = {
        let label = UILabel()
        label.size = CGSize(width: 150, height: 20)
        label.origin = CGPoint(x: kSpacing, y: 18)
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = kMainColor
        return label
    }()
    
    lazy var buttonPay: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.size = CGSize(width: 80, height: 30)
        btn.origin = CGPoint(x: kScreenWidth - 95, y: 13)
        btn.backgroundColor = kMainColor
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setTitle("支付订金", for: UIControl.State.normal)
        btn.setTitleColor(UIColor.colorWidthHexString(hex: "D9D9D9"), for: UIControl.State.normal)
        return btn
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BSOrderAddressView: UIView {
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth * 0.5 - 75, height: 75)
        super.init(frame: selfFrame)
        
        addSubview(labelFormCity)
        addSubview(labelFormTime)
    }
    
    lazy var labelFormCity: UILabel = {
        let label = UILabel()
        label.top = kSpacing
        label.left = 0
        label.width = width
        label.height = 20
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.colorWidthHexString(hex: "5C5C5C")
        label.text = "上海市徐汇区"
        label.textAlignment = .center
        return label
    }()
    lazy var labelFormTime: UILabel = {
        let label = UILabel()
        label.top = height - 33
        label.left = 0
        label.width = width
        label.height = 18
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.colorWidthHexString(hex: "5C5C5C")
        label.text = "2018-10-01 10:00"
        label.textAlignment = .center
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BSOrderListCell: BSCommentCell {

    
    var click_pay: (() -> ())?
    
    override func setupUI() {
        super.setupUI()
        line.origin = CGPoint(x: 0, y: 0)
        line.backgroundColor = UIColor.colorWidthHexString(hex: "1A1A1A").cgColor
        line.frameSize = CGSize(width: kScreenWidth, height: 10)
        contentView.layer.addSublayer(line)
        
        contentView.addSubview(viewBg)
        viewBg.addSubview(imageIconView)
        viewBg.addSubview(labelOrderStatus)
        viewBg.addSubview(labelBrandName)
        viewBg.addSubview(labelModelName)
        
        contentView.addSubview(viewAddressBg)
        viewAddressBg.addSubview(addressFromView)
        viewAddressBg.addSubview(imageArrowView)
        viewAddressBg.addSubview(labelDayCount)
        viewAddressBg.addSubview(addressToView)
        
        contentView.addSubview(praceView)
        
    }
    
    @objc func click_tobuy() {
        if click_pay != nil {
            click_pay!()
        }
    }
    
    var order_cell: BSOrderModel? {
        didSet{
            imageIconView.zs_setImage(urlString: order_cell?.car_cover, placerHolder: image_placholder)
            labelBrandName.text = order_cell?.brand_name
            labelOrderStatus.text = order_cell?.pay_type
            labelModelName.text = order_cell?.car_model
            addressFromView.labelFormCity.text = order_cell?.removed_city
            addressFromView.labelFormTime.text = order_cell?.removed_time
            addressToView.labelFormCity.text = order_cell?.returned_city
            addressToView.labelFormTime.text = order_cell?.returned_time
            labelDayCount.text = String(order_cell?.days ?? 0) + "天"
            praceView.labelPrace.text = "¥" + (order_cell?.pay_price)!
            praceView.buttonPay.isHidden = (order_cell?.order_status == "unfinished" ? false : true)
        }
    }
    
    
    private lazy var viewBg: UIView = {
        let bg = UIView()
        bg.origin = CGPoint(x: 0, y: line.bottom)
        bg.size = CGSize(width: kScreenWidth, height: 100)
        bg.backgroundColor = kMainBackBgColor
        bg.addBottomLine(UIEdgeInsets(top: 0, left: kSpacing, bottom: 0, right: kSpacing), UIColor.colorWidthHexString(hex: "322A21"), 0.5)
        return bg
    }()
    
    private lazy var imageIconView: UIImageView = {
        let iconView = UIImageView()
        iconView.origin = CGPoint(x: kSpacing, y: kSpacing)
        iconView.height = viewBg.height - 30
        iconView.width = iconView.height * 1.6
        return iconView
    }()
    
    private lazy var labelOrderStatus: UILabel = {
        let status = UILabel()
        status.top = imageIconView.top
        status.size = CGSize(width: 50, height: 22)
        status.left = viewBg.width - status.width - kSpacing
        status.font = UIFont.systemFont(ofSize: 16)
        status.textColor = kMainColor
        return status
    }()
    
    private lazy var labelBrandName: UILabel = {
        let status = UILabel()
        status.top = imageIconView.top
        status.size = CGSize(width: viewBg.width - imageIconView.right - 75, height: 22)
        status.left = imageIconView.right + 10
        status.font = UIFont.systemFont(ofSize: 16)
        status.textColor = UIColor.colorWidthHexString(hex: "BFBFBF")
        return status
    }()
    
    private lazy var labelModelName: UILabel = {
        let status = UILabel()
        status.top = labelBrandName.bottom + 4
        status.size = CGSize(width: viewBg.width - imageIconView.right - 25, height: 16)
        status.left = imageIconView.right + 10
        status.font = UIFont.systemFont(ofSize: 13)
        status.textColor = UIColor.colorWidthHexString(hex: "5C5C5C")
        return status
    }()
    
    private lazy var viewAddressBg: UIView = {
        let bg = UIView()
        bg.origin = CGPoint(x: 0, y: viewBg.bottom)
        bg.size = CGSize(width: kScreenWidth, height: 75)
        bg.backgroundColor = kMainBackBgColor
        bg.addBottomLine(UIEdgeInsets(top: 0, left: kSpacing, bottom: 0, right: kSpacing), UIColor.colorWidthHexString(hex: "322A21"), 0.5)
        return bg
    }()
    
    private lazy var addressFromView: BSOrderAddressView = {
        let formView = BSOrderAddressView()
        formView.origin = CGPoint(x: kSpacing, y: 0)
        return formView
    }()
    
    private lazy var imageArrowView: UIImageView = {
        let arrowView = UIImageView()
        arrowView.size = CGSize(width: 80, height: 6)
        arrowView.left = addressFromView.right + 20
        arrowView.top = (viewAddressBg.height) * 0.5
        arrowView.image = UIImage(named: "reservation_timelength")
        return arrowView
    }()
    
    private lazy var labelDayCount: UILabel = {
        let status = UILabel()
        status.top = imageArrowView.top - 20
        status.left = imageArrowView.left
        status.size = CGSize(width: imageArrowView.width, height: 20)
        status.font = UIFont.systemFont(ofSize: 13)
        status.textColor = UIColor.colorWidthHexString(hex: "5C5C5C")
        status.textAlignment = .center
        return status
    }()
    private lazy var addressToView: BSOrderAddressView = {
        let formView = BSOrderAddressView()
        formView.origin = CGPoint(x: imageArrowView.right + 20, y: 0)
        return formView
    }()
    
    private lazy var praceView: BSOrderPraceView = {
        let address = BSOrderPraceView()
        address.origin = CGPoint(x: 0, y: viewAddressBg.bottom)
        address.backgroundColor = kMainBackBgColor
        address.buttonPay.addTarget(self, action: #selector(click_tobuy), for: UIControl.Event.touchUpInside)
        return address
    }()
}


