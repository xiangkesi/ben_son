//
//  BSPayManager.swift
//  ben_son
//
//  Created by ZS on 2018/11/6.
//  Copyright © 2018 ZS. All rights reserved.
//

import Foundation

enum PayCode: Int {
    /// 微信支付成功
    case WXSUCESS = 1001
    
    /// 微信支付失败
    case WXERROR = 1002
    
    /// 微信取消支付
    case WXSCANCEL = 1003
    
    /// 未安装微信
    case WXERROR_NOTINSTALL = 1004
    
    /// 微信不支持
    case WXERROR_UNSUPPORT = 1005
    
    /// 微信支付参数解析错误
    case WXERROR_PARAM = 1006
    
    /// 支付宝支付成功
    case ALIPAYSUCESS = 1101
    
    /// 支付宝支付错误
    case ALIPAYERROR = 1102
    
    /// 支付宝支付取消
    case ALIPAYCANCEL = 1103
}
class BSPayManager: NSObject {
    static let manager = BSPayManager()
    
    private var pay_result:((_ pay_code: PayCode) -> ())?

    func registAppid() {
        WXApi.registerApp("wxa555bfbb36ce04f1", enableMTA: false)
    }
    //MARK: --------微信支付
    func wxPay(pay_param: WhchatPayModel,
               payResult:@escaping ((_ pay_code: PayCode) -> ())) {
        pay_result = payResult
        
        WXApi.registerApp(pay_param.appid)
        if !WXApi.isWXAppInstalled() {
            pay_result!(PayCode.WXERROR_NOTINSTALL)
            return
        }
        if !WXApi.isWXAppSupport() {
            pay_result!(PayCode.WXERROR_UNSUPPORT)
            return
        }
        
        let req = PayReq.init()
        //商户号
        req.partnerId = pay_param.partnerid
        //微信返回的支付交易会话ID
        req.prepayId = pay_param.prepayid
        // 随机字符串,不长于32位
        req.nonceStr = pay_param.noncestr
        // 时间戳
        req.timeStamp = UInt32(pay_param.timestamp)
        //暂填写固定值Sign=WXPay
        req.package = pay_param.package
        //签名
        req.sign = pay_param.sign
        WXApi.send(req)
        
        
    }
    
    func handleOpenURL(url: URL) -> Bool {
        if url.host == "pay" {
            return WXApi.handleOpen(url, delegate: self)
        }else if url.host == "safepay" {
            AlipaySDK.defaultService()?.processOrder(withPaymentResult: url, standbyCallback: { (resultDic) in
                
                if let dicRe = resultDic as? [String: Any], let result = dicRe["resultStatus"]{
                    let resultCode = (result as AnyObject).int64Value
                    
                    switch resultCode {
                    case 9000:
                        self.pay_result!(PayCode.ALIPAYSUCESS)
                        break
                    case 6001:
                        self.pay_result!(PayCode.ALIPAYCANCEL)
                        break
                    default:
                        self.pay_result!(PayCode.ALIPAYERROR)
                        break
                    }
                    return
                }
                self.pay_result!(PayCode.ALIPAYERROR)
                //【由于在跳转支付宝客户端支付的过程中,商户app在后台很可能被系统kill了,所以pay接口的callback就会失效,请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            })
        }
        
        return true
    }
    
    //MARK: --------支付宝支付
    func alipayPay(pay_param: String,
               payResult:@escaping ((_ pay_code: PayCode) -> ())) {
        
        pay_result = payResult
        AlipaySDK.defaultService()?.payOrder(pay_param, fromScheme: "com.cxwl.BensonApp", callback: { (dic) in
            
            if let dicResult = dic as? [String: Any], let result = dicResult["resultStatus"]{
                let resultCode = (result as AnyObject).int64Value
                switch resultCode {
                case 9000:
                    self.pay_result!(PayCode.ALIPAYSUCESS)
                    break
                case 6001:
                    self.pay_result!(PayCode.ALIPAYCANCEL)
                default:
                    self.pay_result!(PayCode.ALIPAYERROR)
                    break
                }
            }
        })
        
    }
    

}

extension BSPayManager: WXApiDelegate {
    
    func onResp(_ resp: BaseResp!) {
        if resp.isKind(of: PayResp.self) {
            switch resp.errCode {
            case 0:  //WXSuccess
                pay_result!(PayCode.WXSUCESS)
                break
            case -2: //WXErrCodeUserCancel
                pay_result!(PayCode.WXSCANCEL) ////用户点击取消并返回
                break
            default:
                pay_result!(PayCode.WXERROR)
                break
            }
        }
    }
}
