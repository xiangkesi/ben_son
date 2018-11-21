//
//  BSReservationView.swift
//  ben_son
//
//  Created by ZS on 2018/9/26.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import YYText
class BSReservationView: UIView {

    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 60)
        
        super.init(frame: selfFrame)
        backgroundColor = UIColor.colorWidthHexString(hex: "141414")
        addSubview(labelTitle)
        addSubview(labelDetail)
        layer.addSublayer(lineBottom)
    }
    
    func setup(title: String) {
       labelTitle.text = title
    }
    
    private lazy var labelTitle: UILabel = {
        let title = UILabel()
        title.left = kSpacing
        title.height = 40
        title.top = 10
        title.width = 85
        title.textColor = kMainColor
        title.backgroundColor = UIColor.colorWidthHexString(hex: "141414")
        title.layer.masksToBounds = true
        title.font = UIFont.systemFont(ofSize: 15)
        return title
    }()
    
    lazy var labelDetail: UILabel = {
        let field = UILabel()
        field.left = labelTitle.right
        field.top = labelTitle.top
        field.height = labelTitle.height
        field.width = kScreenWidth - 115
        field.font = UIFont.systemFont(ofSize: 15)
        field.textColor = kMainColor
        field.backgroundColor = UIColor.colorWidthHexString(hex: "141414")
        field.layer.masksToBounds = true
        return field
    }()
    
    private lazy var lineBottom: CALayer = {
        let line = CALayer.init()
        line.left = 0
        line.width = kScreenWidth
        line.height = 0.5
        line.top = height - line.height
        line.backgroundColor = UIColor.colorWidthHexString(hex: "1E1E1E").cgColor
        return line
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class BSColorCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageViewBg)
        contentView.addSubview(colorView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var imageViewBg: UIImageView = {
        let bg = UIImageView()
        bg.size = CGSize(width: 40, height: 30)
        bg.origin = CGPoint(x: 0, y: 0)
        return bg
    }()
    
    lazy var colorView: UIView = {
        let color = UIView()
        color.origin = CGPoint(x: 5, y: 5)
        color.size = CGSize(width: 30, height: 20)
        color.backgroundColor = UIColor.red
        return color
    }()
}
class BSReservationColorView: UIView {
    
    let disposeBag = DisposeBag()
    private let subjectColor = PublishSubject<[CarDetailColor]>()
    let selectedCarId = PublishSubject<CarDetailColor>()
    
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 60)
        super.init(frame: selfFrame)
        backgroundColor = UIColor.colorWidthHexString(hex: "141414")
        addSubview(labelTitle)
        layer.addSublayer(lineBottom)
    }
    
    var colors: [CarDetailColor]? {
        didSet{
            subjectColor.onNext(colors!)
        }
    }
    
    
    func setup(title: String, isColor: Bool) {
        labelTitle.text = title
        if isColor {
            addSubview(collectionColorView)
            subjectColor.bind(to: collectionColorView.rx.items) { (collectionView, row, element) in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BSColorCell",
                                                                  for: indexPath) as! BSColorCell
                cell.colorView.backgroundColor = UIColor.colorWidthHexString(hex: element.carColor ?? "FCFCFC")
                cell.imageViewBg.image = UIImage(named: element.isSelected ? "image_carcolor_select" : "image_carcolor_normal")
                return cell
            }.disposed(by: disposeBag)
            
            //获取选中项的内容
            collectionColorView.rx.modelSelected(CarDetailColor.self).subscribe(onNext: {[weak self] item in
                self?.selectedCarId.onNext(item)
                self?.colors?.rx_traversal.subscribe(onNext: { (event) in
                    if let color = event as? CarDetailColor {
                        color.isSelected = (color === item ? true : false)
                    }
                }, onCompleted: {
                    self?.subjectColor.onNext((self?.colors)!)
                }).disposed(by: DisposeBag())
            }).disposed(by: disposeBag)

        }else{
            labelTitle.width = 150
            addSubview(switchView)
        }
    }
    
    private lazy var collectionColorView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = CGSize(width: 40, height: 30)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 10
        let collection = UICollectionView.init(frame: CGRect(), collectionViewLayout: flowLayout)
        collection.size = CGSize(width: kScreenWidth - 115, height: 30)
        collection.left = labelTitle.right
        collection.top = kSpacing
        collection.register(BSColorCell.self, forCellWithReuseIdentifier: "BSColorCell")
        collection.backgroundColor = UIColor.colorWidthHexString(hex: "141414")
        return collection
    }()
    
    lazy var switchView: UISwitch = {
        let viewSwitch = UISwitch.init()
        viewSwitch.tintColor = kMainColor
        viewSwitch.onTintColor = UIColor.gray
        viewSwitch.thumbTintColor = kMainColor
        viewSwitch.left = kScreenWidth - viewSwitch.width - 15
        viewSwitch.top = (height - viewSwitch.height) * 0.5
        viewSwitch.isOn = true
        return viewSwitch
    }()
    
    private lazy var labelTitle: UILabel = {
        let title = UILabel()
        title.left = kSpacing
        title.height = 40
        title.top = 10
        title.width = 85
        title.textColor = kMainColor
        title.backgroundColor = UIColor.colorWidthHexString(hex: "141414")
        title.layer.masksToBounds = true
        title.font = UIFont.systemFont(ofSize: 15)
        return title
    }()
    
    private lazy var lineBottom: CALayer = {
        let line = CALayer.init()
        line.left = 0
        line.width = kScreenWidth
        line.height = 0.5
        line.top = height - line.height
        line.backgroundColor = UIColor.colorWidthHexString(hex: "1E1E1E").cgColor
        return line
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}



class BSLocationView: UIView {
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 88)
        super.init(frame: selfFrame)
        
        addSubview(labelLeftTitle)
        addSubview(labelRightTitle)
        addSubview(btnLeftAddress)
        addSubview(btnRightAddress)
        
        layer.addSublayer(lineBottom)
    }
    
    private lazy var labelLeftTitle: UILabel = {
        let title = UILabel()
        title.left = kSpacing
        title.height = 20
        title.top = 20
        title.width = 85
        title.text = "取车城市"
        title.textColor = UIColor.colorWidthHexString(hex: "53402F")
        title.backgroundColor = UIColor.colorWidthHexString(hex: "141414")
        title.layer.masksToBounds = true
        title.font = UIFont.systemFont(ofSize: 13)
        return title
    }()
    
    private lazy var labelRightTitle: UILabel = {
        let title = UILabel()
        title.left = kScreenWidth - 115
        title.height = 20
        title.top = 20
        title.width = 100
        title.text = "还车城市"
        title.textAlignment = .right
        title.textColor = UIColor.colorWidthHexString(hex: "53402F")
        title.backgroundColor = UIColor.colorWidthHexString(hex: "141414")
        title.layer.masksToBounds = true
        title.font = UIFont.systemFont(ofSize: 13)
        return title
    }()
    
    lazy var btnLeftAddress: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.left = kSpacing
        btn.width = (kContentWidth - 15) * 0.5
        btn.height = 20
        btn.top = labelLeftTitle.bottom + 8
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(kMainColor, for: UIControl.State.normal)
        btn.setTitle("点击选择取车城市", for: UIControl.State.normal)
        btn.contentHorizontalAlignment = .left
        return btn
    }()
    
    lazy var btnRightAddress: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.width = (kContentWidth - 15) * 0.5
        btn.height = 20
        btn.top = labelRightTitle.bottom + 8
        btn.left = kScreenWidth - btn.width - 15
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(kMainColor, for: UIControl.State.normal)
        btn.setTitle("点击选择还车城市", for: UIControl.State.normal)
        btn.contentHorizontalAlignment = .right
        return btn
    }()
    
    private lazy var lineBottom: CALayer = {
        let line = CALayer.init()
        line.frameSize = CGSize(width: kScreenWidth, height: 0.5)
        line.backgroundColor = UIColor.colorWidthHexString(hex: "1E1E1E").cgColor
        line.origin = CGPoint(x: 0, y: height - 0.5)
        return line
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BSReservationDateView: UIView {
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 88)
        super.init(frame: selfFrame)
        
        addSubview(btnLeftDate)
        addSubview(btnRightDate)
        addSubview(labelLeftTitle)
        addSubview(labelRightTitle)
        addSubview(imageIcon)
        addSubview(labelDay)
        
        layer.addSublayer(lineBottom)
    }
    
    lazy var btnLeftDate: UILabel = {
        let label = UILabel()
        label.setupAttribute(15,
                             nil,
                             "A98054",
                             CGSize(width: 80, height: 20),
                             CGPoint(x: kSpacing, y: 20))
        label.text = "开始日期"
        return label
    }()
    
    lazy var btnRightDate: UILabel = {
        
        let label = UILabel()
        label.setupAttribute(15,
                             nil,
                             "A98054",
                             CGSize(width: 80, height: 20),
                             CGPoint(x: kScreenWidth - btnLeftDate.width - 15, y: 20))
        label.textAlignment = .right
        label.text = "结束日期"
        return label
    }()
    
    lazy var labelLeftTitle: UILabel = {
        let title = UILabel()
        title.left = kSpacing
        title.height = 20
        title.top = btnLeftDate.bottom + 8
        title.width = 80
        title.textColor = UIColor.colorWidthHexString(hex: "53402F")
        title.backgroundColor = UIColor.colorWidthHexString(hex: "141414")
        title.layer.masksToBounds = true
        title.font = UIFont.systemFont(ofSize: 13)
        return title
    }()
    
    lazy var labelRightTitle: UILabel = {
        let title = UILabel()
        title.left = kScreenWidth - 115
        title.height = 20
        title.top = btnRightDate.bottom + 8
        title.width = 100
        title.textAlignment = .right
        title.textColor = UIColor.colorWidthHexString(hex: "53402F")
        title.backgroundColor = UIColor.colorWidthHexString(hex: "141414")
        title.layer.masksToBounds = true
        title.font = UIFont.systemFont(ofSize: 13)
        return title
    }()
    
    
    private lazy var imageIcon: UIImageView = {
        let icon = UIImageView()
        icon.size = CGSize(width: 75, height: 6)
        icon.left = (kScreenWidth - 75) * 0.5
        icon.top = 42
        icon.image = UIImage(named: "reservation_timelength")
        return icon
    }()
    
    lazy var labelDay: UILabel = {
        let title = UILabel()
        title.left = imageIcon.left
        title.width = imageIcon.width
        title.height = 20
        title.top = imageIcon.top - 20
        title.text = "-天"
        title.textAlignment = .center
        title.textColor = UIColor.colorWidthHexString(hex: "53402F")
        title.backgroundColor = UIColor.colorWidthHexString(hex: "141414")
        title.layer.masksToBounds = true
        title.font = UIFont.systemFont(ofSize: 13)
        return title
    }()
   
    
    private lazy var lineBottom: CALayer = {
        let line = CALayer.init()
        line.frameSize = CGSize(width: kScreenWidth, height: 0.5)
        line.backgroundColor = UIColor.colorWidthHexString(hex: "1E1E1E").cgColor
        line.origin = CGPoint(x: 0, y: height - 0.5)
        return line
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TakeCarWayView: UIView {
    
    private let disposeBag = DisposeBag()
    let subjectCarWay = PublishSubject<Int>()
    
    private(set) var selected: Bool? {
        didSet {
            labelWayView.text = selected! ? "到店取车" : "送车上门"
            subjectCarWay.onNext(selected! ? 1 : 2)
        }
    }
    

    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 60)
        super.init(frame: selfFrame)
        selected = false
        layer.addSublayer(lineBottom)
        addSubview(labelTitle)
        
        addSubview(wayView)
        wayView.addSubview(labelWayView)
        wayView.addSubview(sliderView)
        
        let tap = UITapGestureRecognizer.init()
        wayView.addGestureRecognizer(tap)
        
        tap.rx.event.subscribe({ [weak self] recognizer in
            self?.wayView.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.1, animations: {
                self?.labelWayView.left = (self?.selected)! ? 0 : 40
                self?.sliderView.left = (self?.selected)! ? 88 : 2
            }, completion: { (finish) in
                self?.selected = !(self?.selected)!
                self?.wayView.isUserInteractionEnabled = true
            })
        }).disposed(by: disposeBag)
        
        selected = false
    }
    
    private lazy var labelTitle: UILabel = {
        let title = UILabel()
        title.left = kSpacing
        title.height = 40
        title.top = 10
        title.width = 85
        title.textColor = kMainColor
        title.backgroundColor = UIColor.colorWidthHexString(hex: "141414")
        title.layer.masksToBounds = true
        title.font = UIFont.systemFont(ofSize: 15)
        title.text = "取车方式"
        return title
    }()
    
    private lazy var wayView: UIView = {
        let way = UIView()
        way.size = CGSize(width: 130, height: 28)
        way.origin = CGPoint(x: kScreenWidth - 145, y: 16)
        way.zs_cutCornerAndBorder(sizeHeigt: CGSize(width: 3, height: 3), boderColor: kMainColor, boderWidth: 0.5)
        
        
        return way
    }()
    
    private lazy var labelWayView: UILabel = {
        let label = UILabel.init()
        label.textColor = kMainColor
        label.font = UIFont.systemFont(ofSize: 15)
        label.origin = CGPoint(x: 0, y: 0)
        label.size = CGSize(width: 90, height: wayView.height)
        label.text = "送车上门"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var sliderView: UIView = {
        let slider = UIView()
        slider.size = CGSize(width: 40, height: 24)
        slider.top = 2
        slider.left = wayView.width - slider.width - 2
        slider.backgroundColor = kMainColor
        slider.zs_cutCorner(sizeHeigt: CGSize(width: 5, height: 5))
        return slider
    }()
    
    private lazy var lineBottom: CALayer = {
        let line = CALayer.init()
        line.frameSize = CGSize(width: kScreenWidth, height: 0.5)
        line.backgroundColor = UIColor.colorWidthHexString(hex: "1E1E1E").cgColor
        line.origin = CGPoint(x: 0, y: height - 0.5)
        return line
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DetailAddressView: UIView {
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 60)
        
        super.init(frame: selfFrame)
        backgroundColor = UIColor.colorWidthHexString(hex: "141414")
        addSubview(labelTitle)
        addSubview(btnView)
    }

    
    private lazy var labelTitle: UILabel = {
        let title = UILabel()
        title.left = kSpacing
        title.height = 40
        title.top = 10
        title.width = 100
        title.textColor = kMainColor
        title.backgroundColor = UIColor.colorWidthHexString(hex: "141414")
        title.layer.masksToBounds = true
        title.text = "详细使用地址"
        title.font = UIFont.systemFont(ofSize: 15)
        return title
    }()
    
    lazy var btnView: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.left = labelTitle.right
        btn.size = CGSize(width: kScreenWidth - 130, height: 40)
        btn.top = labelTitle.top
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(UIColor.colorWidthHexString(hex: "53402F"), for: UIControl.State.normal)
        btn.setTitleColor(UIColor.colorWidthHexString(hex: "ffffff"), for: UIControl.State.selected)
        btn.contentHorizontalAlignment = .right
        btn.backgroundColor = UIColor.colorWidthHexString(hex: "141414")
        btn.setTitle("点击选择使用地址", for: UIControl.State.normal)
        btn.layer.masksToBounds = true
        btn.titleLabel?.lineBreakMode = .byTruncatingMiddle
        return btn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BSReservationLocationView: UIView {
    
    let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 316)
        super.init(frame: selfFrame)
        
        setupUI()
    }
    
    var dic: [String: String]? {
        didSet{
            dateView.btnLeftDate.text = dic!["beginTime"]
            dateView.btnRightDate.text = dic!["endTime"]
            dateView.labelDay.text = dic!["days"]! + "天"
            dateView.labelLeftTitle.text = dic!["benginWeek"]
            dateView.labelRightTitle.text = dic!["endWeek"]
        }
    }
    
    private lazy var lineTop: CALayer = {
        let line = CALayer.init()
        line.frameSize = CGSize(width: kScreenWidth, height: 10)
        line.backgroundColor = UIColor.colorWidthHexString(hex: "1E1E1E").cgColor
        line.origin = CGPoint(x: 0, y: 0)
        return line
    }()
    
    private lazy var lineBottom: CALayer = {
        let line = CALayer.init()
        line.frameSize = CGSize(width: kScreenWidth, height: 10)
        line.backgroundColor = UIColor.colorWidthHexString(hex: "1E1E1E").cgColor
        line.origin = CGPoint(x: 0, y: height - 10)
        return line
    }()
    
    lazy var locationView: BSLocationView = {
        let location = BSLocationView()
        location.top = lineTop.bottom
        return location
    }()
    
    
    lazy var dateView: BSReservationDateView = {
        let date = BSReservationDateView()
        date.top = locationView.bottom
        return date
    }()
    
    lazy var btnDate: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.frame = CGRect(x: 0, y: 0, width: dateView.width, height: dateView.height)
        return btn
    }()
    
    lazy var carWayView: TakeCarWayView = {
        let wayView = TakeCarWayView()
        wayView.top = dateView.bottom
        return wayView
    }()
    
    lazy var addressView: DetailAddressView = {
        let address = DetailAddressView()
        address.top = carWayView.bottom
        return address
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BSReservationLocationView {
    
    private func setupUI() {
        layer.addSublayer(lineTop)
        layer.addSublayer(lineBottom)
        addSubview(locationView)
        addSubview(dateView)
        dateView.addSubview(btnDate)
        addSubview(carWayView)
        addSubview(addressView)
    }
}


class BSOrderPraceCell: UIView {
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 60)
        super.init(frame: selfFrame)
        backgroundColor = UIColor.colorWidthHexString(hex: "141414")
        addSubview(imageIcon)
        addSubview(labelTitle)
        addSubview(labelPrace)
        layer.addSublayer(lineBottom)
    }
    
    func setupIconTitle(imageName: String, title: String) {
        imageIcon.image = UIImage(named: imageName)
        labelTitle.text = title
    }
    
    private lazy var imageIcon: UIImageView = {
        let icon = UIImageView()
        icon.size = CGSize(width: 20, height: 20)
        icon.left = kSpacing
        icon.top = 20
        return icon
    }()
    
    private lazy var labelTitle: UILabel = {
        let title = UILabel()
        title.left = imageIcon.right + kSpacing
        title.height = 20
        title.top = 20
        title.width = 100
        title.textColor = kMainColor
        title.backgroundColor = UIColor.colorWidthHexString(hex: "141414")
        title.layer.masksToBounds = true
        title.font = UIFont.systemFont(ofSize: 15)
        return title
    }()
    
    lazy var labelPrace: UILabel = {
        let title = UILabel()
        title.height = 20
        title.top = 20
        title.width = 100
        title.left = kScreenWidth - title.width - kSpacing
        title.textColor = kMainColor
        title.backgroundColor = UIColor.colorWidthHexString(hex: "141414")
        title.layer.masksToBounds = true
        title.text = "¥300000"
        title.textAlignment = .right
        title.font = UIFont.systemFont(ofSize: 15)
        return title
    }()
    
    private lazy var lineBottom: CALayer = {
        let line = CALayer.init()
        line.frameSize = CGSize(width: kScreenWidth, height: 0.5)
        line.backgroundColor = UIColor.colorWidthHexString(hex: "1E1E1E").cgColor
        line.origin = CGPoint(x: 0, y: height - 0.5)
        return line
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class BSOrderAllPraceView: UIView {
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 130)
        super.init(frame: selfFrame)
        layer.addSublayer(lineBottom)
        addSubview(orderAllPraceView)
        addSubview(depositAllPraceView)
    }
    
    private lazy var lineBottom: CALayer = {
        let line = CALayer.init()
        line.frameSize = CGSize(width: kScreenWidth, height: 10)
        line.backgroundColor = UIColor.colorWidthHexString(hex: "1E1E1E").cgColor
        line.origin = CGPoint(x: 0, y: height - 10)
        return line
    }()
    
    var allPrace: String? {
        didSet{
            orderAllPraceView.labelPrace.text = "¥" + allPrace!
        }
    }
    
    var deposit: String? {
        didSet{
            depositAllPraceView.labelPrace.text = "¥" + deposit!
        }
    }
    
    
    
    lazy var orderAllPraceView: BSOrderPraceCell = {
        let allPrace = BSOrderPraceCell()
        allPrace.top = 0
        allPrace.setupIconTitle(imageName: "reservation_dingjin", title: "订单总金额")
        return allPrace
    }()
    
    lazy var depositAllPraceView: BSOrderPraceCell = {
        let deposit = BSOrderPraceCell()
        deposit.top = orderAllPraceView.bottom
        deposit.setupIconTitle(imageName: "reservation_yajin", title: "所需押金")
        return deposit
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BSReservationAgreementView: UIView {
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 80)
        super.init(frame: selfFrame)
        backgroundColor = UIColor.colorWidthHexString(hex: "282828")
        addSubview(labelAgreement)
    }
    
    private lazy var labelAgreement: YYLabel = {
        let label = YYLabel()
        label.size = CGSize(width: kContentWidth, height: 30)
        label.left = kSpacing
        label.top = 25
        label.highlightTapAction = {[weak self] (containerView: UIView, text: NSAttributedString, range: NSRange, rect: CGRect) in
        }
        let agreement = NSMutableAttributedString.init(string: "我已阅读并同意 BENSON用户协议")
        agreement.yy_font = UIFont.systemFont(ofSize: 14)
        agreement.yy_color = UIColor.colorWidthHexString(hex: "5A5A5A")
        let range = NSRange(location: 8, length: 10)
        agreement.yy_setColor(kMainColor, range: range)
        let highlight = YYTextHighlight.init()
        agreement.yy_setTextHighlight(highlight, range: range)
        agreement.yy_setUnderlineStyle(NSUnderlineStyle.single, range: range)
        agreement.yy_setUnderlineColor(kMainColor, range: range)
        label.attributedText = agreement
        label.textAlignment = .center
        return label
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class BSReservationBottomView: UIView {
    let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: UIDevice.current.isX() ? 94 : 50)
        super.init(frame: selfFrame)
        backgroundColor = UIColor.colorWidthHexString(hex: "000000")
        layer.addSublayer(lineLeft)
        layer.addSublayer(lineRight)
        addSubview(btnCall)
        addSubview(btnSummit)
    }
    
    
    private lazy var lineLeft: CALayer = {
        let line = CALayer()
        line.origin = CGPoint(x: 0, y: 0)
        line.frameSize = CGSize(width: kScreenWidth * 0.66, height: height)
        line.backgroundColor = UIColor.colorWidthHexString(hex: "E3D0B1").cgColor
        return line
    }()
    
    private lazy var lineRight: CALayer = {
        let line = CALayer()
        line.origin = CGPoint(x: lineLeft.right, y: 0)
        line.frameSize = CGSize(width: kScreenWidth - lineLeft.width, height: height)
        line.backgroundColor = kMainColor.cgColor
        return line
    }()
    
    lazy var btnCall: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.left = 0
        btn.height = 50
        btn.width = kScreenWidth * 0.66
        btn.top = 0
        btn.backgroundColor = UIColor.colorWidthHexString(hex: "E3D0B1")
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        return btn
    }()
    
    lazy var btnSummit: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.left = btnCall.right
        btn.height = 50
        btn.width = kScreenWidth - btnCall.width
        btn.top = btnCall.top
        btn.backgroundColor = kMainColor
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(UIColor.colorWidthHexString(hex: "D9D9D9"), for: UIControl.State.normal)
        btn.setTitle("立即提交", for: UIControl.State.normal)
        return btn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
