//
//  BSCountdown.swift
//  ben_son
//
//  Created by ZS on 2018/9/17.
//  Copyright © 2018年 ZS. All rights reserved.
//

import Foundation
import RxSwift

extension Observable where Element: FloatingPoint {

    public static func timer(duration: RxTimeInterval = RxTimeInterval.infinity, interval: RxTimeInterval = 1, ascending: Bool = false, scheduler: SchedulerType = MainScheduler.instance)
        -> Observable<TimeInterval> {
            let count = (duration == RxTimeInterval.infinity) ? .max : Int(duration / interval) + 1
            return Observable<Int>.timer(0, period: interval, scheduler: scheduler)
                .map { TimeInterval($0) * interval }
                .map { ascending ? $0 : (duration - $0) }
                .take(count)
    }
}
