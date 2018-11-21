//
//  BSAgreementController.swift
//  ben_son
//
//  Created by ZS on 2018/9/25.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

class BSAgreementController: UIViewController {

    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       setupUI()
        
        if let htmlString = Bundle.main.url(forResource: "service_terms.html", withExtension: nil) {
            webView.load(URLRequest.init(url: htmlString))
        }
    }
    
    private lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences = WKPreferences()
        webConfiguration.userContentController = WKUserContentController()
        webConfiguration.allowsInlineMediaPlayback = true;
        //        webConfiguration.mediaPlaybackRequiresUserAction = false;
        let web = WKWebView(frame: view.frame, configuration: webConfiguration)
        web.height = UIDevice.current.contentNoTabBarHeight()
        web.top = UIDevice.current.navigationBarHeight()
        web.backgroundColor = UIColor.white
        web.layer.masksToBounds = true
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
        progres.progressTintColor = kMainColor
        progres.trackTintColor = UIColor.clear
        return progres
    }()
    
    private lazy var viewNav: UIView = {
        let nav = UIView()
        nav.origin = CGPoint(x: 0, y: 0)
        nav.size = CGSize(width: kScreenWidth, height: UIDevice.current.navigationBarHeight())
        nav.backgroundColor = UIColor.colorWidthHexString(hex: "202020")
        let labelTitle = UILabel(frame: CGRect(x: 0, y: UIDevice.current.isX() ? 51 : 27, width: kScreenWidth, height: 30))
        labelTitle.textAlignment = .center
        labelTitle.font = UIFont.systemFont(ofSize: 18)
        labelTitle.textColor = UIColor.white
        labelTitle.text = "用户协议"
        labelTitle.backgroundColor = UIColor.colorWidthHexString(hex: "202020")
        labelTitle.layer.masksToBounds = true
        nav.addSubview(labelTitle)
        let btnBack = UIButton(type: .custom)
        btnBack.setImage(UIImage(named: "common_back"), for: .normal)
        btnBack.setImage(UIImage(named: "common_back"), for: .selected)
        btnBack.bounds.size = CGSize(width: 50, height: 30)
        btnBack.origin = CGPoint(x: 10, y: labelTitle.top)
        btnBack.contentHorizontalAlignment = .left
        btnBack.imageView?.isUserInteractionEnabled = false
        btnBack.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        nav.addSubview(btnBack)
        return nav
    }()
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "title")
        clearWebCache()
    }
    


}

extension BSAgreementController: WKNavigationDelegate,WKUIDelegate {
    
    
    private func setupUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(viewNav)
        view.addSubview(webView)
        webView.addSubview(progress)
    }
    private func clearWebCache() {
        let websiteDataTypes = NSSet.init(array: [WKWebsiteDataTypeDiskCache,WKWebsiteDataTypeMemoryCache])
        let dateFrom = NSDate.init(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: dateFrom as Date) {
            BSLog("清楚成功")
        }
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
}
