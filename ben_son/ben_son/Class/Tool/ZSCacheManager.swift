//
//  ZSCacheManager.swift
//  ben_son
//
//  Created by ZS on 2018/8/29.
//  Copyright © 2018年 ZS. All rights reserved.
//

import YYCache
let kPath_cache = "cache_disk"//表名字

let kPath_carlist = "car_list"//缓存车品牌以及品牌下的数据
let kPath_recommended_car_car = "recommended_car_car"



class ZSCacheManager {
    private static let manager = ZSCacheManager()
    
    class func shareManager() -> ZSCacheManager{
        return manager
    }
    
    private var diskCache: YYDiskCache?
    
    init() {
        /// 创建表,一共就创建一个表就行
        let cacheData = YYCache.init(name: kPath_cache)
        diskCache = cacheData?.diskCache
    }
    
    /// 根据key值判断是否存在
    ///
    /// - Parameter cacheKey: 对应要缓存的Key值
    /// - Returns: 是否存在
    func judgeJsonExist(cacheKey: String?) -> Bool {
        if (cacheKey?.kIsEmpty())! {
            return false
        }
        let isExist = diskCache?.containsObject(forKey: cacheKey!)
        return isExist ?? false
    }    
    /// 进行存储
    ///
    /// - Parameters:
    ///   - json: 要存储的数据
    ///   - cacheKey: 存储的key值
    ///   - page: 分页的页码
    func cacheData(_ json: Any?,_ cacheKey: String?,_ page: Int = 1) {
        if json == nil || (cacheKey?.kIsEmpty())! || page != 1 {
            return
        }
        DispatchQueue.global().async {
            if let saveJson = json as? NSCoding {
                self.diskCache?.setObject(saveJson, forKey: cacheKey!)
            }
        }
    }
    
    func readCacheData(cacheKey: String?) -> Any? {
        if (cacheKey?.kIsEmpty())! {
            return nil
        }
        if judgeJsonExist(cacheKey: cacheKey) == false {
            return nil
        }
        return diskCache?.object(forKey: cacheKey!)
    }
    
    func removeCacheData(cacheKey: String?) {
        if (cacheKey?.kIsEmpty())! {
            return
        }
        if judgeJsonExist(cacheKey: cacheKey) == false {
            return
        }
        diskCache?.removeObject(forKey: cacheKey!)
    }
}
