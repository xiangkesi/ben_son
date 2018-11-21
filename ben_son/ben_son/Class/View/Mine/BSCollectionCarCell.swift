//
//  BSCollectionCarCell.swift
//  ben_son
//
//  Created by ZS on 2018/9/20.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift
class BSCollectionCarCell: BSCommentCell {

    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
         disposeBag = DisposeBag()
    }
    override func setupUI() {
        super.setupUI()
        contentView.backgroundColor = kMainBackBgColor
        contentView.addSubview(imageIcon)
        contentView.addSubview(labelCarName)
        contentView.addSubview(labelBrand)
        contentView.addSubview(labelPrace)
        contentView.addSubview(buttonDelete)
        contentView.layer.addSublayer(lineBottom)
    }
    var car: CarModel? {
        didSet{
            imageIcon.zs_setImage(urlString: car?.cover, placerHolder: image_placholder)
            labelCarName.text = car?.brand?.brand
            labelBrand.text = car?.carName
            labelPrace.text = ("¥" + (car?.prace ?? ""))
        }
    }
    
    private lazy var lineBottom: CALayer = {
        let line = CALayer.init()
        line.left = kSpacing
        line.width = kContentWidth
        line.height = 0.5
        line.top = kScreenWidth * 0.35 - 0.5
        line.backgroundColor = UIColor.colorWidthHexString(hex: "322A21").cgColor
        
        return line
    }()
    
    private lazy var imageIcon: UIImageView = {
        let icon = UIImageView()
        icon.size = CGSize(width: (kScreenWidth * 0.35 - 40) * 1.6, height: kScreenWidth * 0.35 - 40)
        icon.left = kSpacing
        icon.top = 20
        return icon
    }()
    
    private lazy var labelCarName: UILabel = {
        let desc = UILabel.init()
        desc.textColor = UIColor.colorWidthHexString(hex: "BFBFBF")
        desc.font = UIFont.systemFont(ofSize: 16)
        desc.size = CGSize(width: 100, height: 18)
        desc.origin = CGPoint(x: imageIcon.right + 15, y: imageIcon.top)
        desc.backgroundColor = kMainBackBgColor
        desc.layer.masksToBounds = true
        return desc
    }()
    
    private lazy var labelBrand: UILabel = {
        let desc = UILabel.init()
        desc.textColor = UIColor.colorWidthHexString(hex: "5C5C5C")
        desc.font = UIFont.systemFont(ofSize: 13)
        desc.size = CGSize(width: kScreenWidth - imageIcon.right - 15, height: 16)
        desc.origin = CGPoint(x: labelCarName.left, y: labelCarName.bottom + 4)
        desc.backgroundColor = kMainBackBgColor
        desc.layer.masksToBounds = true
        return desc
    }()
    
    private lazy var labelPrace: UILabel = {
        let desc = UILabel.init()
        desc.textColor = kMainColor
        desc.font = UIFont.systemFont(ofSize: 18)
        desc.size = CGSize(width: 150, height: 20)
        desc.origin = CGPoint(x: labelBrand.left, y: labelBrand.bottom + 8)
        desc.backgroundColor = kMainBackBgColor
        desc.layer.masksToBounds = true
        return desc
    }()
    
    lazy var buttonDelete: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.size = CGSize(width: 32, height: 20)
        btn.origin = CGPoint(x: kScreenWidth - 47, y: 20)
        btn.setImage(UIImage(named: "btn_close_normal"), for: UIControl.State.normal)
        btn.setImage(UIImage(named: "btn_close_normal"), for: UIControl.State.highlighted)
        return btn
    }()
    

}
