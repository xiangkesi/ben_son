//
//  BSTool.swift
//  ben_son
//
//  Created by ZS on 2018/9/21.
//  Copyright © 2018年 ZS. All rights reserved.
//

import Foundation
import ContactsUI
import CoreLocation
import UserNotificationsUI
import AVFoundation
import PhotosUI
import MapKit

class BSTool {
    
    class func callPhone(phone: String?) {
        guard let _ = phone else {
            return
        }
        UIApplication.shared.openURL(URL.init(string: "tel://" + phone!)!)
    }
    
    
    
    /// 监测通讯录权限
    ///
    /// - Parameter completion:
    class func requestAuthorizationAddressBook(completion:@escaping (_ success: Bool) -> ()) {
        let status = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        if status == CNAuthorizationStatus.notDetermined {
            let store = CNContactStore.init()
            store.requestAccess(for: CNEntityType.contacts) { (granted, error) in
                
                BSLog(Thread.current)
                if error != nil {
                    BSLog("授权失败")
                    completion(false)
                }else{
                    completion(true)
                    BSLog("授权成功,进行下一步惭怍")
                }
            }
        }else if status == CNAuthorizationStatus.restricted {
            BSLog("用户拒绝")
            self.showAlertViewAboutNotAuthorAccessContact(title: "请授权通讯录权限", message: "请在iPhone的\"设置-隐私-通讯录\"选项中,允许花解解访问你的通讯录")
        }else if status == CNAuthorizationStatus.denied {
            BSLog("用户拒绝")
            self.showAlertViewAboutNotAuthorAccessContact(title: "请授权通讯录权限", message: "请在iPhone的\"设置-隐私-通讯录\"选项中,允许花解解访问你的通讯录")

        }else if status == CNAuthorizationStatus.authorized {
             //有通讯录权限-- 进行下一步操作
            BSLog("已经有访问权限了,进行下一步操作")
            completion(true)
        }
    }
    private class func showAlertViewAboutNotAuthorAccessContact(title: String, message: String) {
        if kRootVc == nil {
            return
        }
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let camcelAction = UIAlertAction.init(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
        
        let oKAction = UIAlertAction.init(title: "好的", style: UIAlertAction.Style.default) { (action) in
            UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString)!)
        }
        alertController.addAction(camcelAction)
        alertController.addAction(oKAction)
        
        kRootVc?.present(alertController, animated: true, completion: nil)
    }
    
    
    class func showAlertView(title: String? , message: String?,image: UIImage?, vc: UIViewController) {
        if image == nil {
            return
        }
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.actionSheet)
        let camcelAction = UIAlertAction.init(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
        let oKAction = UIAlertAction.init(title: "保存", style: UIAlertAction.Style.default) { (action) in
            
            monitoringPhotoAuthorization(completion: {[weak vc] (finish) in
                if finish {
                    UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
                }else{
                    showAlertViewSavePhoto(title: "请求获取相册权限", message: "请在iPhone的\"设置-隐私-相册\"选项中,允许本森超跑访问你的相册", vc: vc)
                }
            })
        }
        alertController.addAction(camcelAction)
        alertController.addAction(oKAction)
        vc.present(alertController, animated: true, completion: nil)

    }
    
    
    private class func showAlertViewSavePhoto(title: String, message: String, vc: UIViewController?) {
        if vc == nil {
            return
        }
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let camcelAction = UIAlertAction.init(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
        
        let oKAction = UIAlertAction.init(title: "好的", style: UIAlertAction.Style.default) { (action) in
            UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString)!)
        }
        alertController.addAction(camcelAction)
        alertController.addAction(oKAction)
        
        vc!.present(alertController, animated: true, completion: nil)
    }
    
    /// 监测是否开启定位
    ///
    /// - Returns:
    class func monitoringLocationAuthorization(completion:@escaping (_ success: Bool) -> ()) {
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.denied {
            completion(true)
            return
        }
        self.showAlertViewAboutNotAuthorAccessContact(title: "请求定位权限", message: "请在iPhone的\"设置-隐私-定位\"选项中,允许本森超跑访问你的位置")
    }
    
    
    /// 判断是否开启了推送
    ///
    /// - Parameter completion:
    class func monitoringNotificationAuthorization(completion:@escaping (_ success: Bool) -> ()) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
               let isOpen = (settings.authorizationStatus == UNAuthorizationStatus.authorized)
                DispatchQueue.main.async(execute: {
                    if isOpen {
                                completion(true)
                        }else{
                                self.showAlertViewAboutNotAuthorAccessContact(title: "请求推送权限", message: "请在iPhone的\"设置-隐私-通知\"选项中,允许本森超跑为你推送消息")
                            }
                        })
            }
        } else {
           let isOpen = UIApplication.shared.isRegisteredForRemoteNotifications
            if isOpen {
                BSLog("打开了通知")
                completion(true)
            }else{
                self.showAlertViewAboutNotAuthorAccessContact(title: "请求推送权限", message: "请在iPhone的\"设置-隐私-通知\"选项中,允许本森超跑为你推送消息")
            }
        }
       
    }
    
    
    
    /// 是否有权限访问相机
    ///
    /// - Parameter completion:
    class func monitoringCaptureDeviceAuthorization(completion:@escaping (_ success: Bool) -> ()) {
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == AVAuthorizationStatus.notDetermined {
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { (finish) in
                completion(finish)
            }
        }else if authStatus == AVAuthorizationStatus.restricted {
            self.showAlertViewAboutNotAuthorAccessContact(title: "请求获取相机权限", message: "请在iPhone的\"设置-隐私-相机\"选项中,允许本森超跑访问你的相机")
        }else if authStatus == AVAuthorizationStatus.denied {
            self.showAlertViewAboutNotAuthorAccessContact(title: "请求获取相机权限", message: "请在iPhone的\"设置-隐私-相机\"选项中,允许本森超跑访问你的相机")
        }else if authStatus == AVAuthorizationStatus.authorized {
            BSLog("已经有访问权限了,进行下一步操作")
             completion(true)
        }
    }
    
    
    
    /// 是否有权限访问相册
    ///
    /// - Parameter completion: 
    class func monitoringPhotoAuthorization(completion:@escaping (_ success: Bool) -> ()) {
        PHPhotoLibrary.requestAuthorization { (authStatus) in
            DispatchQueue.main.async(execute: {
                if authStatus == PHAuthorizationStatus.restricted || authStatus == PHAuthorizationStatus.denied {
                    completion(false)
                    return
                }
                completion(true)
            })
        }
    }
    
    class func saveImageToAlbum(image: UIImage?) {
        if image == nil { return}
        self.monitoringPhotoAuthorization { (finish) in
            if finish {
                UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
            }else {
                self.showAlertViewAboutNotAuthorAccessContact(title: "请求获取相册权限", message: "请在iPhone的\"设置-隐私-相册\"选项中,允许本森超跑访问你的相册")
            }
        }
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?,contextInfo: AnyObject) {
        BSLog(error)
    }
    
    class func toMapApp(vc: UIViewController, latitude: Double?, longitude: Double?, destName: String?) {
        guard let _ = latitude, let _ = longitude else {
            RSProgressHUD.showSuccessOrFailureHud(titleStr: "未获取到经纬度", vc.view)
            return
        }
        let destinationName = destName ?? ""
        let actionSheet = UIAlertController(title: "选择地图", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        //苹果地图
        let appleAction = UIAlertAction(title: "苹果地图", style: UIAlertAction.Style.default) { (action) in
            let loc = CLLocationCoordinate2DMake(latitude!, longitude!)
            let currentLocation = MKMapItem.forCurrentLocation()
            let toLocation = MKMapItem.init(placemark: MKPlacemark.init(coordinate: loc, addressDictionary: nil))
            toLocation.name = destinationName
            MKMapItem.openMaps(with: [currentLocation, toLocation], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsShowsTrafficKey: NSNumber.init(booleanLiteral: true)])
        }
        actionSheet.addAction(appleAction)
        
        var charSet = CharacterSet.urlQueryAllowed
        charSet.insert(charactersIn: "#")
        if UIApplication.shared.canOpenURL(URL(string: "qqmap://")!) {
            
            let tencentAction = UIAlertAction(title: "腾讯地图", style: UIAlertAction.Style.default) { (action) in
                
                let tecenStr = String(format: "qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=%@&coord_type=&policy=0", latitude!, longitude!, destinationName)
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: tecenStr.addingPercentEncoding(withAllowedCharacters: charSet)!)!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(URL(string: tecenStr.addingPercentEncoding(withAllowedCharacters: charSet)!)!)
                }
            }
            actionSheet.addAction(tencentAction)
            
        }
        
        if UIApplication.shared.canOpenURL(URL(string: "iosamap://")!) {
            let gaodeAction = UIAlertAction(title: "高德地图", style: .default) { (action) in
                let urlStr = String(format: "iosamap://navi?sourceApplication= &sid=&dlat=%f&dlon=%f&dname=%@", latitude!, longitude!, destinationName)
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: urlStr.addingPercentEncoding(withAllowedCharacters: charSet)!)!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(URL(string: urlStr.addingPercentEncoding(withAllowedCharacters: charSet)!)!)
                }
            }
            actionSheet.addAction(gaodeAction)
        }
        
        
        //百度地图
        if UIApplication.shared.canOpenURL(URL(string: "baidumap://")!) {
            let baiduAction = UIAlertAction(title: "百度地图", style: .default) { (action) in
                let urlStr = String(format: "baidumap://map/direction?origin={{我的位置}}&destination=name:%@|latlng:%f,%f&mode=driving&coord_type=gcj02", destinationName, latitude!, longitude!)
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: urlStr.addingPercentEncoding(withAllowedCharacters: charSet)!)!, options: [:], completionHandler: nil)
                    
                } else {
                    UIApplication.shared.openURL(URL(string: urlStr.addingPercentEncoding(withAllowedCharacters: charSet)!)!)
                    
                }
            }
            actionSheet.addAction(baiduAction)
        }

        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        vc.present(actionSheet, animated: true, completion: nil)
        
    }
    
}
