//
//  BSInputViewController.swift
//  ben_son
//
//  Created by ZS on 2018/9/26.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding

class BSInputViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.colorWidthHexString(hex: "141414")
        view.addSubview(scrollViewMain)
    }

    
    lazy var scrollViewMain: TPKeyboardAvoidingScrollView = {
        let mainScroller = TPKeyboardAvoidingScrollView()
        mainScroller.origin = CGPoint(x: 0, y: 0)
        mainScroller.size = CGSize(width: kScreenWidth, height: UIDevice.current.contentNoTabBarHeight())
        mainScroller.alwaysBounceVertical = true
        return mainScroller
    }()
    
    deinit {
        print("\(self.classForCoder)销毁了")
    }
}
