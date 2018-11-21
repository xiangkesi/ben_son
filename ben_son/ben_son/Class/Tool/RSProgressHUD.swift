//
//  RSProgressHUd.swift
//  gokarting
//
//  Created by ZS on 2018/4/30.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import MBProgressHUD


class RSProgressHUD : NSObject{
    
    //MARK: MBProgressHUD
    //FIXME: 注意当控制器销毁的时候,如果有网络请求最好取消掉当前网络请求,一定不要传个nil进来加载,不然会崩溃的
    
    /// 显示在VIew上一个view只能显示一个
    /// - Parameters:
    ///   - view: 传入的view不传默认windowes  显示在view的地方 self.navigationController.view这个是kKeyWindow
    ///   - titleStr: 提示文字,不传默认空字符串
    @objc  class func showWindowesLoading(view: UIView? = UIApplication.shared.keyWindow,titleStr: String = ""){
        guard let _ = view else {
            return
        }
        let hud = MBProgressHUD.showAdded(to: view!, animated: true)
        hud.label.text = titleStr
        hud.label.font = UIFont.systemFont(ofSize: 15.0)
        hud.margin = 10.0
        
    }
    
    
    /// 成功或者失败的提示
    ///
    /// - Parameters:
    ///   - view: 要显示的view
    ///   - titleStr: 文字
    @objc class func showSuccessOrFailureHud(titleStr:String = "成功",_ view: UIView = UIApplication.shared.keyWindow!){
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .text
        hud.label.text = titleStr
        hud.hide(animated: true, afterDelay: 2.0)
        
    }
    
    
    
    
    /// 带显示进度的
    ///
    /// - Parameters:
    ///   - view: 要显示的地方
    ///   - titleStr: 要显示的文字
    @objc class func showViewProgressHUD(view: UIView = UIApplication.shared.keyWindow!, titleStr: String = ""){
        let hud  = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = titleStr
        hud.mode = .determinate
    }
    
    
    /// 进度
    ///
    /// - Parameters:
    ///   - view: 和上面的view一定要一样
    ///   - progress: 进度
    @objc class func doSomeWorkWithHUD(view: UIView, progress: Float){
        DispatchQueue.main.async {
            MBProgressHUD.init(for: view)?.progress = progress
        }
    }
    
    /// 隐藏当前的提示
    ///
    /// - Parameter view: 当前View
    @objc class func hideHUDQueryHUD(view: UIView = UIApplication.shared.keyWindow!){
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    
}
