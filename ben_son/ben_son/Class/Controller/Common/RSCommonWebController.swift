//
//  RSCommonController.swift
//  gokarting
//
//  Created by ZS on 2018/5/22.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import WebKit

class RSCommonWebController: UIViewController {
    
    var urlString: URL?
    
    
    var isShouldShare: Bool = false
    
    
    var requestUrl: String? {
        didSet{
            let fuck = requestUrl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            urlString = URL.init(string: fuck!)
        }
    }
    
//    http://192.168.0.116/raykart/view/weather.html
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if urlString == nil {
            return
        }
        let request = URLRequest.init(url: urlString! as URL)
        webView.load(request)
    }
    
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "title")
        clearWebCache()
    }
    
    private func clearWebCache() {
        let websiteDataTypes = NSSet.init(array: [WKWebsiteDataTypeDiskCache,WKWebsiteDataTypeMemoryCache])
        let dateFrom = NSDate.init(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: dateFrom as Date) {
            BSLog("清楚成功")
        }
        
        
    }
    
    @objc func actionShare() {
        
        let share = ShareModel()
        share.title = "本森超跑"
        share.desc = "给我一首歌的时间"
        share.webUrl = requestUrl
        
        RSUmenManager.share(platformtype: PlatformType.wechatType, sharemodel: share, shareType: ShareType.shareWeb)
    }
    
    
    private lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences = WKPreferences()
        webConfiguration.userContentController = WKUserContentController()
        webConfiguration.allowsInlineMediaPlayback = true;
//        webConfiguration.mediaPlaybackRequiresUserAction = false;
        let web = WKWebView(frame: view.frame, configuration: webConfiguration)
        web.height = UIDevice.current.contentNoTabBarHeight()
        //取消自动缩进
        if #available(iOS 11.0, *) {
            web.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        web.uiDelegate = self
        web.navigationDelegate = self
        web.isOpaque = false
        web.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        web.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        return web
    }()
    
    private lazy var progress: UIProgressView = {
        let progres = UIProgressView.init(progressViewStyle: .default)
        progres.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 30)
        progres.progress = 0
        progres.progressTintColor = UIColor.red
        progres.trackTintColor = UIColor.clear
        return progres
    }()
}

extension RSCommonWebController: WKNavigationDelegate,WKUIDelegate{
    private func setupUI() {
        view.backgroundColor = UIColor.black
        
        if isShouldShare {
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "icon_share_normal"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(actionShare))
        }
        
        view.addSubview(webView)
        webView.addSubview(progress)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progress.alpha = 1.0
            let animal = webView.estimatedProgress > Double(progress.progress)
            progress.setProgress(Float(webView.estimatedProgress), animated: animal)
            
            if webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
                    self.progress.alpha = 0
                }) { (finished) in
                    self.progress.setProgress(0, animated: false)
                }
            }
        }else if keyPath == "title"{
            title = change?[NSKeyValueChangeKey.newKey] as? String
        }
    }
    
    //MARK: -WKNavigationDelegate
    ///开始加载调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progress.isHidden = false
    }
    ///加载完成调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    ///加载完成调用
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        progress.isHidden = true
        progress.progress = 0
    }
    
    /// 1 在发送请求之前，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        if navigationAction.request.url?.absoluteString == "" {
            decisionHandler(.cancel)
        }

        if navigationAction.targetFrame == nil{
            webView.load(navigationAction.request)
        }
        decisionHandler(.allow)
    }
//
//    /// 3 在收到服务器的响应头，根据response相关信息，决定是否跳转。decisionHandler必须调用，来决定是否跳转，参数WKNavigationActionPolicyCancel取消跳转，WKNavigationActionPolicyAllow允许跳转
//    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//
//    }
//
}
