//
//  Array+Extension.swift
//  ben_son
//
//  Created by ZS on 2018/10/30.
//  Copyright © 2018年 ZS. All rights reserved.
//

import Foundation
import RxSwift

extension Array {
    
    var rx_traversal: Observable<AnyObject> {
        
        return Observable.create({ (obs) -> Disposable in
            for item in self{
                obs.on(Event.next(item as AnyObject))
            }
            obs.onCompleted()
            return Disposables.create{
            }
        })
    }
    
}
