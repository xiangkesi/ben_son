//
//  BSCommentCell.swift
//  ben_son
//
//  Created by ZS on 2018/9/6.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit

class BSCommentCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        setupUI()
    }
    
    func setupUI() {
        contentView.backgroundColor = UIColor.black
        selectionStyle = UITableViewCell.SelectionStyle.none
    }
    
    lazy var line: CALayer = {
        let lineLayer = CALayer.init()
        lineLayer.backgroundColor = UIColor.colorWidthHexString(hex: "322A21").cgColor
        lineLayer.width = kContentWidth
        lineLayer.height = 0.5
        lineLayer.left = kSpacing
        return lineLayer
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class BSCommonCollectionCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setupUI()
    }
    
    func setupUI() {
        contentView.backgroundColor = UIColor.black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
