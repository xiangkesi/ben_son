//
//  BSNetworkReachability.swift
//  ben_son
//
//  Created by ZS on 2018/9/10.
//  Copyright © 2018年 ZS. All rights reserved.
//

import Alamofire

let manager = NetworkReachabilityManager(host: "")

class BSNetworkReachability {
    
    func newt() {
        manager?.listener = { status in
            
            switch status {
            case .notReachable:
                
                break
            case .unknown:
                
                break
            case .reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi):
                
                break
            case .reachable(NetworkReachabilityManager.ConnectionType.wwan):
                
                break
            default:
                
                break
            }
            manager?.startListening()
            
        }
    }
}
