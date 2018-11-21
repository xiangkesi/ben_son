//
//  BSNewsCell.swift
//  ben_son
//
//  Created by ZS on 2018/9/20.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit

class BSNewsCell: BSCommentCell {

    override func setupUI() {
        super.setupUI()
        contentView.backgroundColor = kMainBackBgColor
        contentView.addSubview(imagePhoto)
        contentView.addSubview(labelNewsTitle)
        contentView.layer.addSublayer(lineBottom)
    }

    var news: BSNews? {
        didSet{
            imagePhoto.zs_setImage(urlString: news?.newsPhoto, placerHolder: image_placholder)
            labelNewsTitle.text = news?.newsTitles
        }
    }
    private lazy var labelNewsTitle: UILabel = {
        let newTitle = UILabel()
        newTitle.font = UIFont.systemFont(ofSize: 15)
        newTitle.left = 15
        newTitle.width = kScreenWidth - 30
        newTitle.height = 22
        newTitle.top = imagePhoto.bottom + 15
        newTitle.backgroundColor = kMainBackBgColor
        newTitle.layer.masksToBounds = true
        newTitle.textColor = UIColor.white
        return newTitle
    }()
    private lazy var imagePhoto: UIImageView = {
        let photoView = UIImageView()
        photoView.contentMode = .scaleAspectFill
        photoView.layer.masksToBounds = true
        photoView.origin = CGPoint(x: 15, y: 0)
        photoView.size = CGSize(width: kScreenWidth - 30, height: kScreenWidth * 0.6 - 50)
        return photoView
    }()
    private lazy var lineBottom: CALayer = {
        let line = CALayer()
        line.left = 15
        line.top = kScreenWidth * 0.6 + 19
        line.frameSize = CGSize(width: kScreenWidth - 30, height: 1)
        line.backgroundColor = UIColor.colorWidthHexString(hex: "322A21").cgColor
        return line
    }()
}
