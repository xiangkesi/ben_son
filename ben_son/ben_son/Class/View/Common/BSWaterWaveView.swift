//
//  BSWaterWaveView.swift
//  ben_son
//
//  Created by ZS on 2018/11/14.
//  Copyright © 2018 ZS. All rights reserved.
//

import UIKit

class BSWaterWaveView: UIView {
    
    private lazy var waveDisplaylink = CADisplayLink()
    
    private lazy var firstWaveLayer = CAShapeLayer()
    private lazy var secondWaveLayer = CAShapeLayer()
    
    private lazy var imageView = UIImageView()
    
    /// 基础描述 正弦函数
    ///   y=Asin(ωx+φ）+ b
    ///   A : wavaA
    ///   w : 1/waveW
    ///   φ : offsetφ
    ///   b : b
    
    private var waveA: CGFloat = 5
    private var waveW: CGFloat = 2 * CGFloat(Double.pi) / kScreenWidth
    private var offsetX: CGFloat = 0
    private var b: CGFloat = 0
    
    private var waveSpeed: CGFloat = 0.05

    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 12)
        
        super.init(frame: selfFrame)
        setupUI()
    }
    
    @objc func getCurrentWave() {
        offsetX += waveSpeed
        setCurrentStatusWavePath()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        waveDisplaylink.invalidate()
    }
    
    
}

extension BSWaterWaveView {
    
    private func setupUI() {
        firstWaveLayer.fillColor = UIColor.clear.cgColor
        secondWaveLayer.fillColor = UIColor.colorWidthHexString(hex: "141414").cgColor
        layer.addSublayer(firstWaveLayer)
        layer.addSublayer(secondWaveLayer)
        waveDisplaylink = CADisplayLink(target: self, selector: #selector(getCurrentWave))
        waveDisplaylink.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
        imageView.frame = CGRect(x: 20, y: -20, width: 30, height: 22.5)
//        imageView.backgroundColor = UIColor.red
        imageView.image = UIImage(named: "chuan_text")
        addSubview(imageView)
    }
    
    private func setCurrentStatusWavePath() {
        
        let firstPath = CGMutablePath()
        var firstY = width * 0.5
        firstPath.move(to: CGPoint(x: 0, y: firstY))
        
        for index in 0...Int(width) {
            firstY = waveA * sin(waveW * CGFloat(index) + offsetX) + b
            firstPath.addLine(to: CGPoint(x: CGFloat(index), y: firstY))
        }
        
        firstPath.addLine(to: CGPoint(x: width, y: height))

        firstPath.addLine(to: CGPoint(x: 0, y: height))
        firstPath.closeSubpath()
        firstWaveLayer.path = firstPath
        
        let secondPath = CGMutablePath()
        var secondY = width * 0.5
        secondPath.move(to: CGPoint(x: 0, y: secondY))
        
        for jndex in 0...Int(width) {
            secondY = waveA * sin(waveW * CGFloat(jndex) + offsetX - width * 0.5) + b
            secondPath.addLine(to: CGPoint(x: CGFloat(jndex), y: secondY))
            if jndex == 35 {
                imageView.top = secondY - 20
            }
        }
        secondPath.addLine(to: CGPoint(x: width, y: height))
        secondPath.addLine(to: CGPoint(x: 0, y: height))
        secondPath.closeSubpath()
        secondWaveLayer.path = secondPath
    }
    
  
}
