//
//  BSMsgCenterCell.swift
//  ben_son
//
//  Created by ZS on 2018/10/17.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit

class BSMsgCenterCell: BSCommentCell {

    override func setupUI() {
        super.setupUI()
        
        contentView.backgroundColor = UIColor.black
        contentView.addSubview(imageIcon)
        contentView.addSubview(labelName)
        contentView.addSubview(labelDesc)
        line.top = 87
        contentView.layer.addSublayer(line)
    }
    
    var list: BSMsgCenterList? {
        didSet {
            viewHotRed.isHidden = list?.is_read == 0 ? false : true
            labelName.text = list?.title
            labelDesc.text = list?.content
        }
    }
    

    private lazy var imageIcon: UIImageView = {
        let icon = UIImageView()
        icon.size = CGSize(width: 44, height: 44)
        icon.origin = CGPoint(x: kSpacing, y: 22)
        icon.image = UIImage(named: "chuan_text")
        icon.addSubview(viewHotRed)
        return icon
    }()
    
    private lazy var viewHotRed: UIView = {
        let redView = UIView()
        redView.size = CGSize(width: 10, height: 10)
        redView.origin = CGPoint(x: 34, y: 0)
        redView.backgroundColor = UIColor.red
        redView.zs_corner()
        return redView
    }()
    
    private lazy var labelName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.colorWidthHexString(hex: "BFBFBF")
        label.text = "给我一首歌的时间"
        label.left = imageIcon.right + 10
        label.top = imageIcon.top
        label.size = CGSize(width: kScreenWidth - 155, height: 22)
        return label
    }()
    
    private lazy var labelDesc: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.colorWidthHexString(hex: "5C5C5C")
        label.size = CGSize(width: kScreenWidth - 100, height: 16)

        label.left = imageIcon.right + 10
        label.top = imageIcon.bottom - 16
        return label
    }()
}
