//
//  RSCarListCell.swift
//  ben_son
//
//  Created by ZS on 2018/9/6.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit

class RSCarListCell: BSCommentCell {

    override func setupUI() {
        super.setupUI()
        contentView.backgroundColor = kMainBackBgColor
        contentView.addSubview(imagePhoto)
        contentView.addSubview(lbaelCarBrand)
        contentView.addSubview(lbaelCarModel)
        contentView.addSubview(lbaelPrace)
    }
    
    var model: CarModel? {
        didSet{
            imagePhoto.zs_setImage(urlString: model?.cover, placerHolder: image_placholder)
            lbaelCarBrand.text = model?.brand_name
            lbaelCarModel.text = model?.carName
            lbaelPrace.text = "¥" + (model?.prace ?? "10000") + "/日"
        }
    }
    
    
    private lazy var imagePhoto: UIImageView = {
        let photo = UIImageView()
        photo.origin = CGPoint(x: kSpacing, y: 0)
        photo.size = CGSize(width: kContentWidth, height: kScreenWidth * 0.7 - 74)
        photo.contentMode = UIView.ContentMode.scaleAspectFill
        photo.clipsToBounds = true
        return photo
    }()
    
    private lazy var lbaelCarBrand: UILabel = {
        let carBrand = UILabel.init()
        carBrand.left = kSpacing
        carBrand.top = imagePhoto.bottom + 10
        carBrand.size = CGSize(width: 200, height: 20)
        carBrand.font = UIFont.systemFont(ofSize: 16)
        carBrand.textColor = UIColor.colorWidthHexString(hex: "BFBFBF")
        return carBrand
    }()
    
    private lazy var lbaelCarModel: UILabel = {
        let carBrand = UILabel.init()
        carBrand.left = kSpacing
        carBrand.top = lbaelCarBrand.bottom + 5
        carBrand.size = CGSize(width: 150, height: 16)
        carBrand.font = UIFont.systemFont(ofSize: 13)
        carBrand.textColor = UIColor.colorWidthHexString(hex: "5C5C5C")
        return carBrand
    }()
    
    private lazy var lbaelPrace: UILabel = {
        let prace = UILabel.init()
        prace.left = kScreenWidth - 135
        prace.top = lbaelCarBrand.top
        prace.size = CGSize(width: 120, height: 20)
        prace.font = UIFont.systemFont(ofSize: 18)
        prace.textColor = kMainColor
        prace.textAlignment = NSTextAlignment.right
        return prace
    }()
}

