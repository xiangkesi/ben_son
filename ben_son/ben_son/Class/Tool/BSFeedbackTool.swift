//
//  BSFeedbackTool.swift
//  ben_son
//
//  Created by ZS on 2018/10/23.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class BSFeedbackTool {

    static let manager = BSFeedbackTool()
    
    private var impactLight: UIImpactFeedbackGenerator?
    
    init() {
            let light = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.medium)
            impactLight = light
            light.prepare()
    }
    
    func play() {
        impactLight?.impactOccurred()
    }
}
