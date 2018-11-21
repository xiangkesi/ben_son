//
//  BSCarDetailBanderView.swift
//  ben_son
//
//  Created by ZS on 2018/10/15.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import FSPagerView
import RxCocoa
import RxSwift


class BSCarDetailFirstCell: UICollectionViewCell {
    
    var disposeBag = DisposeBag()

    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(mainView)
        
//        BSVideoManager.init(urlString: "http://a.raykart.com/2018%20British%20Grand%20Prix-%20Race%20Highlights.mp4", fatherView: mainView)
        
    }
    
    deinit {
        BSLog("视频播放竟然没有销毁")
    }
    
    lazy var imageView: UIButton = {
        let iconView = UIButton(type: UIButton.ButtonType.custom)
        iconView.backgroundColor = UIColor.red
        return iconView
    }()
    
    lazy var mainView: UIView = {
        let main = UIView()
        main.size = CGSize(width: kScreenWidth, height: 200)
        main.backgroundColor = UIColor.purple
        return main
    }()
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.origin = CGPoint(x: 0, y: 0)
        imageView.size = CGSize(width: contentView.width, height: contentView.height)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BSCarDetailSecondCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    lazy var imageView: UIImageView = {
        let iconView = UIImageView()
        iconView.backgroundColor = UIColor.yellow
        return iconView
    }()
    
    deinit {
        BSLog("这个呢销毁了没有")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.origin = CGPoint(x: 0, y: 0)
        imageView.size = CGSize(width: contentView.width, height: contentView.height)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class BSCarDetailBanderView: UIView {

    let disposeBag = DisposeBag()
    let clickSubject = PublishSubject<Int>()
    
    let images_subject = PublishSubject<[String]>()
    
    var player_manager: BSVideoManager?
    
    
    
    
    private var photos = [String]()
    private var current: Int = 1
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth * 0.65)
        super.init(frame: selfFrame)
        setupUI()
    }
    
    
    var images: [String]? {
        didSet{
            guard let _ = images else {
                return
            }
            photos = images!
            labelTitle.text = String(current) + "/" + String(photos.count)
            banaderView.reloadData()
            images_subject.onNext(photos)
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let flawLayout = UICollectionViewFlowLayout()
        flawLayout.itemSize = CGSize(width: width, height: height)
        flawLayout.minimumLineSpacing = 0
        flawLayout.minimumInteritemSpacing = 0
        flawLayout.scrollDirection = .horizontal
        let viewCollection = UICollectionView(frame: CGRect(x: 0, y: 0, width: width, height: height), collectionViewLayout: flawLayout)
        viewCollection.register(BSCarDetailFirstCell.self, forCellWithReuseIdentifier: "BSCarDetailFirstCell")
        viewCollection.register(BSCarDetailSecondCell.self, forCellWithReuseIdentifier: "BSCarDetailSecondCell")
        viewCollection.isPagingEnabled = true
        return viewCollection
    }()
    private lazy var banaderView: FSPagerView = {
        let banader = FSPagerView.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        banader.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "FSPagerViewCell")
        banader.isInfinite = true
        banader.automaticSlidingInterval = 4.0
        banader.itemSize = .zero
        banader.delegate = self
        banader.dataSource = self
        return banader
    }()
    
    private lazy var imageView: UIImageView = {
        let imageBg = UIImageView()
        imageBg.frame = CGRect(x: 0, y: height - 60, width: kScreenWidth, height: 60)
        imageBg.image = UIImage(named: "nav_backgound_bottom")
        return imageBg
    }()
    
    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.size = CGSize(width: 46, height: 22)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.zs_corner()
        label.left = kScreenWidth - 60
        label.top = height - 30
        label.backgroundColor = kMainColor.withAlphaComponent(0.2)
        return label
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BSCarDetailBanderView: FSPagerViewDataSource, FSPagerViewDelegate {
    
    private func setupUI() {
        addSubview(banaderView)
        addSubview(imageView)
        addSubview(labelTitle)
        
        addSubview(collectionView)
        
        images_subject.bind(to: collectionView.rx.items) { (collectionView, row, element) in
                let indexPath = IndexPath(row: row, section: 0)
            
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BSCarDetailFirstCell",
                                                              for: indexPath) as! BSCarDetailFirstCell
                cell.imageView.rx.tap.asDriver().drive(onNext: { [weak self] in
                    
                    
                  self?.player_manager = BSVideoManager.init(urlString: "http://a.raykart.com/2018%20British%20Grand%20Prix-%20Race%20Highlights.mp4", fatherView: cell.mainView)
                    
                }).disposed(by: cell.disposeBag)

                return cell
            }else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BSCarDetailSecondCell",
                                                              for: indexPath) as! BSCarDetailSecondCell
                cell.imageView.zs_setImage(urlString: element, placerHolder: image_placholder)
                return cell
            }
            
            }.disposed(by: disposeBag)
        
        
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return photos.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cCell = pagerView.dequeueReusableCell(withReuseIdentifier: "FSPagerViewCell", at: index)
        cCell.imageView?.zs_setImage(urlString: photos[index], placerHolder: image_placholder)
        return cCell
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard current != pagerView.currentIndex else {
            return
        }
        current = pagerView.currentIndex
        labelTitle.text = String(current + 1) + "/" + String(photos.count)
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        clickSubject.onNext(index)
    }
}

class BSCarDetailCarNameView: UIView {
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 116)
        super.init(frame: selfFrame)
        addSubview(labelTitle)
        layer.addSublayer(lineBottom)
        addSubview(imageIcon)
        addSubview(labelDesc)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.size = CGSize(width: kContentWidth, height: 64)
        label.backgroundColor = kMainBackBgColor
        label.font = UIFont.init(name: "PingFangSC-Regular", size: 18)
        label.textColor = UIColor.colorWidthHexString(hex: "BFBFBF")
        label.left = kSpacing
        label.top = 0
        label.layer.masksToBounds = true

        return label
    }()
    
    private lazy var lineBottom: CALayer = {
        let line = CALayer()
        line.left = kSpacing
        line.frameSize = CGSize(width: kContentWidth, height: 0.5)
        line.backgroundColor = UIColor.colorWidthHexString(hex: "322A21").cgColor
        line.top = 64
        return line
    }()
    
    private lazy var imageIcon: UIImageView = {
        let icon = UIImageView()
        icon.size = CGSize(width: 16, height: 16)
        icon.left = kSpacing
        icon.top = 82
        icon.image = UIImage(named: "car_detail_tips")
        return icon
    }()
    
    private lazy var labelDesc: UILabel = {
        let label = UILabel()
        label.size = CGSize(width: kScreenWidth - 50, height: 16)
        label.backgroundColor = kMainBackBgColor
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.colorWidthHexString(hex: "5C5C5C")
        label.text = "请尽快完成预定，方便门店提前为您准备车辆。"
        label.left = imageIcon.right + 4.0
        label.top = imageIcon.top
        label.layer.masksToBounds = true

        return label
    }()
    
}

class BSCarDetailPriceCell: BSCommentCell {
    
    override func setupUI() {
        super.setupUI()
        contentView.backgroundColor = UIColor.colorWidthHexString(hex: "0A0A0A")
        contentView.addSubview(labelFirst)
        contentView.addSubview(labelSecond)
        contentView.addSubview(labelThired)
        contentView.addSubview(labelFour)
        contentView.layer.addSublayer(lineSecond)
        contentView.layer.addSublayer(lineThired)
        contentView.layer.addSublayer(lineFour)
        contentView.layer.addSublayer(lineTop)
    }
    
    var prace: CarDetailPrace?{
        didSet{
            labelFirst.text = prace?.day_title
            labelSecond.text = prace?.oneDay_prace
            labelThired.text = prace?.threeDay_prace
            labelFour.text = prace?.week_prace
        }
    }
    
    
    private lazy var labelFirst: UILabel = {
        let label = UILabel()
        label.size = CGSize(width: kContentWidth * 0.25, height: 50)
        label.backgroundColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.colorWidthHexString(hex: "BFBFBF")
        label.text = "一天"
        label.textAlignment = .center
        label.left = 0
        label.top = 0
        label.layer.masksToBounds = true
        return label
    }()
    
    private lazy var labelSecond: UILabel = {
        let label = UILabel()
        label.size = CGSize(width: labelFirst.width, height: 50)
        label.backgroundColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = kMainColor
        label.text = "10000/天"
        label.left = labelFirst.right
        label.textAlignment = .center
        label.top = 0
        label.layer.masksToBounds = true
        return label
    }()
    
    private lazy var labelThired: UILabel = {
        let label = UILabel()
        label.size = CGSize(width: labelSecond.width, height: 50)
        label.backgroundColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = kMainColor
        label.text = "10000/天"
        label.left = labelSecond.right
        label.textAlignment = .center
        label.top = 0
        label.layer.masksToBounds = true
        return label
    }()
    
    private lazy var labelFour: UILabel = {
        let label = UILabel()
        label.size = CGSize(width: labelSecond.width, height: 50)
        label.backgroundColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = kMainColor
        label.text = "10000/天"
        label.left = labelThired.right
        label.top = 0
        label.textAlignment = .center
        label.layer.masksToBounds = true

        return label
    }()
    
    private lazy var lineSecond: CALayer = {
        let line = CALayer()
        line.frame = CGRect(x: labelFirst.right, y: 0, width: 0.5, height: 50)
        line.backgroundColor = UIColor.colorWidthHexString(hex: "322A21").cgColor
        return line
    }()
    
    private lazy var lineThired: CALayer = {
        let line = CALayer()
        line.frame = CGRect(x: labelSecond.right, y: 0, width: 0.5, height: 50)
        line.backgroundColor = UIColor.colorWidthHexString(hex: "322A21").cgColor
        return line
    }()
    
    private lazy var lineFour: CALayer = {
        let line = CALayer()
        line.frame = CGRect(x: labelThired.right, y: 0, width: 0.5, height: 50)
        line.backgroundColor = UIColor.colorWidthHexString(hex: "322A21").cgColor
        return line
    }()
    
    private lazy var lineTop: CALayer = {
        let line = CALayer()
        line.frame = CGRect(x: 0, y: 0, width: kContentWidth, height: 0.5)
        line.backgroundColor = UIColor.colorWidthHexString(hex: "322A21").cgColor
        return line
    }()
    
}
class BSCarDetailPriceListView: UIView {
    
    private let disposeBag = DisposeBag()
    
    let subjectPrace = PublishSubject<[CarDetailPrace]>()
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kContentWidth, height: 300)
        super.init(frame: selfFrame)
        
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = kMainBackBgColor
        addSubview(tableViewPrice)
        subjectPrace.bind(to: tableViewPrice.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "BSCarDetailPriceCell") as! BSCarDetailPriceCell
                cell.prace = element
                return cell
            }.disposed(by: disposeBag)
    }
    
    
    private lazy var tableViewPrice: UITableView = {
        let table = UITableView.init(frame: CGRect(), style: UITableView.Style.plain)
        table.frame = CGRect(x: kSpacing, y: 0, width: kContentWidth, height: height)
        table.register(BSCarDetailPriceCell.self, forCellReuseIdentifier: "BSCarDetailPriceCell")
        table.rowHeight = 50
        table.tableHeaderView = headView
        table.separatorStyle = .none
        table.backgroundColor = kMainBackBgColor
        table.isScrollEnabled = false

        let maskPath = UIBezierPath(rect: table.bounds)
        let borderLayer = CAShapeLayer.init()
        borderLayer.path = maskPath.cgPath
        borderLayer.lineWidth = 1
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.colorWidthHexString(hex: "322A21").cgColor
        borderLayer.frame = table.bounds
        table.layer.addSublayer(borderLayer)
//        table.clipsToBounds = true

        return table
    }()
    
    private lazy var headView: UIView = {
        let head = UIView()
        head.frame = CGRect(x: 0, y: 0, width: kContentWidth, height: 50)
        head.backgroundColor = UIColor.black
        head.addSubview(labelNormalMember)
        head.addSubview(labelGoldMember)
        head.addSubview(labelBlackMember)
        return head
    }()
    
    private lazy var labelNormalMember: UILabel = {
        let member = UILabel()
        member.size = CGSize(width: kContentWidth * 0.25 - 20, height: 24)
        member.top = 13
        member.font = UIFont.systemFont(ofSize: 12)
        member.text = "普通会员"
        member.textColor = UIColor.colorWidthHexString(hex: "999999")
        member.backgroundColor = UIColor.colorWidthHexString(hex: "333333")
        member.textAlignment = .center
        member.left = kContentWidth * 0.25 + 10
        member.layer.masksToBounds = true

        return member
    }()
    
    private lazy var labelGoldMember: UILabel = {
        let member = UILabel()
        member.size = CGSize(width: kContentWidth * 0.25 - 20, height: 24)
        member.top = 13
        member.font = UIFont.systemFont(ofSize: 12)
        member.text = "金卡会员"
        member.textColor = UIColor.colorWidthHexString(hex: "F4F4F4")
        member.backgroundColor = kMainColor
        member.textAlignment = .center
        member.left = kContentWidth * 0.5 + 10
        member.layer.masksToBounds = true

        return member
    }()
    
    private lazy var labelBlackMember: UILabel = {
        let member = UILabel()
        member.size = CGSize(width: kContentWidth * 0.25 - 20, height: 24)
        member.top = 13
        member.font = UIFont.systemFont(ofSize: 12)
        member.text = "黑卡会员"
        member.textColor = UIColor.colorWidthHexString(hex: "F4F4F4")
        member.backgroundColor = UIColor.colorWidthHexString(hex: "222222")
        member.textAlignment = .center
        member.left = kContentWidth * 0.75 + 10
        member.layer.masksToBounds = true

        return member
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class BSCarDetailInstructionsView: UIView {
    
    
    let descHeight = "以上报价为本森超跑俱乐部所在地（上海、北京、广州、深圳、三亚、杭州、重庆、成都）24小时150公里使用价格；其他区域用车或需要更多公里数，优惠价格请详询客服。".heightString(font: UIFont.systemFont(ofSize: 15), width: kContentWidth)
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 102 + descHeight)
        super.init(frame: selfFrame)
        
        addSubview(labelDesc)
        layer.addSublayer(lineTop)
        addSubview(btnDesc)
        layer.addSublayer(lineBottom)
    }
    
    private lazy var labelDesc: UILabel = {
        let member = UILabel()
        member.size = CGSize(width: kContentWidth, height: descHeight)
        member.top = 20
        member.font = UIFont.systemFont(ofSize: 15)
        member.text = "以上报价为本森超跑俱乐部所在地（上海、北京、广州、深圳、三亚、杭州、重庆、成都）24小时150公里使用价格；其他区域用车或需要更多公里数，优惠价格请详询客服。"
        member.numberOfLines = 0
        member.textColor = UIColor.colorWidthHexString(hex: "5C5C5C")
        member.backgroundColor = kMainBackBgColor
        member.left = kSpacing
        member.layer.masksToBounds = true
        return member
    }()
    
    private lazy var lineTop: CALayer = {
        let line = CALayer()
        line.frame = CGRect(x: kSpacing, y: labelDesc.bottom + 16, width: kContentWidth, height: 0.5)
        line.backgroundColor = UIColor.colorWidthHexString(hex: "322A21").cgColor
        return line
    }()
    
    private lazy var btnDesc: UIButton = {
       let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.left = kSpacing
        btn.width = kContentWidth
        btn.top = lineTop.bottom
        btn.height = 56
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.colorWidthHexString(hex: "5C5C5C"), for: UIControl.State.normal)
        btn.setTitle("关于收取押金的说明 ▶", for: UIControl.State.normal)
        btn.setImage(UIImage(named: "car_detail_instructions"), for: UIControl.State.normal)
        btn.setImage(UIImage(named: "car_detail_instructions"), for: UIControl.State.highlighted)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        btn.contentHorizontalAlignment = .left
        return btn
    }()

    
    private lazy var lineBottom: CALayer = {
        let line = CALayer()
        line.frame = CGRect(x: 0, y: height - 10, width: kScreenWidth, height: 10)
        line.backgroundColor = UIColor.colorWidthHexString(hex: "1A1A1A").cgColor
        return line
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class BSCarDetailMsgCell: BSCommentCell {
    
    override func setupUI() {
        super.setupUI()
        backgroundColor = UIColor.colorWidthHexString(hex: "0A0A0A")
        contentView.addSubview(labelName)
        contentView.addSubview(labelDesc)
        line.frame = CGRect(x: 25, y: 49.5, width: kContentWidth - 50, height: 0.5)
        contentView.layer.addSublayer(line)
    }
    var msg: CarDetailPrace? {
        didSet{
            labelName.text = msg?.day_title
            labelDesc.text = msg?.oneDay_prace
        }
    }
    private lazy var labelName: UILabel = {
        let member = UILabel()
        member.size = CGSize(width: 150, height: 20)
        member.top = 15
        member.font = UIFont.systemFont(ofSize: 13)
        member.textColor = kMainColor
        member.backgroundColor = UIColor.colorWidthHexString(hex: "0A0A0A")
        member.left = 25
        member.layer.masksToBounds = true
        return member
    }()
    
    private lazy var labelDesc: UILabel = {
        let member = UILabel()
        member.size = CGSize(width: 100, height: 20)
        member.top = 15
        member.font = UIFont.systemFont(ofSize: 13)
        member.textColor = UIColor.colorWidthHexString(hex: "74593D")
        member.backgroundColor = UIColor.colorWidthHexString(hex: "0A0A0A")
        member.textAlignment = NSTextAlignment.right
        member.left = kContentWidth - 125
        member.layer.masksToBounds = true

        return member
    }()
}

class BSCarDetailCommonView: UIView {
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 85)
        
        super.init(frame: selfFrame)
        addSubview(labelTitle)
        addSubview(labelDesc)
    }
    
    func settitle(title: String, desc: String) {
        labelTitle.text = title
        labelDesc.text = desc
    }
    private lazy var labelTitle: UILabel = {
        let member = UILabel()
        member.size = CGSize(width: 100, height: 24)
        member.top = 20
        member.font = UIFont.systemFont(ofSize: 18)
        member.text = "车辆参数"
        member.textColor = UIColor.colorWidthHexString(hex: "D9D9D9")
        member.backgroundColor = kMainBackBgColor
        member.left = kSpacing
        member.layer.masksToBounds = true
        return member
    }()
    
    private lazy var labelDesc: UILabel = {
        let member = UILabel()
        member.size = CGSize(width: 200, height: 20)
        member.top = labelTitle.bottom + 5
        member.font = UIFont.systemFont(ofSize: 14)
        member.text = "CAR parameters"
        member.textColor = UIColor.colorWidthHexString(hex: "383838")
        member.backgroundColor = kMainBackBgColor
        member.left = kSpacing
        member.layer.masksToBounds = true
        return member
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class BSCarDetailMsgView: UIView {
    
    private let disposeBag = DisposeBag()
    
    let subjectCarMsg = PublishSubject<[CarDetailPrace]>()
    

    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 500)
        
        super.init(frame: selfFrame)
        setupUI()
       
    }
    
    private func setupUI() {
        backgroundColor = kMainBackBgColor
        addSubview(titleViewBg)
        addSubview(tableViewMsg)
        addBottomLine(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), UIColor.colorWidthHexString(hex: "1A1A1A"), 10)
        subjectCarMsg.bind(to: tableViewMsg.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "BSCarDetailMsgCell") as! BSCarDetailMsgCell
            cell.msg = element
            return cell
            }.disposed(by: disposeBag)
    }
    
    
    private lazy var titleViewBg: BSCarDetailCommonView = {
        let bg = BSCarDetailCommonView()
        bg.left = 0
        bg.top = 0
        return bg
    }()
    
    
    private lazy var tableViewMsg: UITableView = {
        let table = UITableView(frame: CGRect(), style: UITableView.Style.plain)
        table.register(BSCarDetailMsgCell.self, forCellReuseIdentifier: "BSCarDetailMsgCell")
        table.rowHeight = 50
        table.frame = CGRect(x: kSpacing, y: titleViewBg.bottom, width: kContentWidth, height: 380)
        table.separatorStyle = .none
        table.backgroundColor = UIColor.colorWidthHexString(hex: "0D0D0D")
        table.isScrollEnabled = false
        table.tableHeaderView = headView
        table.tableFooterView = footerView
        let imageBg = UIImageView(frame: table.bounds)
        let imageIcon = UIImage(named: "car_detail_msgbg")
        imageBg.image = imageIcon?.stretchableImage(withLeftCapWidth: 50, topCapHeight: 50)
        table.backgroundView = imageBg
        
        return table
    }()
    
    
    private lazy var headView: UIView = {
        let head = UIView()
        head.origin = CGPoint(x: 0, y: 0)
        head.size = CGSize(width: kContentWidth, height: 60)
        head.backgroundColor = UIColor.colorWidthHexString(hex: "0A0A0A")
        head.addBottomLine(UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25))
        head.addSubview(labelHeadName)
        head.addSubview(labelHeadDesc)
        return head
    }()
    private lazy var labelHeadName: UILabel = {
        let member = UILabel()
        member.size = CGSize(width: 150, height: 20)
        member.top = 25
        member.font = UIFont.systemFont(ofSize: 13)
        member.textColor = kMainColor
        member.backgroundColor = UIColor.colorWidthHexString(hex: "0A0A0A")
        member.left = 25
        member.layer.masksToBounds = true
        member.text = "发动机"
        return member
    }()
    
    lazy var labelHeadDesc: UILabel = {
        let member = UILabel()
        member.size = CGSize(width: 100, height: 20)
        member.top = 25
        member.font = UIFont.systemFont(ofSize: 13)
        member.textColor = UIColor.colorWidthHexString(hex: "74593D")
        member.backgroundColor = UIColor.colorWidthHexString(hex: "0A0A0A")
        member.textAlignment = NSTextAlignment.right
        member.left = kContentWidth - 125
        member.layer.masksToBounds = true
        
        return member
    }()
    
    
    private lazy var footerView: UIView = {
        let head = UIView()
        head.origin = CGPoint(x: 0, y: 0)
        head.backgroundColor = UIColor.colorWidthHexString(hex: "0A0A0A")
        head.size = CGSize(width: kContentWidth, height: 70)
        head.addSubview(labelFooterName)
        head.addSubview(labelFooterDesc)
        return head
    }()
    
    private lazy var labelFooterName: UILabel = {
        let member = UILabel()
        member.size = CGSize(width: 150, height: 20)
        member.top = 15
        member.font = UIFont.systemFont(ofSize: 13)
        member.textColor = kMainColor
        member.backgroundColor = UIColor.colorWidthHexString(hex: "0A0A0A")
        member.left = 25
        member.layer.masksToBounds = true
        member.text = "座位"
        return member
    }()
    
    lazy var labelFooterDesc: UILabel = {
        let member = UILabel()
        member.size = CGSize(width: 100, height: 20)
        member.top = 15
        member.font = UIFont.systemFont(ofSize: 13)
        member.textColor = UIColor.colorWidthHexString(hex: "74593D")
        member.backgroundColor = UIColor.colorWidthHexString(hex: "0A0A0A")
        member.textAlignment = NSTextAlignment.right
        member.left = kContentWidth - 125
        member.layer.masksToBounds = true
        
        return member
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class CarDetailRentalView: UIView {
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kContentWidth * 0.5 + 115)
        super.init(frame: selfFrame)
        addSubview(titleViewBg)
        addSubview(imageView)
        addBottomLine(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), UIColor.colorWidthHexString(hex: "1A1A1A"), 10)
    }
    
    private lazy var titleViewBg: BSCarDetailCommonView = {
        let bg = BSCarDetailCommonView()
        bg.origin = CGPoint(x: 0, y: 0)
        bg.settitle(title: "租车流程", desc: "Car rental process")
        return bg
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.left = kSpacing
        image.top = titleViewBg.bottom
        image.width = kContentWidth
        image.height = kContentWidth * 0.5
        image.image = UIImage(named: "car_detail_rentalprocess")
        return image
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class CarDetailServiceGuaranteeView: UIView {
    
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kContentWidth + 130)
        super.init(frame: selfFrame)
        addSubview(titleViewBg)
        addSubview(imageView)
    }
    
    
    private lazy var titleViewBg: BSCarDetailCommonView = {
        let bg = BSCarDetailCommonView()
        bg.origin = CGPoint(x: 0, y: 0)
        bg.settitle(title: "服务保障", desc: "Service guarantee")
        return bg
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.left = kSpacing
        image.top = titleViewBg.bottom
        image.width = kContentWidth
        image.height = kContentWidth
        image.image = UIImage(named: "image_service_guarantee")
        return image
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class CarDetailFootView: UIView {
    let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: UIDevice.current.isX() ? 84 : 50)
        super.init(frame: selfFrame)
        backgroundColor = kMainColor
        layer.addSublayer(lineLeft)
        layer.addSublayer(lineRight)
        addSubview(btnCall)
        addSubview(btnSummit)
    }
    
    private lazy var lineLeft: CALayer = {
        let line = CALayer()
        line.backgroundColor = UIColor.colorWidthHexString(hex: "E3D0B1").cgColor
        line.frameSize = CGSize(width: kScreenWidth * 0.37, height: height)
        line.origin = CGPoint(x: 0, y: 0)
        return line
    }()
    
    private lazy var lineRight: CALayer = {
        let line = CALayer()
        line.backgroundColor = UIColor.colorWidthHexString(hex: "A98054").cgColor
        line.frameSize = CGSize(width: kScreenWidth - lineLeft.width, height: height)
        line.origin = CGPoint(x: lineLeft.right, y: 0)
        return line
    }()
    
    
    lazy var btnCall: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.left = 0
        btn.height = 50
        btn.width = kScreenWidth * 0.37
        btn.top = 0
        btn.backgroundColor = UIColor.colorWidthHexString(hex: "E3D0B1")
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(UIColor.colorWidthHexString(hex: "111111"), for: UIControl.State.normal)
        btn.setTitle("  电话咨询", for: UIControl.State.normal)
        btn.setImage(UIImage(named: "icon_telephone_counseling"), for: UIControl.State.normal)
        btn.setImage(UIImage(named: "icon_telephone_counseling"), for: UIControl.State.highlighted)

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
        btn.setTitle("立即预定", for: UIControl.State.normal)
        return btn
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CarDetailNavView: UIView {
    
    let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: UIDevice.current.navigationBarHeight())
        super.init(frame: selfFrame)
        addSubview(imageView)
        addSubview(buttonBack)
        addSubview(buttonJoinVip)
        addSubview(shareBtn)
        addSubview(collectionBtn)
    }
    
    private lazy var imageView: UIImageView = {
        let imageBg = UIImageView()
        imageBg.frame = frame
        imageBg.image = UIImage(named: "nav_backgound_top")
        return imageBg
    }()
    
    lazy var buttonBack: UIButton = {
        let location = UIButton.init()
        location.size = CGSize(width: 40, height: 30)
        location.origin = CGPoint(x: 15, y: UIDevice.current.navigationSubviewY())
        location.setImage(UIImage(named: "common_back"), for: UIControl.State.normal)
        location.setImage(UIImage(named: "common_back"), for: UIControl.State.highlighted)
        location.contentHorizontalAlignment = .left
        location.imageView?.isUserInteractionEnabled = false
        return location
    }()
    
    lazy var buttonJoinVip: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.height = 30
        btn.width = 30 / 0.173
        btn.left = buttonBack.right
        btn.top = buttonBack.top
        btn.setBackgroundImage(UIImage(named: "join_image_vip"), for: UIControl.State.normal)
        btn.setBackgroundImage(UIImage(named: "join_image_vip"), for: UIControl.State.highlighted)

        return btn
    }()
    
    lazy var shareBtn: UIButton = {
        let share = UIButton(type: UIButton.ButtonType.custom)
        share.size = CGSize(width: 30, height: 30)
        share.origin = CGPoint(x: kScreenWidth - 45, y: buttonBack.top)
        share.setImage(UIImage(named: "icon_share_normal"), for: UIControl.State.normal)
        share.setImage(UIImage(named: "icon_share_normal"), for: UIControl.State.highlighted)

        return share
    }()
    
    lazy var collectionBtn: UIButton = {
        let share = UIButton(type: UIButton.ButtonType.custom)
        share.size = CGSize(width: 30, height: 30)
        share.origin = CGPoint(x: shareBtn.left - 45, y: buttonBack.top)
        share.setImage(UIImage(named: "icon_collect_normal"), for: UIControl.State.normal)
        share.setImage(UIImage(named: "icon_collect_selected"), for: UIControl.State.selected)
        share.adjustsImageWhenHighlighted = false
        
        return share
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
