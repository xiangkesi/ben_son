//
//  BSSearchCarView.swift
//  ben_son
//
//  Created by ZS on 2018/10/18.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BSSearchCarView: UIView {

    private let disposeBag = DisposeBag()
    

    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: UIDevice.current.contentNoTabBarHeight())
        super.init(frame: selfFrame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var tableViewCarList: UITableView = {
        let carList = UITableView.init(frame: frame, style: UITableView.Style.plain)
        carList.rowHeight = 130
        carList.register(BSSearchCarCell.self, forCellReuseIdentifier: "BSSearchCarCell")
        carList.separatorStyle = .none
        carList.backgroundColor = UIColor.black
        return carList
    }()
    
}

extension BSSearchCarView {
    
    private func setupUI() {
        backgroundColor = UIColor.black
        addSubview(tableViewCarList)
        
    }
}


class BSSearchCarCell: BSCommentCell {
    
    override func setupUI() {
        super.setupUI()
        contentView.backgroundColor = UIColor.black
        self.backgroundColor = UIColor.black
        contentView.addSubview(imageViewIcon)
        contentView.addSubview(labelCarBrand)
        contentView.addSubview(labelCarName)
//        contentView.addSubview(labelCarPrace)
        line.top = 129
        contentView.layer.addSublayer(line)
        
    }
    
    var car: CarModel? {
        didSet {
            imageViewIcon.zs_setImage(urlString: car?.cover, placerHolder: image_placholder)
            labelCarBrand.text = car?.brand_name
            labelCarName.text = car?.carName
        }
    }
    
    
    private lazy var imageViewIcon: UIImageView = {
        let image = UIImageView()
        image.origin = CGPoint(x: kSpacing, y: 20)
        image.size = CGSize(width: 120, height: 90)
        return image
    }()
    
    private lazy var labelCarBrand: UILabel = {
        let carName = UILabel()
        carName.top = imageViewIcon.top
        carName.left = imageViewIcon.right + 10
        carName.size = CGSize(width: kScreenWidth - 150, height: 20)
        carName.textColor = UIColor.colorWidthHexString(hex: "BFBFBF")
        carName.font = UIFont.systemFont(ofSize: 16)
        return carName
    }()
    
    private lazy var labelCarName: UILabel = {
        let carName = UILabel()
        carName.top = labelCarBrand.bottom + 5
        carName.left = imageViewIcon.right + 10
        carName.size = CGSize(width: kScreenWidth - 150, height: 16)
        carName.textColor = UIColor.colorWidthHexString(hex: "5C5C5C")
        carName.font = UIFont.systemFont(ofSize: 13)
        return carName
    }()
    
//    private lazy var labelCarPrace: UILabel = {
//        let carName = UILabel()
//        carName.top = labelCarName.bottom + 8
//        carName.left = imageViewIcon.right + 10
//        carName.size = CGSize(width: kScreenWidth - 150, height: 16)
//        carName.textColor = kMainColor
//        carName.font = UIFont.systemFont(ofSize: 18)
//        carName.text = "￥18000/日"
//        return carName
//    }()
}


class BSSearchCarPromatCell: BSCommentCell {
    
    override func setupUI() {
        super.setupUI()
        contentView.backgroundColor = UIColor.black
        self.backgroundColor = UIColor.black
        contentView.addSubview(imageViewIcon)
        contentView.addSubview(labelCarName)
        line.top = 49
        contentView.layer.addSublayer(line)
    }
    
    var keywords: SearchHot_keyword? {
        didSet{
            labelCarName.text = keywords?.keyword
        }
    }
    
    
    private lazy var imageViewIcon: UIImageView = {
        let image = UIImageView()
        image.origin = CGPoint(x: kSpacing, y: 17)
        image.size = CGSize(width: 16, height: 16)
        image.image = UIImage(named: "common_search")
        return image
    }()
    
    private lazy var labelCarName: UILabel = {
        let carName = UILabel()
        carName.top = imageViewIcon.top
        carName.left = imageViewIcon.right + 10
        carName.size = CGSize(width: kScreenWidth - 150, height: 16)
        carName.textColor = UIColor.colorWidthHexString(hex: "ACACAC")
        carName.font = UIFont.systemFont(ofSize: 14)
        carName.text = "劳斯莱斯"
        return carName
    }()
}
