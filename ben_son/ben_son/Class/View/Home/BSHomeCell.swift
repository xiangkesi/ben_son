//
//  BSHomeCell.swift
//  ben_son
//
//  Created by ZS on 2018/9/11.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit

class BSHomeCell: BSCommentCell {

    override func setupUI() {
        super.setupUI()
        contentView.addSubview(imagePhoto)
        contentView.addSubview(labelTitle)
    }
    
    
    private lazy var imagePhoto: UIImageView = {
        let photo = UIImageView()
        photo.origin = CGPoint(x: 0, y: 0)
        photo.size = CGSize(width: kScreenWidth, height: kScreenWidth * 0.6)
        return photo
    }()
    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.size = CGSize(width: kScreenWidth - 40, height: 30)
        label.origin = CGPoint(x: 20, y: imagePhoto.height - 30)
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    var news: BSNews? {
        didSet {
            imagePhoto.zs_setImage(urlString: news?.newsHead, placerHolder: image_placholder)
            labelTitle.text = news?.newsTitle
        }
    }

}
