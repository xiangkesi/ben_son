//
//  BSSkipVc.swift
//  ben_son
//
//  Created by ZS on 2018/11/12.
//  Copyright © 2018 ZS. All rights reserved.
//

import UIKit

class BSSkipVc {

    
    class func skipToVc(userInfo: [AnyHashable : Any], isBackground: Bool) {
   
        guard let tabBar = kRootVc as? BSTabBarController, let nav = tabBar.viewControllers?.first as? BSNavgationController else {
            return
        }
        
        var titleStr: String = "有新的推送,是否查看"
        
        if let apsDic = userInfo[AnyHashable("aps")] as? [String: Any], let alertDic = apsDic["alert"]  as? [String: Any], let title = alertDic["title"] as? String {
            titleStr = title
        }
        // 1新闻 2车型 3系统消息
        if let msgType = userInfo[AnyHashable("notifiable_type")],
            let msgId = userInfo[AnyHashable("notifiable_id")],
            let notifion_id = (msgId as AnyObject).int64Value,
            let notifion_type = (msgType as AnyObject).int64Value{
            switch notifion_type
            {
            case 1:
                if !isBackground {
                    BSPromatView.show_prompt(Prompt_type.prompt_type_all, titleStr) {[weak nav] (type) in
                        let webVc = RSCommonWebController()
                        webVc.requestUrl = news_detail_url + String(notifion_id)
                        nav?.pushViewController(webVc, animated: true)
                    }
                }else{
                    let webVc = RSCommonWebController()
                    webVc.requestUrl = news_detail_url + String(notifion_id)
                    nav.pushViewController(webVc, animated: true)
                }
                break
            case 2:
                if !isBackground {
                    BSPromatView.show_prompt(Prompt_type.prompt_type_all, titleStr) {[weak nav] (type) in
                        let carDetailVc = BSCarDetailController()
                        carDetailVc.car_id = Int(notifion_id)
                        nav?.pushViewController(carDetailVc, animated: true)
                    }
                }else{
                    let carDetailVc = BSCarDetailController()
                    carDetailVc.car_id = Int(notifion_id)
                    nav.pushViewController(carDetailVc, animated: true)
                }
                break
            case 3:
                if !isBackground {
                    BSPromatView.show_prompt(Prompt_type.prompt_type_all, titleStr) {[weak nav] (type) in
                        let detail = BSSysterMsgDetailcontroller()
                        detail.msg_id = Int(notifion_id)
                        nav?.pushViewController(detail, animated: true)
                    }
                }else {
                    let detail = BSSysterMsgDetailcontroller()
                    detail.msg_id = Int(notifion_id)
                    nav.pushViewController(detail, animated: true)
                }
                break
            default:
                break
            }
            
            
        }
    }
}
