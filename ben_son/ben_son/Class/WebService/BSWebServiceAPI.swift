//
//  BSWebServiceAPI.swift
//  ben_son
//
//  Created by ZS on 2018/9/5.
//  Copyright © 2018年 ZS. All rights reserved.
//

import Foundation
import Moya
import Result
let bs_provider = MoyaProvider<BSServiceAPI>(requestClosure:requestClosure)

let bs_uploadFile_bs_provider = MoyaProvider<BSServiceAPI>(requestClosure:requestClosure,plugins:[RequestLoadingPlugin()])


private final class RequestLoadingPlugin: PluginType {
    public func willSend(_ request: RequestType, target: TargetType) {
        RSProgressHUD.showWindowesLoading(view: kRootVc?.view, titleStr: "加载中...")
    }
    
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        RSProgressHUD.hideHUDQueryHUD(view: (kRootVc?.view)!)
    }
}

private let requestClosure = { (endpoint: Endpoint, closure: (Result<URLRequest, MoyaError>) -> Void)  -> Void in
    do {
        var  urlRequest = try endpoint.urlRequest()
        urlRequest.timeoutInterval = 6.0
        urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        urlRequest.httpShouldHandleCookies = false
        closure(.success(urlRequest))
    } catch MoyaError.requestMapping(let url) {
        closure(.failure(MoyaError.requestMapping(url)))
    } catch MoyaError.parameterEncoding(let error) {
        closure(.failure(MoyaError.parameterEncoding(error)))
    } catch {
        closure(.failure(MoyaError.underlying(error, nil)))
    }
    
}

struct BSNetWork {
    //请求成功回调
    typealias successCallback = (_ result: Any) -> Void
    
    typealias failureCallback = (_ error: MoyaError) -> Void
    
    typealias progressCallback = (_ progress: CGFloat) -> Void
    

    
    static func bs_request(target: BSServiceAPI,
                           success: @escaping successCallback,
                           failure: @escaping failureCallback) {
        bs_provider.request(target) { (result) in
            switch result {
            case let .success(moyaResponse):
                do {
                    try success(moyaResponse.mapJSON()) // 测试用JSON数据
                } catch {
                    failure(MoyaError.jsonMapping(moyaResponse))
                }
            case let .failure(error):
                BSLog(error)
                failure(error)
            }
        }
    }

    //DispatchQueue.global().async {
    //    DispatchQueue.main.async(execute: {
    //        print("主线程更新UI \(Thread.current)")
    //    })
    //}
    //DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.4) {
    //    self.scrollViewDidEndDecelerating(self.adScrollView)
    //}
    //perform(#selector(scrollViewDidEndDecelerating), with: self, afterDelay: 0.4)
    
    static func bs_uploadFile(target: BSServiceAPI,
                              success: @escaping successCallback,
                              progress: @escaping progressCallback,
                              failure: @escaping failureCallback) {
        
        bs_provider.request(target, callbackQueue: DispatchQueue.main, progress: { (progresss) in
            //这个就是主线程
            progress(CGFloat(progresss.progress))
        }) { (result) in
             //这个就是主线程
            switch result {
            case let .success(moyaResponse):
                do {
                    try success(moyaResponse.mapJSON()) // 测试用JSON数据
                } catch {
                    failure(MoyaError.jsonMapping(moyaResponse))
                }
            case let .failure(error):
                failure(error)
            }
        }
    }
    
    static func bs_uploadVideo(target: BSServiceAPI,
                               success: @escaping successCallback,
                               progress: @escaping progressCallback,
                               failure: @escaping failureCallback) {
        bs_provider.request(target, callbackQueue: DispatchQueue.global(), progress: { (progresss) in
            progress(CGFloat(progresss.progress))
        }) { (result) in
            //这个就是主线程
            switch result {
            case let .success(moyaResponse):
                do {
                    try success(moyaResponse.mapJSON()) // 测试用JSON数据
                } catch {
                    failure(MoyaError.jsonMapping(moyaResponse))
                }
            case let .failure(error):
                failure(error)
            }
        }
    }
    
    static func bs_cancelAllRequest() {
        bs_provider.manager.session.getTasksWithCompletionHandler { (dataTasks, uploadTasks, downloadTasks) in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }
}

enum BSServiceAPI {
    
// MARK: - 登录
    case login(phone: String, code: String)
    
// MARK: - 获取验证码
    case login_getcode(phone: String)
    
// MARK: - 获取车辆品牌
    case car_brand
    
// MARK: - 请求车辆列表
    case car_model_list(brand: Int)
    
// MARK: - 首页推荐车辆
    case recommended_car
    
// MARK: - 车辆页推荐车辆
    case recommended_car_car
    
// MARK: - 新闻列表
    case news_list(page: Int)
    
// MARK: - 首页轮播图
    case home_bander
    
// MARK: - 本森托管
    case benson_hosting(param: [String: Any], imageDatas:[Data])
    
// MARK: - 发现页面
    case dicover_msg
    
// MARK: - 车辆详情
    case car_detail(carId: Int)
    
// MARK: - 提交预定信息
    case car_online_upload(param: [String: Any])
    
// MARK: - 生成订单
    case generate_order(param: [String: Any])
    
// MARK: - 订单列表
    case order_list(status: String)
    
// MARK: - 订单详情
    case order_detail(orderId: Int)
    
// MARK: - 收藏
    case car_collection_creat(carId: Int)
    
// MARK: - 取消收藏
    case car_collection_cancel(carId: Int)
    
// MARK: - 收藏列表
    case car_collection_list

// MARK: - 公司列表
    case companys_list
    
// MARK: - 修改用户信息
    case modify_user_msg(param: [String: Any])
    
// MARK: - 热门搜索
    case hot_search_cars
    
// MARK: - 关键词搜索
    case search_car(keywords: String)
    
// MARK: - 个人中心
    case mine_msg
    
// MARK: -地址选择列表
    case address_list
    
// MARK: - 添加地址
    case add_address(param: [String: Any])
    
// MARK: - 删除地址
    case delete_address_list(addressId: Int)
    
// MARK: - 意见反馈
    case feedback(param: [String: Any])
    
// MARK: - 通知列表
    case notification_list
    
// MARK: - 通知详情
    case notification_detail(notificationId: Int)
    
// MARK: - 积分列表
    case scores_list
    
// MARK: - b纯粹是为了去除警告
    case cancelWaring
}

extension BSServiceAPI: TargetType {
  
    
    var baseURL: URL {
        
//        switch self {
//        case .uploadFile(uploadType: _, files: _):
//            return URL.init(string: "http://test.raykart.com/api")!http://192.168.0.30:8088/api https://benson-car.raykart.com/api
//        default:https://benson-car.raykart.com/api
            return URL.init(string: "https://benson-car.raykart.com/api")!
//        }
    }
    
    var path: String {
        
        switch self {
        case .login(phone: _, code: _):
            return "/login"
        case .login_getcode(phone: _):
            return "/sendCode"
        case .car_brand:
            return "/brands"
        case let .car_model_list(brand):
            return "/brand-cars/" + String(brand)
        case .recommended_car:
            return "/index-cars"
        case .recommended_car_car:
            return "/index-third-cars"
        case .news_list:
            return "/news"
        case .home_bander:
            return "/index-images"
        case .benson_hosting(param: _, imageDatas: _):
            return "/management"
        case .dicover_msg:
            return "/companys/1"
        case let .car_detail(carId):
            return "/cars/" + String(carId)
        case .companys_list:
            return "/companys"
        case .car_collection_creat(carId: _):
            return "/car-marks-create"
        case .car_collection_cancel(carId: _):
            return "/car-marks-cancel"
        case .car_collection_list:
            return "/car-marks"
        case .modify_user_msg(param: _):
            return "/member"
        case .hot_search_cars:
            return "/hots"
        case .search_car(keywords: _):
            return "/search"
        case .car_online_upload(param: _):
            return "/order-create"
        case .generate_order(param: _):
            return "/order-pay"
        case .order_list(status: _):
            return "/orders"
        case .mine_msg:
            return "/member-info"
        case .address_list:
            return "/member-address-list"
        case .add_address(param: _):
            return "/member-address-create"
        case .delete_address_list(addressId: _):
            return "/member-address-delete"
        case .feedback(param: _):
            return "/member-proposal-create"
        case let .order_detail(orderId):
            return "/orders/" + String(orderId)
        case .notification_list:
            return "/notifications"
        case let .notification_detail(notificationId):
            return "/notifications/" + String(notificationId)
        case .scores_list:
            return "/scores"
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login_getcode(phone: _),
             .login(phone: _, code: _),
             .benson_hosting(param: _, imageDatas: _),
             .car_collection_creat(carId: _),
             .car_collection_cancel(carId: _),
             .modify_user_msg(param: _),
             .add_address(param: _),
             .car_online_upload(param: _),
             .generate_order(param: _),
             .delete_address_list(addressId: _),
             .feedback(param: _):
                return .post
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case let .login_getcode(phone):
            return .requestParameters(parameters: ["telephone": phone], encoding: URLEncoding.default)
        case .car_brand,
             .recommended_car,
             .recommended_car_car,
             .home_bander,
             .dicover_msg,
             .car_model_list(brand: _),
             .order_detail(orderId: _),
             .notification_list,
             .notification_detail(notificationId: _),
             .scores_list:
                return .requestPlain
        case let .news_list(page):
            return .requestParameters(parameters: ["page" : page], encoding: URLEncoding.default)
        case let .login(phone, code):
            return .requestParameters(parameters: ["telephone": phone, "code": code], encoding: URLEncoding.default)
        case let .benson_hosting(param, imageDatas):
            
            var formDatas = [MultipartFormData]()
            for fileData in imageDatas {
                let formData = MultipartFormData(provider: .data(fileData), name: "image[]", fileName: "12345678.jpg", mimeType: "image/jpeg")
                formDatas.append(formData)
            }
            return .uploadCompositeMultipart(formDatas, urlParameters: param)
            
        case .car_detail,
             .companys_list,
             .car_collection_list,
             .hot_search_cars,
             .mine_msg,
             .address_list:
                return .requestPlain
        case let .car_collection_creat(carId):
            return .requestParameters(parameters: ["car_id": carId], encoding: URLEncoding.default)
        case let .car_collection_cancel(carId):
            return .requestParameters(parameters: ["car_id": carId], encoding: URLEncoding.default)
        case let .modify_user_msg(param):
            if param["file"] != nil {
                let file = param["file"] as! Data
                let formData = MultipartFormData(provider: MultipartFormData.FormDataProvider.data(file), name: "avatar", fileName: "head.jpg", mimeType: "image/jpeg")
                return .uploadMultipart([formData])
            }else{
                return .requestParameters(parameters: param, encoding: URLEncoding.default)
            }
        case let .search_car(keywords):
            return .requestParameters(parameters: ["keyword": keywords], encoding: URLEncoding.default)
        case let .add_address(param), let .feedback(param):
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case let .delete_address_list(addressId):
            return .requestParameters(parameters: ["id": addressId], encoding: URLEncoding.default)
        case let .car_online_upload(param):
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case let .generate_order(param):
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case let .order_list(status):
            return .requestParameters(parameters: ["status":status], encoding: URLEncoding.default)
        default:
            return .requestParameters(parameters: ["name":"hahah"], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        let tokenString =  AccountManager.shareManager().token_type + " " + AccountManager.shareManager().token
        return ["Authorization": tokenString,
                "x-requested-with": "XMLHttpRequest"]
    }
    
    
}
