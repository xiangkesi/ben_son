//
//  RSHomeBanderView.swift
//  ben_son
//
//  Created by ZS on 2018/9/6.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import FSPagerView
import RxSwift


private let banderViewHeight: CGFloat = kScreenWidth
private let carViewHeight: CGFloat = kScreenWidth * 0.5 + 34
private let recommendedCarViewHeight: CGFloat = kScreenWidth * 0.66 + 80


private let carBandViewHeight: CGFloat = kScreenWidth * 0.75 + 90

private let headViewHeight: CGFloat = kScreenWidth * 1.16 + kScreenWidth + 194

class BSHomeHeadView: UIView {
    
    //一键用车   本森托管  商务婚庆  本森会员
    let subjectBtnClick = PublishSubject<Int>()
    //点击了品牌
    let subjectClickBrand = PublishSubject<HomeRecommendedBrand>()
    //点击了车辆
    let subjectClickCar = PublishSubject<HomeRecommendedCar>()
    
    let subjectBanderClick = PublishSubject<AdModel>()
    

    
    let disposed = DisposeBag()


    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: headViewHeight)
        super.init(frame: selfFrame)
        
        setupUI()
    }
    
    func bindViewModel(viewModel: RSHomeViewModel) {
        viewModel.adresult?.subscribe(onNext: {[weak self] (ads) in
            self?.banderView.models = ads
        }).disposed(by: viewModel.disposeBag)
        viewModel.recommendedResult?.subscribe(onNext: {[weak self] (home) in
            if home != nil {
//                if home?.secondBrand != nil {
//                    self?.carBandView.subject.onNext(home!.secondBrand!)
//                }
                if home?.secondCar != nil {
                    self?.recommendedCarView.subject.onNext((home?.secondCar!)!)
                }
                if home?.firstBrand != nil && (home?.firstBrand?.count)! > 0 {
                    self?.carView.subjectBrand.onNext((home?.firstBrand?.first)!)
                }
                if home?.firstCar != nil && (home?.firstCar?.count)! > 0 {
                    self?.carView.subjectCar.onNext((home?.firstCar)!)
                }
            }
        }).disposed(by: viewModel.disposeBag)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var banderView: RSHomeBanderView = {
        let bander = RSHomeBanderView()
        bander.headView = self
        return bander
    }()
    
    private lazy var carView: BSHomeCarView = {
        let car = BSHomeCarView()
        car.left = 0
        car.top = banderView.bottom
        car.headView = self
        return car
    }()
    
//    private lazy var carBandView: BSHomeCarBandView = {
//        let bandView = BSHomeCarBandView()
//        bandView.origin = CGPoint(x: 0, y: carView.bottom)
//        bandView.headView = self
//        return bandView
//    }()
    
    private lazy var recommendedCarView: BSHomeRecommendedCarView = {
        let recommendedCar = BSHomeRecommendedCarView()
        recommendedCar.origin = CGPoint(x: 0, y: carView.bottom)
        recommendedCar.headView = self

        return recommendedCar
    }()
    
    private lazy var titleView: BSHomeTitleView = {
        let viewTitle = BSHomeTitleView()
        viewTitle.origin = CGPoint(x: 0, y: recommendedCarView.bottom)
        viewTitle.setValue(title: "新闻资讯", desc: "BRAND CAR RENTAL")
        viewTitle.buttonMore.isHidden = true
        return viewTitle
    }()
}

extension BSHomeHeadView {
    
    private func setupUI() {
        backgroundColor = kMainBackBgColor
        addSubview(banderView)
        addSubview(carView)
//        addSubview(carBandView)
        addSubview(recommendedCarView)
        addSubview(titleView)
    }
}


class RSHomeBanderView: UIView {

    
    weak var headView: BSHomeHeadView?
    
    private var ads = [AdModel]()
    
    private let disposed = DisposeBag()
    
    
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth)
        super.init(frame: selfFrame)
        setupUI()
    }
    
    var models: [AdModel]? {
        didSet{
            ads.removeAll()
            ads = models!
            pageControl.numberOfPages = ads.count
            banaderView.reloadData()
        }
    }
    
    
    private lazy var banaderView: FSPagerView = {
        let banader = FSPagerView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: height - kScreenWidth * 0.25 - 15))
        banader.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "FSPagerViewCell")
        banader.isInfinite = true
        banader.automaticSlidingInterval = 5.0
        banader.itemSize = .zero
        banader.delegate = self
        banader.dataSource = self
        banader.transformer = FSPagerViewTransformer(type: .invertedFerrisWheel)
        return banader
    }()
    
//    private lazy var waveView: BSWaterWaveView = {
//        let wave = BSWaterWaveView()
//        wave.origin = CGPoint(x: 0, y: banaderView.bottom - wave.height)
//        return wave
//    }()
    
    private lazy var pageControl: FSPageControl = {
        let control = FSPageControl.init(frame: CGRect(x: 0, y: banaderView.height - 35, width: width, height: 30))
        control.contentHorizontalAlignment = .right
        control.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return control
    }()
    
    private lazy var btnTypeBg: UIView = {
        let bg = UIView()
        bg.backgroundColor = kMainBackBgColor
        bg.origin = CGPoint(x: 0, y: banaderView.bottom)
        bg.size = CGSize(width: kScreenWidth, height: kScreenWidth * 0.25 + 15)
        return bg
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RSHomeBanderView: FSPagerViewDataSource, FSPagerViewDelegate {
    
    private func setupUI() {
        addSubview(banaderView)
        addSubview(pageControl)
        addSubview(btnTypeBg)
        creatBtns()
    }
    
    private func creatBtns() {
        let arrayBtns = [["title":"本森托管","image":"home_new_usecar"],
                         ["title":"本森活动","image":"home_car_hosting"],
                         ["title":"本森头条","image":"home_car_wedding"],
                         ["title":"本森会员","image":"home_benson_number"]]
        let widthBth = kScreenWidth * 0.25
        
        for (index, value) in arrayBtns.enumerated() {
            let btn = UIButton(type: UIButton.ButtonType.custom)
            btn.top = 15
            btn.left = CGFloat(index) * widthBth
            btn.size = CGSize(width: widthBth, height: widthBth)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btn.setTitleColor(UIColor.colorWidthHexString(hex: "A98054"), for: UIControl.State.normal)
            btn.tag = index + 100
            btn.setTitle(value["title"], for: UIControl.State.normal)
            btn.setImage(UIImage(named: value["image"]!), for: UIControl.State.normal)
            btn.zs_setImagePositionType(type: ImagePositionType.top, spacing: 5)
            btn.rx.tap.subscribe({ (btn) in
                self.headView?.subjectBtnClick.onNext(100 + index)
            }).disposed(by: disposed)
            btnTypeBg.addSubview(btn)
        }
        
    }
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return ads.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cCell = pagerView.dequeueReusableCell(withReuseIdentifier: "FSPagerViewCell", at: index)
        cCell.imageView?.zs_setImage(urlString: ads[index].banderUrl, placerHolder: image_placholder)
        return cCell
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard self.pageControl.currentPage != pagerView.currentIndex else {
            return
        }
        self.pageControl.currentPage = pagerView.currentIndex // Or Use KVO with property "currentIndex"
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let bander = ads[index]
//        subject.onNext(ad)
        headView?.subjectBanderClick.onNext(bander)
    }
    
}

class BSHomeCarDetailView: UIView {
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: (kScreenWidth - 40) * 0.5, height: (kScreenWidth - 40) * 0.25 - 5)
        super.init(frame: selfFrame)
        backgroundColor = UIColor.colorWidthHexString(hex: "1F1F1F")
        addSubview(labelCarName)
        addSubview(labelPraise)
        addSubview(imageIconView)
    }
    
    var car: HomeRecommendedCar? {
        didSet{
            labelCarName.text = car?.model
            imageIconView.zs_setImage(urlString: car?.cover, placerHolder: nil)
            labelPraise.text = "¥" + (car?.onePrice ?? "10000") + "/天"
        }
    }
    
    private lazy var labelCarName: UILabel = {
        let carName = UILabel()
        carName.font = UIFont.systemFont(ofSize: 14)
        carName.origin = CGPoint(x: 10, y: 12)
        carName.size = CGSize(width: width - 20, height: 20)
        carName.textColor = UIColor.white
        carName.backgroundColor = UIColor.colorWidthHexString(hex: "1F1F1F")
        carName.layer.masksToBounds = true
        return carName
    }()
    private lazy var labelPraise: UILabel = {
        let prace = UILabel.init()
        prace.font = UIFont.systemFont(ofSize: 14)
        prace.top = labelCarName.bottom
        prace.left = 10
        prace.size = labelCarName.size
        prace.textColor = UIColor.colorWidthHexString(hex: "A98054")
        prace.backgroundColor = UIColor.colorWidthHexString(hex: "1F1F1F")
        prace.layer.masksToBounds = true
        return prace
    }()
    
    private lazy var imageIconView: UIImageView = {
        let iconView = UIImageView()
        iconView.size = CGSize(width: height * 0.96, height: height * 0.6)
        iconView.left = width - iconView.width
        iconView.top = height - iconView.height
        return iconView
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BSHomeCarLeftView: UIView {
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: (kScreenWidth - 40) * 0.5, height: (kScreenWidth - 40) * 0.5)
        
        super.init(frame: selfFrame)
        backgroundColor = UIColor.colorWidthHexString(hex: "1F1F1F")

        addSubview(labelCarName)
        addSubview(labelPraise)
        addSubview(imageIconView)
    }
    
    var brand: HomeRecommendedBrand? {
        didSet{
            labelCarName.text = brand?.name
            imageIconView.zs_setImage(urlString: brand?.slogo, placerHolder: nil)
        }
    }
    
    
    private lazy var labelCarName: UILabel = {
        let carName = UILabel.init()
        carName.left = 12
        carName.top = 12
        carName.size = CGSize(width: 100, height: 20)
        carName.font = UIFont.systemFont(ofSize: 14)
        carName.textColor = UIColor.white
        return carName
    }()
    
    private lazy var labelPraise: UILabel = {
        let prace = UILabel.init()
        prace.font = UIFont.systemFont(ofSize: 14)
        prace.top = labelCarName.bottom + 5
        prace.left = 12
        prace.size = labelCarName.size
        prace.textColor = UIColor.colorWidthHexString(hex: "A98054")
        prace.text = "新增2辆"
        prace.backgroundColor = UIColor.colorWidthHexString(hex: "1F1F1F")
        prace.layer.masksToBounds = true
        return prace
    }()
    private lazy var imageIconView: UIImageView = {
        let iconView = UIImageView()
        iconView.size = CGSize(width: width, height: width * 0.6)
        iconView.left = 0
        iconView.top = height - iconView.height
        iconView.contentMode = UIView.ContentMode.scaleAspectFit
        return iconView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class BSHomeCarView: UIView {
    
    
    let subjectBrand = PublishSubject<HomeRecommendedBrand>()
    let subjectCar = PublishSubject<[HomeRecommendedCar]>()
    weak var headView: BSHomeHeadView?


    private let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: carViewHeight)
        super.init(frame: selfFrame)
       
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = kMainBackBgColor
        addSubview(leftView)
        addSubview(rightTopView)
        addSubview(rightBottomView)
        layer.addSublayer(bottomLine)
        subjectBrand.subscribe(onNext: {[weak self] (brands) in
           self?.leftView.brand = brands
        }).disposed(by: disposeBag)
        subjectCar.subscribe(onNext: {[weak self] (cars) in
            self?.rightTopView.car = cars.first
            if cars.count > 1 {
                self?.rightBottomView.car = cars[1]
            }
        }).disposed(by: disposeBag)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var leftView: BSHomeCarLeftView = {
        let left = BSHomeCarLeftView()
        left.origin = CGPoint(x: 15, y: 20)
        let tap = UITapGestureRecognizer()
        left.addGestureRecognizer(tap)
        tap.rx.event.subscribe(onNext: {[weak self] (tap) in
            if self?.leftView.brand == nil {return}
            self?.headView?.subjectClickBrand.onNext((self?.leftView.brand)!)
        }).disposed(by: disposeBag)
        return left
    }()
    
    private lazy var rightTopView: BSHomeCarDetailView = {
        let topView = BSHomeCarDetailView()
        topView.left = leftView.right + 10
        topView.top = leftView.top
        let tap = UITapGestureRecognizer()
        topView.addGestureRecognizer(tap)
        tap.rx.event.subscribe(onNext: {[weak self] (tap) in
            if self?.rightTopView.car == nil {return}
            self?.headView?.subjectClickCar.onNext((self?.rightTopView.car)!)
        }).disposed(by: disposeBag)
        return topView
    }()
    
    private lazy var rightBottomView: BSHomeCarDetailView = {
        let bottomView = BSHomeCarDetailView()
        bottomView.left = leftView.right + 10
        bottomView.top = rightTopView.bottom + 10
        let tap = UITapGestureRecognizer()
        bottomView.addGestureRecognizer(tap)
        tap.rx.event.subscribe(onNext: {[weak self] (tap) in
            if self?.rightBottomView.car == nil {return}
            self?.headView?.subjectClickCar.onNext((self?.rightBottomView.car)!)
        }).disposed(by: disposeBag)
        return bottomView
    }()
    
    private lazy var bottomLine: CALayer = {
        let line = CALayer()
        line.origin = CGPoint(x: 0, y: height - 10)
        line.backgroundColor = UIColor.colorWidthHexString(hex: "181818").cgColor
        line.frameSize = CGSize(width: kScreenWidth, height: 10)
        return line
    }()
}

class BSHomeCarBandCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = kMainBackBgColor
        contentView.addSubview(imageIconView)
        contentView.addSubview(labelTitle)
    }
    
    
    func setvalue_brand(brand: HomeRecommendedBrand?, item: Int) {
        imageIconView.zs_setImage(urlString: brand?.slogo, placerHolder: nil)
        labelTitle.text = brand?.name
        
        let itemColor = item % 2
        if item >= 0 && item < 4 {
            contentView.backgroundColor = (itemColor == 0 ? UIColor.colorWidthHexString(hex: "1A1816") : UIColor.colorWidthHexString(hex: "201C19"))
        }else if item >= 4 && item < 8 {
            contentView.backgroundColor = (itemColor == 0 ? UIColor.colorWidthHexString(hex: "201C19") : UIColor.colorWidthHexString(hex: "1A1816"))
        } else {
            contentView.backgroundColor = (itemColor == 0 ? UIColor.colorWidthHexString(hex: "1A1816") : UIColor.colorWidthHexString(hex: "201C19"))
        }

    }
    
    override func layoutSubviews() {
        labelTitle.frame = CGRect(x: 10, y: contentView.height - 26, width: contentView.width - 20, height: 12)
        imageIconView.frame = CGRect(x: 10, y: 10, width: contentView.width - 20, height: contentView.height - 46)
        super.layoutSubviews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var imageIconView: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    
    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.colorWidthHexString(hex: "A98054")
        label.text = "法拉利"
        label.textAlignment = NSTextAlignment.center
//        label.layer.masksToBounds = true
//        label.backgroundColor = contentView.backgroundColor
        return label
    }()
}
class BSHomeCarBandView: UIView {
    
    let subject = PublishSubject<[HomeRecommendedBrand]>()
    private let disposeBag = DisposeBag()

    weak var headView: BSHomeHeadView?

    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: carBandViewHeight)
        super.init(frame: selfFrame)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = kMainBackBgColor
        addSubview(titleView)
        addSubview(collectionView)
        layer.addSublayer(lineBottom)
        
        subject.bind(to: collectionView.rx.items) { (collectionView, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
            let cCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BSHomeCarBandCell", for: indexPath) as! BSHomeCarBandCell
//            cCell.brand = element
            cCell.setvalue_brand(brand: element, item: indexPath.row)
            return cCell
        }.disposed(by: disposeBag)
        
        //获取选中项的内容
        collectionView.rx.modelSelected(HomeRecommendedBrand.self).subscribe(onNext: {[weak self] item in
            self?.headView?.subjectClickBrand.onNext(item)
        }).disposed(by: disposeBag)
        
        titleView.buttonMore.rx.tap.subscribe(onNext: { [weak self] in
               self?.headView?.subjectBtnClick.onNext(1000)
        }).disposed(by: disposeBag)
    }
    
    private lazy var titleView: BSHomeTitleView = {
        let viewTitle = BSHomeTitleView()
        viewTitle.origin = CGPoint(x: 0, y: 0)
        viewTitle.setValue(title: "车型推荐", desc: "BRAND CAR RENTAL")
        return viewTitle
    }()
    
    private lazy var collectionView: UICollectionView = {
        let cellWidth = (kScreenWidth - 30) * 0.25
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let viewCollection = UICollectionView.init(frame: CGRect(), collectionViewLayout: layout)
        viewCollection.origin = CGPoint(x: 15, y: titleView.bottom)
        viewCollection.size = CGSize(width: kScreenWidth - 29, height: (kScreenWidth - 30) * 0.75 + 1)
        viewCollection.register(BSHomeCarBandCell.self, forCellWithReuseIdentifier: "BSHomeCarBandCell")
        viewCollection.backgroundColor = kMainBackBgColor
//        viewCollection.delegate = self
//        viewCollection.dataSource = self
        return viewCollection
    }()
    
    private lazy var lineBottom: CALayer = {
        let line = CALayer()
        line.left = 0
        line.top = height - 10
        line.height = 10
        line.width = kScreenWidth
        line.backgroundColor = UIColor.colorWidthHexString(hex: "181818").cgColor
        return line
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BSHomeTitleView: UIView {
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 80)
        super.init(frame: selfFrame)
        
        backgroundColor = kMainBackBgColor
        addSubview(labelTitle)
        addSubview(labelDesc)
        addSubview(buttonMore)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setValue(title: String, desc: String) {
        labelTitle.text = title
        labelDesc.text = desc
    }
    
    lazy var buttonMore: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.size = CGSize(width: 60, height: 40)
        btn.top = 20
        btn.left = kScreenWidth - 75
        btn.setTitleColor(UIColor.colorWidthHexString(hex: "999999"), for: UIControl.State.normal)
        btn.contentHorizontalAlignment = .right
        btn.setTitle("更多 ▶", for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return btn
    }()
    private lazy var labelTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.init(name: "PingFangSC-Semibold", size: 18)
        title.left = 15
        title.top = 16
        title.size = CGSize(width: 200, height: 24)
        title.textColor = UIColor.white
        title.text = "车型推荐"
//        title.isOpaque = true
        title.layer.masksToBounds = true
        title.backgroundColor = kMainBackBgColor
        return title
    }()
    
    private lazy var labelDesc: UILabel = {
        let detail = UILabel()
        detail.left = 15
        detail.top = labelTitle.bottom + 4
        detail.size = CGSize(width: 200, height: 20)
        detail.font = UIFont.systemFont(ofSize: 14)
        detail.text = "BRAND CAR RENTAL"
        detail.textColor = UIColor.colorWidthHexString(hex: "999999")
        detail.layer.masksToBounds = true
        detail.backgroundColor = kMainBackBgColor
        return detail
    }()
}

class BSHomeRecommendedCarViewCell: UICollectionViewCell {
    
    private let imageWidth = (kScreenWidth - 30) / 1.5
    private let imageHeight = (kScreenWidth - 30) / 1.5 * 0.6

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = kMainBackBgColor
        contentView.addSubview(imageIconView)
        contentView.addSubview(labelCarName)
        contentView.addSubview(labelBandName)
    }
    
    var car: HomeRecommendedCar? {
        didSet{
            imageIconView.zs_setImage(urlString: car?.cover, placerHolder: nil)
            labelBandName.text = car?.model
            labelCarName.text = car?.model
        }
    }
    

    override func layoutSubviews() {
        labelBandName.frame = CGRect(x: 0, y: contentView.height - 16, width: 150, height: 16)
        labelCarName.frame = CGRect(x: 0, y: contentView.height - 40, width: 150, height: 20)
        imageIconView.frame = CGRect(x: 0, y: 0, width: contentView.width, height: contentView.height - 50)
        super.layoutSubviews()
    }
    
    private lazy var imageIconView: UIImageView = {
        let iconView = UIImageView()
        return iconView
    }()
    private lazy var labelCarName: UILabel = {
        let carName = UILabel()
        carName.font = UIFont.systemFont(ofSize: 16)
        carName.textColor = UIColor.colorWidthHexString(hex: "BFBFBF")
        
        carName.layer.masksToBounds = true
        carName.backgroundColor = kMainBackBgColor
        return carName
    }()
    private lazy var labelBandName: UILabel = {
        let BandName = UILabel()
        BandName.font = UIFont.systemFont(ofSize: 13)
        BandName.textColor = UIColor.colorWidthHexString(hex: "5C5C5C")
        BandName.layer.masksToBounds = true
        BandName.backgroundColor = kMainBackBgColor
        return BandName
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class BSHomeRecommendedCarView: UIView {
    
    let subject = PublishSubject<[HomeRecommendedCar]>()
    private let disposeBag = DisposeBag()
    weak var headView: BSHomeHeadView?

    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: recommendedCarViewHeight)
        super.init(frame: selfFrame)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = kMainBackBgColor
        addSubview(titleView)
        addSubview(collectionCarList)
        layer.addSublayer(lineBottom)
        subject.bind(to: collectionCarList.rx.items) { (collectionView, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
            let cCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BSHomeRecommendedCarViewCell", for: indexPath) as! BSHomeRecommendedCarViewCell
            cCell.car = element
            return cCell
        }.disposed(by: disposeBag)
        
        //获取选中项的内容
        collectionCarList.rx.modelSelected(HomeRecommendedCar.self).subscribe(onNext: {[weak self] item in
            self?.headView?.subjectClickCar.onNext(item)
        }).disposed(by: disposeBag)
        
        titleView.buttonMore.rx.tap.subscribe(onNext: { [weak self] in
            self?.headView?.subjectBtnClick.onNext(2000)
        }).disposed(by: disposeBag)
    }
    
    private lazy var titleView: BSHomeTitleView = {
        let viewTitle = BSHomeTitleView()
        viewTitle.origin = CGPoint(x: 0, y: 0)
        viewTitle.setValue(title: "车辆推荐", desc: "BRAND CAR RENTAL")
        return viewTitle
    }()
    
    private lazy var collectionCarList: UICollectionView = {
        let cellWidth = (kScreenWidth - 30) / 1.2
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: cellWidth, height: height - 115)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        
        let carList = UICollectionView.init(frame: CGRect(), collectionViewLayout: layout)
        carList.left = 15
        carList.top = titleView.bottom
        carList.size = CGSize(width: kScreenWidth - 15, height: height - 114)
        carList.register(BSHomeRecommendedCarViewCell.self, forCellWithReuseIdentifier: "BSHomeRecommendedCarViewCell")
        carList.backgroundColor = kMainBackBgColor
//        carList.isPagingEnabled = true
        return carList
    }()
    
    private lazy var lineBottom: CALayer = {
        let line = CALayer()
        line.left = 0
        line.top = height - 10
        line.height = 10
        line.width = kScreenWidth
        line.backgroundColor = UIColor.colorWidthHexString(hex: "181818").cgColor
        return line
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class BSHomeMsgView: UIView {
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: 30, height: 30)
        super.init(frame: selfFrame)
        addSubview(imageMsgView)
        addSubview(labelTitle)
    }
    
    private lazy var imageMsgView: UIImageView = {
        let msgView = UIImageView()
        msgView.size = CGSize(width: width - 6, height: height - 6)
        msgView.origin = CGPoint(x: 3, y: 3)
        msgView.image = UIImage(named: "home_icon_msg")
        msgView.contentMode = UIView.ContentMode.scaleAspectFit
        return msgView
    }()
    
    private lazy var labelTitle: UIView = {
        let title = UIView()
        title.size = CGSize(width: 10, height: 10)
        title.backgroundColor = UIColor.red
        title.left = 22
        title.top = -2
        title.zs_corner()
        return title
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BSHomeLocationView: UIView {
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: 50, height: 30)
        super.init(frame: selfFrame)
        
        addSubview(labelTitle)
        addSubview(imageArrow)
    }
    
    lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.left = 0
        label.top = 0
        label.text = "上海市"
        label.sizeToFit()
        label.height = 30
        label.textColor = UIColor.white
        return label
    }()
    lazy var imageArrow: UIImageView = {
        let arrow = UIImageView()
        arrow.size = CGSize(width: 16, height: 16)
        arrow.left = labelTitle.right
        arrow.top = 7
        arrow.image = UIImage(named: "home_choosecity_arrow")
        arrow.isUserInteractionEnabled = true
        return arrow
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class RSHomeNavView: UIView {
    
    let disposeBag = DisposeBag()
    
    weak var msgViewTap: UITapGestureRecognizer?
    
    weak var viewLocationTap: UITapGestureRecognizer?
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: UIDevice.current.navigationBarHeight())
        super.init(frame: selfFrame)
        setupUI()
    }
    
    var locationString: String? {
        didSet{
            if locationString == nil {return}
            viewLocation.labelTitle.text = locationString
            viewLocation.labelTitle.sizeToFit()
            viewLocation.labelTitle.height = 30
            viewLocation.imageArrow.left = viewLocation.labelTitle.right
            viewLocation.width = viewLocation.labelTitle.width + 16
            buttonSearch.left = viewLocation.right + 5
            buttonSearch.width = kContentWidth - viewLocation.width - 40

        }
    }
    
    private lazy var viewLocation: BSHomeLocationView = {
        let location = BSHomeLocationView()
        location.origin = CGPoint(x: kSpacing, y: UIDevice.current.navigationSubviewY())
        return location
    }()
    
    lazy var buttonSearch: UIButton = {
        let search = UIButton(type: UIButton.ButtonType.custom)
        search.size = CGSize(width: kScreenWidth - 140, height: 30)
        search.origin = CGPoint(x: viewLocation.right + 5, y: viewLocation.top)
        search.setImage(UIImage(named: "common_search"), for: UIControl.State.normal)
        search.setImage(UIImage(named: "common_search"), for: UIControl.State.highlighted)
        search.contentHorizontalAlignment = .left
        search.setTitle("输入车型或者关键字", for: UIControl.State.normal)
        search.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        search.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        search.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        search.setTitleColor(UIColor.colorWidthHexString(hex: "999999"), for: UIControl.State.normal)
        search.setBackgroundImage(UIImage(named: "home_search_bg"), for: UIControl.State.normal)
        search.setBackgroundImage(UIImage(named: "home_search_bg"), for: UIControl.State.highlighted)

        return search
    }()
    
    private lazy var msgView: BSHomeMsgView = {
        let msg = BSHomeMsgView()
        msg.top = viewLocation.top
        msg.left = kScreenWidth - 45
        return msg
    }()
    
    private lazy var imageView: UIImageView = {
        let imageBg = UIImageView()
        imageBg.frame = frame
        imageBg.image = UIImage(named: "nav_backgound_top")
        return imageBg
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RSHomeNavView {
    
    
    private func setupUI() {
        backgroundColor = UIColor.init(white: 0, alpha: 1.0)
        addSubview(imageView)
        addSubview(viewLocation)
        addSubview(msgView)
        addSubview(buttonSearch)
        
        let tap = UITapGestureRecognizer()
        msgView.addGestureRecognizer(tap)
        msgViewTap = tap
        
        let locationTap = UITapGestureRecognizer()
        viewLocation.addGestureRecognizer(locationTap)
        viewLocationTap = locationTap
    }
}
