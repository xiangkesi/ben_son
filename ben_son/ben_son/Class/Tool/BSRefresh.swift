//
//  BSRefresh.swift
//  ben_son
//
//  Created by ZS on 2018/9/6.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import MJRefresh
import AudioToolbox

enum BSRefreshStatus: Int {
    case InvalidData // 无效的数据
    case DropDownSuccess // 下拉成功
    case PullSuccessHasMoreData // 上拉，还有更多数据
    case PullSuccessNoMoreData // 上拉，没有更多数据
    case PullOther
}

extension UIScrollView {
    var zHead: MJRefreshHeader {
        get {
            return mj_header
        }
        set {
            mj_header = newValue
        }
    }
    
    var zFoot: MJRefreshFooter {
        get {
            return mj_footer
        }
        
        set {
            mj_footer = newValue
        }
    }
    
    func refreshStatus(status: BSRefreshStatus) {
        switch status {
        case .InvalidData:
            if mj_header != nil && mj_header.isRefreshing {
                zHead.endRefreshing()
            }
            if mj_footer != nil && mj_footer.isRefreshing {
                zFoot.endRefreshing()
            }
            return
            
        case .DropDownSuccess:
            if mj_header != nil && mj_header.isRefreshing {
                
                if mj_footer != nil && mj_footer.isHidden {
                    mj_footer.isHidden = false
                }
                if mj_footer != nil && mj_footer.state == .noMoreData {
                    zFoot.resetNoMoreData()
                }
                zHead.endRefreshing()
            }
        case .PullSuccessHasMoreData:
            if mj_footer != nil && mj_footer.isRefreshing {
                zFoot.endRefreshing()
            }
        case .PullSuccessNoMoreData:
            if mj_footer != nil && mj_footer.isRefreshing {
                zFoot.endRefreshingWithNoMoreData()
            }
        default:
            break
        }
    }
}

class BSRefreshHeader: MJRefreshGifHeader {
    override func prepare() {
        super.prepare()
        setImages([UIImage(named: "pullToRefresh_0_80x60_")!], for: .idle)
        setImages([UIImage(named: "pullToRefresh_0_80x60_")!], for: .pulling)
        setImages([UIImage(named: "pullToRefresh_0_80x60_")!,
                   UIImage(named: "pullToRefresh_1_80x60_")!,
                   UIImage(named: "pullToRefresh_2_80x60_")!,
                   UIImage(named: "pullToRefresh_3_80x60_")!,
                   UIImage(named: "pullToRefresh_4_80x60_")!,
                   UIImage(named: "pullToRefresh_5_80x60_")!,
                   UIImage(named: "pullToRefresh_6_80x60_")!,
                   UIImage(named: "pullToRefresh_7_80x60_")!,
                   UIImage(named: "pullToRefresh_8_80x60_")!,
                   UIImage(named: "pullToRefresh_9_80x60_")!], for: .refreshing)
        
        lastUpdatedTimeLabel.isHidden = true
        stateLabel.isHidden = true
        
    
    }
    
    override var state: MJRefreshState {
        didSet{
            if state == .pulling {
                playSound()
            }
        }
    }
    
    func playSound() {
        if #available(iOS 10.0, *) {
            BSFeedbackTool.manager.play()
        }
    }
}

class BSRefreshFooter: MJRefreshAutoNormalFooter {
    
    override func prepare() {
        super.prepare()
        stateLabel.textColor = UIColor.colorWidthHexString(hex: "ffffff")
        stateLabel.font = UIFont.systemFont(ofSize: 12)
        setTitle("本森租车-期待您的加入", for: .noMoreData)
        setTitle("上拉加载更多", for: .idle)
        setTitle("正在加载", for: .refreshing)
        isHidden = true
    }
}
