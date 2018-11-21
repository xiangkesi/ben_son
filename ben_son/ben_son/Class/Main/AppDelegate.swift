//
//  AppDelegate.swift
//  ben_son
//
//  Created by ZS on 2018/8/27.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupTabBarController()
        //推送
        setupJPush(launchOptions: launchOptions)
        //支付
        BSPayManager.manager.registAppid()
        //分享
        RSUmenManager.confitUShareSettings()
        return true
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("获取token失败\(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        registDeviceToken(token: deviceToken)
    }

    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Float(UIDevice.current.systemVersion)! < Float(10.0) {
            if application.applicationState.rawValue > 0 {
            //非活跃状态
                remoteNotion(userInfo: userInfo, isBackground: true)
            }else{
               remoteNotion(userInfo: userInfo, isBackground: false)
            }
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        } else {
            application.cancelAllLocalNotifications()
        }
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        
        return BSPayManager.manager.handleOpenURL(url: url)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    



}



extension AppDelegate: JPUSHRegisterDelegate {

    
    
    private func setupTabBarController() {
        window = UIWindow.init(frame: UIScreen.main.bounds)

        let tabBar = BSTabBarController()
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
        
        BSLaunchVideoView.showLaunchVideoView()
        
    }
    
    private func setupJPush(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        let entity = JPUSHRegisterEntity.init()
        entity.types = 1 << 0 | 1 << 1 | 1 << 2
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        JPUSHService.setup(withOption: launchOptions, appKey: "d0bf1f38f71a1624cb478b2d", channel: "app store", apsForProduction: false)
        JPUSHService.registrationIDCompletionHandler { (resCode, registrationID) in
            if(resCode == 0){
//                NSLog(@"registrationID获取成功：%@",registrationID);
                BSLog("registrationID获取成功\(registrationID ?? "123434535234543")")
            }
            else{
                BSLog("registrationID获取成功\(resCode)")

            }
        }
    }
    
    private func registDeviceToken(token: Data) {
        JPUSHService.registerDeviceToken(token)
    }
    
    private func remoteNotion(userInfo: [AnyHashable : Any], isBackground: Bool) {
        JPUSHService.handleRemoteNotification(userInfo)
        BSSkipVc.skipToVc(userInfo: userInfo, isBackground: isBackground)
    }
    
    @available(iOS 10.0, *)//前台
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        if notification.request.trigger!.isKind(of: UNPushNotificationTrigger.self) {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        BSLog(userInfo)
        BSSkipVc.skipToVc(userInfo: userInfo, isBackground: false)
        completionHandler(Int(UNNotificationPresentationOptions.badge.rawValue)
            | Int(UNNotificationPresentationOptions.sound.rawValue))
    }
    
    @available(iOS 10.0, *)//后台
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))! {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        BSSkipVc.skipToVc(userInfo: userInfo, isBackground: true)
        completionHandler()
    }
    
    @available(iOS 12.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification?) {
        
        if notification != nil && (notification?.request.trigger?.isKind(of: UNPushNotificationTrigger.self))! {
              //从通知界面直接进入应用
        }else{
            //从通知设置界面进入应用
        }
    }
}

extension AppDelegate {
    
}

