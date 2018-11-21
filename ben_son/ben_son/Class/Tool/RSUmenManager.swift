//
//  RSUmenManager.swift
//  gokarting
//
//  Created by ZS on 2018/5/16.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import MessageUI

private let wechatAppKey = "wxa555bfbb36ce04f1"
private let wechatAppSecret = "c9b210c6667c0d307c2a84063156916b"
private let wechatRedirectURL = "http://www.benson-car.com"


private let qqAppkey = "1105771386"
private let qqAppSecret = "QAt9xQNCBZXzxQhH"
private let qqRedirectURL = "http://www.benson-car.com"


private let sinaAppKey = "3848794926"
private let sinaAppSecret = "ca20643a4974db5779463ad19ff45d68"
private let sinaRedirectURL = "http://www.benson-car.com"

enum  PlatformType: Int{
    
    case wechatType
    
    case qqType
    
    case sinaType
    
    case WechatTimeLine
    
    case email
    
    case platformUnKnow
}

enum ShareType: Int {
    case shareText
    
    case shareImage
    
    case shareImageAndText
    
    case shareWeb
    
    case shareMusic
    
    case shareVideo
    
    case sharUnKnow
}

class RSUmenManager: NSObject {
    
    @objc class func confitUShareSettings() {
        
        UMSocialGlobal.shareInstance().isUsingHttpsWhenShareContent = false
            UMConfigure.initWithAppkey("584e57e3f29d986fac000749", channel: nil)
            UMConfigure.setLogEnabled(true)
        configUSharePlatforms()
    }
    
    
    private class func configUSharePlatforms() {
        //微信
        UMSocialManager.default().setPlaform(.wechatSession, appKey: wechatAppKey, appSecret: wechatAppSecret, redirectURL: wechatRedirectURL)
        UMSocialManager.default().removePlatformProvider(with: .wechatFavorite)
        
        UMSocialManager.default().setPlaform(.QQ, appKey: qqAppkey, appSecret: qqAppSecret, redirectURL: qqRedirectURL)
        
        UMSocialManager.default().setPlaform(.sina, appKey: sinaAppKey, appSecret: sinaAppSecret, redirectURL: sinaRedirectURL)
        
    }
     @objc class func configUMGoBack(url: URL) -> Bool {
        
        return UMSocialManager.default().handleOpen(url)
    }
    
    class func shareEmail(vc: UIViewController) {
        
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
//        
        let mailVC = MFMailComposeViewController()
        mailVC.setSubject("本森超跑")
        mailVC.setMessageBody("r本森超跑-期待你的加入", isHTML: false)
        if let image = UIImage(named: "common_logio") {
            mailVC.addAttachmentData(image.pngData()!, mimeType: "image/png", fileName: "logo")
        }
        vc.navigationController?.present(mailVC, animated: true, completion: nil)
    }
    
    class func share(platformtype: PlatformType, sharemodel: ShareModel, shareType: ShareType ){
        
        var platform: UMSocialPlatformType?

        switch platformtype {
        case .wechatType:
            platform = .wechatSession
            break
        case .qqType:
            platform = .QQ
            break
        case .sinaType:
            platform = .sina
            break
        case .WechatTimeLine:
            platform = .wechatTimeLine
            break
        case .email:
            platform = .email
            break
        default:
            return
        }
        
        let messageObject = UMSocialMessageObject.init()
        
        switch shareType {
            
        /// 只分享文字
        case .shareText:
            messageObject.text = sharemodel.text
            break
            
        /// 分享图片
        case .shareImage:
            let shareObject = UMShareImageObject.init()
            if let _ = sharemodel.thumbImage{
                shareObject.thumbImage = UIImage(named: sharemodel.thumbImage!)
            }
            if let _ = sharemodel.imageUrl{
                shareObject.shareImage = sharemodel.imageUrl
            }
            messageObject.shareObject = shareObject
            break
            
        /// 分享图文(支持新浪微博)
        case .shareImageAndText:
            messageObject.text = sharemodel.text
            let shareObject = UMShareImageObject.init()
            if let _ = sharemodel.thumbImage{
                shareObject.thumbImage = UIImage(named: sharemodel.thumbImage!)
            }
            if let _ = sharemodel.imageUrl{
                shareObject.shareImage = sharemodel.imageUrl
            }
             messageObject.shareObject = shareObject
            break
        
            
        /// 分享网络连接
        case .shareWeb:
            
                let shareObject = UMShareWebpageObject.shareObject(withTitle: sharemodel.title, descr: sharemodel.desc, thumImage: UIImage(named: sharemodel.thumbImage ?? "common_logio"))
                shareObject?.webpageUrl = sharemodel.webUrl
                messageObject.shareObject = shareObject
            break
        
            
        /// 分享音乐
        case .shareMusic:
            let shareObject = UMShareMusicObject.shareObject(withTitle: sharemodel.title, descr: sharemodel.desc, thumImage: UIImage(named: sharemodel.thumbImage ?? "common_logio"))
            shareObject?.musicUrl = sharemodel.musicUrl
            messageObject.shareObject = shareObject
            break
            
        /// 分享视频URL
        case .shareVideo:
             let shareObject = UMShareVideoObject.shareObject(withTitle: sharemodel.title, descr: sharemodel.desc, thumImage: UIImage(named: sharemodel.thumbImage ?? ""))
                shareObject?.videoUrl = sharemodel.videoUrl
                messageObject.shareObject = shareObject
            break
        default:
            return
//            break
        }
        
        //一定不为空了
        UMSocialManager.default().share(to: platform!, messageObject: messageObject, currentViewController: nil) { (data, error) in
            
        }
    }
    
    
    class func getAuthWithUserInfoFromWechat(type: PlatformType, complete:@escaping (_ finish: Bool) -> ()){
        
        var platform: UMSocialPlatformType?
        
        switch type {
        case .wechatType:
            platform = .wechatSession
            break
        case .qqType:
            platform = .QQ
            break
        default:
            platform = .sina
            break
        }
        
        UMSocialManager.default().getUserInfo(with: platform!, currentViewController: nil) { (result, error) in
            if (error != nil){
//                RSProgressHUD.showStatusNarError(titlerStr: "授权失败")
                complete(false)
            }else{
                let resp = result as! UMSocialUserInfoResponse
                print(resp.iconurl)
//                RSAccount.shared.registUid = resp.uid
//                RSAccount.shared.registHeadUrl = resp.iconurl
//                RSAccount.shared.registThirdNick = resp.uid
                complete(true)
            }
        }
    }

}

class ShareModel{
    //文本
    @objc var text: String?
    
    /// 缩略图名字,本地的
    @objc var thumbImage: String?
    
    /// 分享图片的url.string
    @objc var imageUrl: String?
    
    /// 分享网页的url.string
    @objc var webUrl: String?
    
    /// 分享的标题
    @objc var title: String?
    
    /// 分享内容描述
    @objc var desc: String?
    
    /// 分享音乐url.string
    @objc var musicUrl: String?
    
    /// 分享的视频url.string
    @objc var videoUrl: String?
    
}
