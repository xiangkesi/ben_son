//
//  BSAccountManager.swift
//  ben_son
//
//  Created by ZS on 2018/9/20.
//  Copyright © 2018年 ZS. All rights reserved.
//

import Foundation
import ObjectMapper


class AccountManager {
    private static let manager = AccountManager()
    
    private var account: Account?
    
    class func shareManager() -> AccountManager {
        return manager
    }
    
    var token: String {
        return user?.token ?? ""
    }
    
    var token_type: String {
        return user?.token_type ?? ""
    }
    
    
    var isLogin: Bool {
        return user == nil ? false : true
    }
    
    private var user: Account? {
        return readLoginMsg()
    }
    
    
    func login(dic: Dictionary<String, Any>) {
        if let user = Account(JSON: dic), let JSONString = user.toJSONString(prettyPrint: true) {
            let userDefaults = UserDefaults.standard
            userDefaults.set(JSONString, forKey: "benson_login")
            userDefaults.synchronize()
            }
    }
    
    private func readLoginMsg() -> Account?{
        if account == nil{
            let userDefaults = UserDefaults.standard
            if let a = userDefaults.object(forKey: "benson_login"), let JSONString = a as? String {
                account = Account(JSONString: JSONString)
                return account
                }
            return nil
        }
        return account
    }
    
    func showLoginController() {
        let loginVc = BSLoginController()
        let nav = BSNavgationController.init(rootViewController: loginVc)
        kRootVc!.present(nav, animated: true, completion: nil)
    }
    
    func exitLogin() {
        let userDefaults = UserDefaults.standard
        if let _ = userDefaults.object(forKey: "benson_login") {
            userDefaults.removeObject(forKey: "benson_login")
            account = nil
        }
    }

}


class Account: Mappable {
    var token: String?
    
    var token_type: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        token       <- map["access_token"]
        token_type  <- map["token_type"]
    }
    
    
}
