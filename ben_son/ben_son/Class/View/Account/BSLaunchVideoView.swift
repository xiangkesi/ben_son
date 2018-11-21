//
//  BSLaunchVideoView.swift
//  ben_son
//
//  Created by ZS on 2018/11/12.
//  Copyright © 2018 ZS. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import RxSwift
import LTMorphingLabel

class BSLaunchVideoView: UIView {

    private var player: AVPlayer?
    
    private let disposeBag = DisposeBag()
    
    private var isPlaying: Bool = true


    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        super.init(frame: selfFrame)
        
        setupUI()
    }
    
    class func showLaunchVideoView() {
        if let view = kRootVc?.view {
            let launchView = BSLaunchVideoView()
            view.addSubview(launchView)
            
            UIView.animate(withDuration: 1.0, animations: {
                launchView.imageLogoView.top = 100
            }) { (finish) in
                launchView.labelTitle.text = "BENSON"
                let effect = LTMorphingEffect(rawValue: 5)
                launchView.labelTitle.morphingEffect = effect!
                
                launchView.labelTitleSecond.text = "BENSON超跑 - 期待您的加入"
                let effectSecond = LTMorphingEffect(rawValue: 4)
                launchView.labelTitleSecond.morphingEffect = effectSecond!

            }
            
        }
    }
    
    private func dismissVideoView()  {
        if isPlaying == true {player?.pause()}
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0.1
        }) { (finish) in
            self.removeFromSuperview()
        }
    }
    
    private lazy var btnClose: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.size = CGSize(width: 60, height: 25)
        btn.backgroundColor = kMainColor
        btn.origin = CGPoint(x: width - 80, y: UIDevice.current.isX() ? 50 : 30)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.zs_corner()
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn.setTitle("10 跳过", for: UIControl.State.normal)
        return btn
    }()
    
    private lazy var imageLogoView: UIImageView = {
        let logo = UIImageView()
        logo.size = CGSize(width: 80, height: 80)
        logo.origin = CGPoint(x: (width - 80) * 0.5, y: height)
        logo.image = UIImage(named: "common_logio")
        logo.zs_cutCorner(sizeHeigt: CGSize(width: 10, height: 10))
        return logo
    }()
    
    private lazy var labelTitle: LTMorphingLabel = {
        let label = LTMorphingLabel()
        label.frame = CGRect(x: 20, y: 180, width: kScreenWidth - 40, height: 30)
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = kMainColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.morphingDuration = 1
        return label
    }()
    
    private lazy var labelTitleSecond: LTMorphingLabel = {
        let label = LTMorphingLabel()
        label.frame = CGRect(x: 20, y: height - 60, width: kScreenWidth - 40, height: 40)
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = kMainColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.morphingDuration = 1
        return label
    }()
    
    deinit {
        player = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BSLaunchVideoView {
    
    private func setupUI() {
        backgroundColor = UIColor.black
        let stringVideoPath = Bundle.main.path(forResource: "register_guide_video", ofType: "mp4")
        if (stringVideoPath?.isEmpty)! {
            return
        }
        let playUrl = URL.init(fileURLWithPath: stringVideoPath!)
        let urlAsset = AVURLAsset.init(url: playUrl)
        let playerItem = AVPlayerItem.init(asset: urlAsset)
        player = AVPlayer.init(playerItem: playerItem)
    
        let playerLayer = AVPlayerLayer.init(player: player)
        playerLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
        addSubview(btnClose)
        addSubview(imageLogoView)
        addSubview(labelTitle)
        addSubview(labelTitleSecond)
        player?.play()
        
    NotificationCenter.default.rx.notification(Notification.Name.AVPlayerItemDidPlayToEndTime).takeUntil(self.rx.deallocated).subscribe(onNext: {[weak self] (notion) in
            if let p = notion.object as? AVPlayerItem {
                    p.seek(to: CMTime.zero)
                    self?.dismissVideoView()
            }
        }).disposed(by: disposeBag)
        
    NotificationCenter.default.rx.notification(UIApplication.willResignActiveNotification).takeUntil(self.rx.deallocated).subscribe(onNext: {[weak self] (notion) in
        if (self?.isPlaying)! {
            self?.isPlaying = false
            self?.player?.pause()
        }
//                BSLog("willResignActiveNotification")
        }).disposed(by: disposeBag)
        
    NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification).takeUntil(self.rx.deallocated).subscribe(onNext: {[weak self] (notion) in
//            BSLog("dBecomeActiveNotification")
        if !(self?.isPlaying)! {
            self?.isPlaying = true
            self?.player?.play()
        }
        
        }).disposed(by: disposeBag)
        
        btnClose.rx.tap.subscribe(onNext: {[weak self] in
            self?.dismissVideoView()
        }).disposed(by: disposeBag)
        
        Observable<TimeInterval>.timer(duration: 10, interval: 1).map({ (a) -> String in
            let time = Int(a)
            return String(time) + " " + "跳过"
        }).subscribe(onNext: {[weak self] (timeStr) in
            self?.btnClose.setTitle(timeStr, for: UIControl.State.normal)
        }, onCompleted: {[weak self] in
            self?.dismissVideoView()
        }).disposed(by: disposeBag)
        

        
    }
}
