//
//  BSVideoManager.swift
//  ben_son
//
//  Created by ZS on 2018/11/20.
//  Copyright © 2018 ZS. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class BSVideoManager {

    
    private var player: AVPlayer?
    
    init(urlString: String, fatherView: UIView) {
        
        let playurl = URL.init(string: urlString)
        
        let urlAsset = AVURLAsset.init(url: playurl!)
        let playerItem = AVPlayerItem.init(asset: urlAsset)
        player = AVPlayer.init(playerItem: playerItem)
        
        let playerLayer = AVPlayerLayer.init(player: player)
        playerLayer.frame = fatherView.frame
        playerLayer.videoGravity = .resizeAspectFill
        fatherView.layer.addSublayer(playerLayer)
        
        player?.play()
    }
    
    

}
