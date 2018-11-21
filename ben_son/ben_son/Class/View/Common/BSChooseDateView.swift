//
//  BSChooseDateView.swift
//  ben_son
//
//  Created by ZS on 2018/9/26.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BSChooseDateView: UIView {

    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        super.init(frame: selfFrame)
        setupUI()
    }
    
    class func show(showView: UIView, complete:@escaping ((_ year: String) -> ())) {
        
        let dateView = BSChooseDateView()
        showView.addSubview(dateView)
        
        dateView.datePicker.rx.date.map { [weak dateView] in
            dateView!.dateFormatter.string(from: $0)
            }.subscribe(onNext: { (dateString) in
                complete(dateString)
            }).disposed(by: dateView.disposeBag)
        
//        if showView.isKind(of: UILabel.self) {
//            let label = showView as! UILabel
//            dateView.datePicker.rx.date.map { [weak dateView] in
//                dateView!.dateFormatter.string(from: $0)
//                }.subscribe(onNext: { (dateString) in
//                 label.text = dateString
//                    complete(dateString)
//                }).disposed(by: dateView.disposeBag)
//        }else if showView.isKind(of: UIButton.self) {
//            let btn = showView as! UIButton
//            btn.isSelected = true
//            dateView.datePicker.rx.date.map { [weak dateView] in
//               dateView!.dateFormatter.string(from: $0)
//                }.subscribe(onNext: { (dateString) in
//                    btn.setTitle(dateString, for: UIControl.State.selected)
//                    complete(dateString)
//
//                }).disposed(by: dateView.disposeBag)
//        }
        
        UIView.animate(withDuration: 0.25) {[weak dateView] in
            dateView?.datePickerBg.top = (dateView?.height)! - (dateView?.datePickerBg.height)!
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.25, animations: {
            self.datePickerBg.top = kScreenHeight
        }) { (finish) in
            self.removeFromSuperview()
        }
    }
    
    deinit {
        BSLog("BSChooseDateView销毁了")
    }
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker.init()
        picker.origin = CGPoint(x: 0, y: 0)
        picker.size = CGSize(width: kScreenWidth, height: 200)
        picker.locale = Locale.init(identifier: "zh_Hans_CN")
        picker.calendar = Calendar.current
        picker.datePickerMode = UIDatePicker.Mode.date
        picker.maximumDate = Date()
        return picker
    }()
    
    private lazy var datePickerBg: UIView = {
        let bg = UIView()
        bg.size = CGSize(width: kScreenWidth, height: UIDevice.current.isX() ? 244 : 200)
        bg.origin = CGPoint(x: 0, y: height)
        bg.backgroundColor = UIColor.white
        return bg
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BSChooseDateView {
    
    private func setupUI() {
        backgroundColor = UIColor.init(white: 0.2, alpha: 0.3)
        addSubview(datePickerBg)
        datePickerBg.addSubview(datePicker)
    }
}
