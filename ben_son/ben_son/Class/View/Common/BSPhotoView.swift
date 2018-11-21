//
//  BSPhotoView.swift
//  ben_son
//
//  Created by ZS on 2018/9/28.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BSPhotoView: UIView {

    private let disposeBag = DisposeBag()
    
    private var complete:((_ tag: Int) -> ())?

    
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        super.init(frame: selfFrame)
        backgroundColor = UIColor.init(white: 0.1, alpha: 0.3)
        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
       dismiss()
    }
    
    private func dismiss() {
        UIView.animate(withDuration: 0.25, animations: {[weak self] in
            self?.alpha = 0
            self?.top = kScreenHeight
            }, completion: { (finish) in
                self.removeFromSuperview()
        })
    }
    
    class func showBtnView(view: UIView?,completion:@escaping (_ index: Int) -> ()) {
        if view == nil {return }
        let photoView = BSPhotoView()
        photoView.complete  =   completion
        view!.addSubview(photoView)
        UIView.animate(withDuration: 0.25) {
            photoView.viewBg.top = kScreenHeight - photoView.viewBg.height
        }
        
//        //“选择照片”按钮点击
//        photoView.btnPhoto.rx.tap
//            .flatMapLatest { [weak controller] _ in
//
//                return UIImagePickerController.rx.createWithParent(controller) { picker in
//                    picker.sourceType = .photoLibrary
//                    picker.allowsEditing = true
//                    }.flatMap { $0.rx.didFinishPickingMediaWithInfo }
//            }.map { info in
//                if let anyImahe = info["UIImagePickerControllerEditedImage"] as? UIImage {
//                    return anyImahe
//                }
//                return UIImage(named: "123.jpg")!
//            }.bind(to: view.rx.backgroundImage()).disposed(by: photoView.disposeBag)
//
//        photoView.btnCacme.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
//        //“拍照”按钮点击
//        photoView.btnCacme.rx.tap.flatMapLatest { [weak controller] _ in
//            return UIImagePickerController.rx.createWithParent(controller) { picker in
//                picker.sourceType = .camera
//                picker.allowsEditing = true
//                }.flatMap { $0.rx.didFinishPickingMediaWithInfo }
//            }.map { info in
//                if let anyImahe = info["UIImagePickerControllerEditedImage"] as? UIImage {
//                    return anyImahe
//                }
//                return UIImage(named: "123.jpg")!
//            }.bind(to: view.rx.backgroundImage()).disposed(by: photoView.disposeBag)
        
        
        photoView.btnCancel.rx.tap.subscribe(onNext: { [weak photoView] in
            photoView?.dismiss()
        }).disposed(by: photoView.disposeBag)
        
        photoView.btnPhoto.rx.tap.subscribe(onNext: { [weak photoView] in
            if photoView?.complete != nil {
                photoView?.complete!(100)
            }
            photoView?.dismiss()

        }).disposed(by: photoView.disposeBag)
        photoView.btnCacme.rx.tap.subscribe(onNext: { [weak photoView] in
            if photoView?.complete != nil {
                photoView?.complete!(200)
            }
            photoView?.dismiss()
        }).disposed(by: photoView.disposeBag)
    }
    
    
    
    
    deinit {
        BSLog("选择照片销毁了吗")
    }
    class func showImageViewView(view: UIImageView) {
        
        let photoView = BSPhotoView()
        kRootVc?.view.addSubview(photoView)
    }
    
    private lazy var viewBg: UIView = {
        let bg = UIView()
        bg.size = CGSize(width: kScreenWidth, height: UIDevice.current.isX() ? 204 : 160)
        bg.origin = CGPoint(x: 0, y: kScreenHeight)
        bg.backgroundColor = UIColor.white
        return bg
    }()
    
    private lazy var btnCacme: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.size = CGSize(width: kScreenWidth, height: 50)
        btn.setTitle("照相", for: UIControl.State.normal)
        btn.setTitle("照相", for: UIControl.State.highlighted)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(kMainColor, for: UIControl.State.normal)
        let line = creatLine(size: CGSize(width: kScreenWidth, height: 0.5))
        line.top = btn.height - line.height
        btn.layer.addSublayer(line)
        return btn
    }()
    
    private lazy var btnPhoto: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.size = CGSize(width: kScreenWidth, height: 50)
        btn.setTitle("从相册选择", for: UIControl.State.normal)
        btn.setTitle("从相册选择", for: UIControl.State.highlighted)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(kMainColor, for: UIControl.State.normal)
        btn.origin = CGPoint(x: 0, y: btnCacme.bottom)
        return btn
    }()
    
    private func creatLine(size: CGSize) -> CALayer {
        let line = CALayer.init()
        line.backgroundColor = UIColor.colorWidthHexString(hex: "DDDDDD").cgColor
        line.frameSize = size
        return line
        
    }
    
    private lazy var lineSpace: CALayer = {
        let space = CALayer.init()
        space.frameSize = CGSize(width: kScreenWidth, height: 10)
        space.backgroundColor = UIColor.colorWidthHexString(hex: "DDDDDD").cgColor
        space.origin = CGPoint(x: 0, y: btnPhoto.bottom)
        return space
    }()
    
    private lazy var btnCancel: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.size = CGSize(width: kScreenWidth, height: 50)
        btn.setTitle("取消", for: UIControl.State.normal)
        btn.setTitle("取消", for: UIControl.State.highlighted)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(UIColor.colorWidthHexString(hex: "999999"), for: UIControl.State.normal)
        btn.setTitleColor(UIColor.colorWidthHexString(hex: "999999"), for: UIControl.State.highlighted)
        btn.origin = CGPoint(x: 0, y: lineSpace.bottom)
        return btn
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BSPhotoView {
    
    private func setupUI() {
        addSubview(viewBg)
        viewBg.addSubview(btnCacme)
        viewBg.addSubview(btnPhoto)
        viewBg.layer.addSublayer(lineSpace)
        viewBg.addSubview(btnCancel)
    }
}
