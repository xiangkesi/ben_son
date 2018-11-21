//
//  BSCarHeadView.swift
//  ben_son
//
//  Created by ZS on 2018/9/6.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift

class BSCarHeadView: UIView {

    private let disposeBag = DisposeBag()
    private weak var layoutItem: BSHorizontalPageLayout?

    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height:  kScreenWidth * 0.6 + 45)
        super.init(frame: selfFrame)
        
        setupUI()
    }
    
    func setupViewModel(viewModel: BSCarViewModel) {
        
        viewModel.result!.bind(to: collectionCar.rx.items) { (collectionView, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BSCarHeadViewCell", for: indexPath)
            if let cCell = cell as? BSCarHeadViewCell {
                cCell.brand = element
            }
            return cell
            }.disposed(by: disposeBag)
        
        collectionCar.rx.modelSelected(CarBrand.self).subscribe(onNext: {[weak viewModel] (car) in
            for brand in (viewModel?.carBrands)! {
                brand.selected = false
                if car.brandId == brand.brandId {
                    brand.selected = true
                }
            }
            if #available(iOS 10.0, *) {
                BSFeedbackTool.manager.play()
            }
            viewModel?.loadData.onNext(100)
            viewModel?.loadModelData.onNext((value: car.cars!, type: 100))
        }).disposed(by: disposeBag)
        
        collectionCar.rx.didScroll.subscribe(onNext: { [weak self] in
            self?.pageControl.currentPage = (self?.currentIndex())!
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var collectionCar: UICollectionView = {
        let layout = BSHorizontalPageLayout.init()
        layoutItem = layout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: kScreenWidth * 0.25 - 0.5, height: kScreenWidth * 0.2 - 0.5)
        let collectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth * 0.6), collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = kMainBackBgColor
        collectionView.register(BSCarHeadViewCell.self, forCellWithReuseIdentifier: "BSCarHeadViewCell")
        return collectionView
    }()
    
    
    private lazy var pageControl: UIPageControl = {
        let page = UIPageControl(frame: CGRect(x: 0, y: collectionCar.bottom, width: kScreenWidth, height: 45))
        page.currentPageIndicatorTintColor = UIColor.colorWidthHexString(hex: "BFBFBF")
        page.pageIndicatorTintColor = UIColor.colorWidthHexString(hex: "5A5A5A")
        page.numberOfPages = 3
        return page
    }()

    
}

extension BSCarHeadView {
    
    private func setupUI() {
        addSubview(collectionCar)
        addSubview(pageControl)
    }
    
    private func currentIndex() -> Int {
        let index = (collectionCar.contentOffset.x + (layoutItem?.itemSize.width)! * 2) / ((layoutItem?.itemSize.width)! * 4)
        return Int(max(0, index))
    }
}

class BSCarHeadViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = kMainBackBgColor
        contentView.addSubview(labelTitle)
        contentView.addSubview(imageView)
//        contentView.layer.addSublayer(shapeLayer)
//        contentView.layer.addSublayer(redLayer)
        
//        let MAX = 0.98
//        let GAP = 0.02
//
//        let aniStart = CABasicAnimation(keyPath: "strokeStart")
//        aniStart.fromValue = 0
//        aniStart.toValue = MAX
//
//        let aniEnd = CABasicAnimation(keyPath: "strokeEnd")
//        aniEnd.fromValue = GAP
//        aniEnd.toValue = MAX + GAP
//
//        let group = CAAnimationGroup.init()
//        group.duration = 1
//        group.repeatCount = MAXFLOAT
////        group.autoreverses = true
//        group.animations = [aniStart, aniEnd]
//
//        redLayer.add(group, forKey: nil)
        
        
    }
    
//    private var cellWidth = kScreenWidth * 0.25 - 0.5
//    private var cellHeight = kScreenWidth * 0.2 - 0.5
    
    var brand: CarBrand? {
        didSet {
            imageView.zs_setImage(urlString: (brand?.selected)! ? brand?.slogo : brand?.logo, placerHolder: nil)
            labelTitle.text = brand?.name
            labelTitle.textColor = (brand?.selected)! ? kMainColor : UIColor.colorWidthHexString(hex: "5c5c5c")
        }
    }
    
//    private lazy var path: UIBezierPath = {
//        let bezierPath = UIBezierPath()
//        bezierPath.move(to: CGPoint(x: 0, y: cellHeight * 0.5))
//        bezierPath.addLine(to: CGPoint(x: cellWidth * 0.5, y: 0))
//        bezierPath.addLine(to: CGPoint(x: cellWidth, y: cellHeight * 0.5))
//        bezierPath.addLine(to: CGPoint(x: cellWidth * 0.5, y: cellHeight))
//        bezierPath.addLine(to: CGPoint(x: 0, y: cellHeight * 0.5))
//        return bezierPath
//
//    }()
//
//    private lazy var shapeLayer: CAShapeLayer = {
//        let shape = CAShapeLayer()
//        shape.frame = CGRect(x: 0, y: 0, width: cellWidth, height: cellHeight)
//        shape.path = path.cgPath
//        shape.fillColor = UIColor.clear.cgColor
//        shape.strokeColor = UIColor.clear.cgColor
//        shape.lineWidth = 2.0
//        shape.opacity = 0.5
//
//        return shape
//    }()
//
//    private lazy var redLayer: CAShapeLayer = {
//        let redLine = CAShapeLayer()
//        redLine.frame = CGRect(x: 0, y: 0, width: cellWidth, height: cellHeight)
//        redLine.path = path.cgPath
//
//        redLine.strokeEnd = 0
//        redLine.lineWidth = 3
//        redLine.fillColor = UIColor.clear.cgColor
//        redLine.strokeColor = UIColor.red.cgColor
//        redLine.shadowColor = UIColor.red.cgColor
//        redLine.shadowRadius = 4.0
//        redLine.shadowOpacity = 1.0
//        redLine.lineCap = .round
//
//        return redLine
//    }()
    
    private lazy var imageView: UIImageView = {
        let imageIcon = UIImageView()
        imageIcon.contentMode = UIView.ContentMode.scaleAspectFit
        return imageIcon
    }()
    
    private lazy var labelTitle: UILabel = {
        let title = UILabel.init()
        title.font = UIFont.systemFont(ofSize: 12)
        title.height = 12
        title.text = "法拉利"
        title.textColor = UIColor.colorWidthHexString(hex: "5C5C5C")
        title.textAlignment = NSTextAlignment.center
        return title
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        labelTitle.frame = CGRect(x: 0, y: contentView.height - 12, width: contentView.width, height: 12)
        imageView.frame = CGRect(x: 10, y: 10, width: contentView.width - 20, height: contentView.height - 25)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
