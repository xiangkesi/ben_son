//
//  ZSLocationManager.swift
//  ben_son
//
//  Created by ZS on 2018/9/21.
//  Copyright © 2018年 ZS. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import CoreLocation


extension CLLocationManager: HasDelegate {
    public typealias Delegate = CLLocationManagerDelegate
}

public class RxCLLocationManagerDelegateProxy: DelegateProxy<CLLocationManager, CLLocationManagerDelegate>, DelegateProxyType, CLLocationManagerDelegate {
    

    public init(locationManager: CLLocationManager) {
        super.init(parentObject: locationManager,
                   delegateProxy: RxCLLocationManagerDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { RxCLLocationManagerDelegateProxy(locationManager: $0) }
    }
    internal lazy var didUpdateLocationsSubject = PublishSubject<[CLLocation]>()
    internal lazy var didFailWithErrorSubject = PublishSubject<Error>()

    public func locationManager(_ manager: CLLocationManager,
                                didUpdateLocations locations: [CLLocation]) {
        _forwardToDelegate?.locationManager?(manager, didUpdateLocations: locations)
        didUpdateLocationsSubject.onNext(locations)
    }
    
    public func locationManager(_ manager: CLLocationManager,
                                didFailWithError error: Error) {
        _forwardToDelegate?.locationManager?(manager, didFailWithError: error)
        didFailWithErrorSubject.onNext(error)
    }
    
    deinit {
        self.didUpdateLocationsSubject.on(.completed)
        self.didFailWithErrorSubject.on(.completed)
    }
    
    
}

extension Reactive where Base: CLLocationManager  {
    
    /**
     Reactive wrapper for `delegate`.
     
     For more information take a look at `DelegateProxyType` protocol documentation.
     */
    public var delegate: DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
        return RxCLLocationManagerDelegateProxy.proxy(for: base)
    }
    
    // MARK: Responding to Location Events
    
    /**
     Reactive wrapper for `delegate` message.
     */
    public var didUpdateLocations: Observable<[CLLocation]> {
        return RxCLLocationManagerDelegateProxy.proxy(for: base)
            .didUpdateLocationsSubject.asObservable()
    }

    /**
     Reactive wrapper for `delegate` message.
     */
    public var didFailWithError: Observable<Error> {
        return RxCLLocationManagerDelegateProxy.proxy(for: base)
            .didFailWithErrorSubject.asObservable()
    }
    
    #if os(iOS) || os(macOS)
    /**
     Reactive wrapper for `delegate` message.
     */
    public var didFinishDeferredUpdatesWithError: Observable<Error?> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate
            .locationManager(_:didFinishDeferredUpdatesWithError:)))
            .map { a in
                return try castOptionalOrThrow(Error.self, a[1])
        }
    }
    #endif
    
    
    #if os(iOS)
    
    // MARK: Pausing Location Updates
    
    /**
     Reactive wrapper for `delegate` message.
     */
    public var didPauseLocationUpdates: Observable<Void> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate
            .locationManagerDidPauseLocationUpdates(_:)))
            .map { _ in
                return ()
        }
    }
    
    /**
     Reactive wrapper for `delegate` message.
     */
    public var didResumeLocationUpdates: Observable<Void> {
        return delegate.methodInvoked( #selector(CLLocationManagerDelegate
            .locationManagerDidResumeLocationUpdates(_:)))
            .map { _ in
                return ()
        }
    }
    
    // MARK: Responding to Heading Events
    
    /**
     Reactive wrapper for `delegate` message.
     */
    public var didUpdateHeading: Observable<CLHeading> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate
            .locationManager(_:didUpdateHeading:)))
            .map { a in
                return try castOrThrow(CLHeading.self, a[1])
        }
    }
    
    // MARK: Responding to Region Events
    
    /**
     Reactive wrapper for `delegate` message.
     */
    public var didEnterRegion: Observable<CLRegion> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate
            .locationManager(_:didEnterRegion:)))
            .map { a in
                return try castOrThrow(CLRegion.self, a[1])
        }
    }
    
    /**
     Reactive wrapper for `delegate` message.
     */
    public var didExitRegion: Observable<CLRegion> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate
            .locationManager(_:didExitRegion:)))
            .map { a in
                return try castOrThrow(CLRegion.self, a[1])
        }
    }
    
    #endif
    
    #if os(iOS) || os(macOS)
    
    /**
     Reactive wrapper for `delegate` message.
     */
    @available(OSX 10.10, *)
    public var didDetermineStateForRegion: Observable<(state: CLRegionState,
        region: CLRegion)> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate
            .locationManager(_:didDetermineState:for:)))
            .map { a in
                let stateNumber = try castOrThrow(NSNumber.self, a[1])
                let state = CLRegionState(rawValue: stateNumber.intValue)
                    ?? CLRegionState.unknown
                let region = try castOrThrow(CLRegion.self, a[2])
                return (state: state, region: region)
        }
    }
    
    /**
     Reactive wrapper for `delegate` message.
     */
    public var monitoringDidFailForRegionWithError:
        Observable<(region: CLRegion?, error: Error)> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate
            .locationManager(_:monitoringDidFailFor:withError:)))
            .map { a in
                let region = try castOptionalOrThrow(CLRegion.self, a[1])
                let error = try castOrThrow(Error.self, a[2])
                return (region: region, error: error)
        }
    }
    
    /**
     Reactive wrapper for `delegate` message.
     */
    public var didStartMonitoringForRegion: Observable<CLRegion> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate
            .locationManager(_:didStartMonitoringFor:)))
            .map { a in
                return try castOrThrow(CLRegion.self, a[1])
        }
    }
    
     #endif
    
    #if os(iOS)
    
    // MARK: Responding to Ranging Events
    
    /**
     Reactive wrapper for `delegate` message.
     */
    public var didRangeBeaconsInRegion: Observable<(beacons: [CLBeacon],
        region: CLBeaconRegion)> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate
            .locationManager(_:didRangeBeacons:in:)))
            .map { a in
                let beacons = try castOrThrow([CLBeacon].self, a[1])
                let region = try castOrThrow(CLBeaconRegion.self, a[2])
                return (beacons: beacons, region: region)
        }
    }
    
    /**
     Reactive wrapper for `delegate` message.
     */
    public var rangingBeaconsDidFailForRegionWithError:
        Observable<(region: CLBeaconRegion, error: Error)> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate
            .locationManager(_:rangingBeaconsDidFailFor:withError:)))
            .map { a in
                let region = try castOrThrow(CLBeaconRegion.self, a[1])
                let error = try castOrThrow(Error.self, a[2])
                return (region: region, error: error)
        }
    }
    
    
    // MARK: Responding to Visit Events
    
    /**
     Reactive wrapper for `delegate` message.
     */
    @available(iOS 8.0, *)
    public var didVisit: Observable<CLVisit> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate
            .locationManager(_:didVisit:)))
            .map { a in
                return try castOrThrow(CLVisit.self, a[1])
        }
    }
    
    #endif
    
    public var didChangeAuthorizationStatus: Observable<CLAuthorizationStatus> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate
            .locationManager(_:didChangeAuthorization:)))
            .map { a in
                let number = try castOrThrow(NSNumber.self, a[1])
                return CLAuthorizationStatus(rawValue: Int32(number.intValue))
                    ?? .notDetermined
        }
    }
    
   
}


fileprivate func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    
    return returnValue
}


fileprivate func castOptionalOrThrow<T>(_ resultType: T.Type,
                                        _ object: Any) throws -> T? {
    if NSNull().isEqual(object) {
        return nil
    }
    
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    
    return returnValue
}



//地理定位服务层
class ZSLocationManager {
    
    private let disposeBag = DisposeBag()

    //单例模式
    static let instance = ZSLocationManager()
    
    //定位权限序列
    private (set) var authorized: Driver<Bool>
    
    //经纬度信息序列
    private (set) var location: Driver<CLLocationCoordinate2D>
    
    //定位管理器
    private let locationManager = CLLocationManager()
    
    private var complete:((_ city: String, _ resultType: Int) -> ())?

    
    private init() {
        
        //更新距离
        locationManager.distanceFilter = 200000
        //设置定位精度
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        //获取定位权限序列
        authorized = Observable.deferred { [weak locationManager] in
            let status = CLLocationManager.authorizationStatus()
            guard let locationManager = locationManager else {
                return Observable.just(status)
            }
            return locationManager
                .rx.didChangeAuthorizationStatus
                .startWith(status)
            }
            .asDriver(onErrorJustReturn: CLAuthorizationStatus.notDetermined)
            .map {
                switch $0 {
                case .authorizedWhenInUse:
                    return true
                default:
                    return false
                }
        }
        
        
        //获取经纬度信息序列
        location = locationManager.rx.didUpdateLocations
            .asDriver(onErrorJustReturn: [])
            .flatMap {
                return $0.last.map(Driver.just) ?? Driver.empty()
            }
            .map { $0.coordinate }
    
        //发送授权申请
        locationManager.requestWhenInUseAuthorization()
        //允许使用定位服务的话，开启定位服务更新
        locationManager.startUpdatingLocation()

    }
    
    
    func locationCity(completion:@escaping (_ city: String, _ resultType: Int) -> ()) {
        complete = completion
        authorized.drive(onNext: {[weak self] (success) in
            if success {
                self?.loadLocation()
            }else{
                self?.complete!("定位权限未开启", 1)
            }
        }).disposed(by: disposeBag)
    }
    
    private func loadLocation() {
        ZSLocationManager.instance.location.asObservable().subscribe(onNext: {[weak self] (locaZd) in
//            self?.locationManager.stopUpdatingLocation()
            self?.locationGeocoding(cod: locaZd)
            }, onError: { [weak self](error) in
                if self?.complete != nil {
                    self?.complete!("定位失败", 2)
                }
        }).disposed(by: disposeBag)
    }
    
    private func locationGeocoding(cod: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder.init()
        let cl = CLLocation.init(latitude: cod.latitude, longitude: cod.longitude)
        geocoder.reverseGeocodeLocation(cl) {[weak self] (placemarks, error) in
            if (placemarks?.isEmpty == false) && (placemarks?.count)! > 0 {
                let placemark = placemarks?.first
                let cityName = ((placemark?.locality) != nil) ? placemark?.locality : placemark?.administrativeArea
                if self?.complete != nil {
                    self?.complete!(cityName!, 0)
                }
            }else{
                if self?.complete != nil {
                    self?.complete!("定位失败", 2)
                }
            }
        }
        
    }
    
    //跳转到应有偏好的设置页面
    private func openAppPreferences() {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        } else {
            // Fallback on earlier versions
        }
    }
}
