//
//  BSChoosePhoto.swift
//  ben_son
//
//  Created by ZS on 2018/9/22.
//  Copyright © 2018年 ZS. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

public class RxImagePickerDelegateProxy :
    DelegateProxy<UIImagePickerController,
    UIImagePickerControllerDelegate & UINavigationControllerDelegate>,
    DelegateProxyType,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate {
    
    public init(imagePicker: UIImagePickerController) {
        super.init(parentObject: imagePicker,
                   delegateProxy: RxImagePickerDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { RxImagePickerDelegateProxy(imagePicker: $0) }
    }
    
    public static func currentDelegate(for object: UIImagePickerController)
        -> (UIImagePickerControllerDelegate & UINavigationControllerDelegate)? {
            return object.delegate
    }
    
    public static func setCurrentDelegate(_ delegate: (UIImagePickerControllerDelegate
        & UINavigationControllerDelegate)?, to object: UIImagePickerController) {
        object.delegate = delegate
    }
    
    deinit {
    }
}

fileprivate func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    return returnValue
}

extension Reactive where Base: UIImagePickerController {
    
    public var pickerDelegate: DelegateProxy<UIImagePickerController,
        UIImagePickerControllerDelegate & UINavigationControllerDelegate > {
        return RxImagePickerDelegateProxy.proxy(for: base)
    }
    
    public var didFinishPickingMediaWithInfo: Observable<[String : AnyObject]> {
        
        return pickerDelegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate
                .imagePickerController(_:didFinishPickingMediaWithInfo:)))
            .map({ (a) in
                return try castOrThrow(Dictionary<String, AnyObject>.self, a[1])
            })
    }

    public var didCancel: Observable<()> {
        return pickerDelegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate
                .imagePickerControllerDidCancel(_:)))
            .map {_ in () }
    }
}


func dismissViewController(_ viewController: UIViewController, animated: Bool) {
    if viewController.isBeingDismissed || viewController.isBeingPresented {
        DispatchQueue.main.async {
            dismissViewController(viewController, animated: animated)
        }
        return
    }
    
    if viewController.presentingViewController != nil {
        viewController.dismiss(animated: animated, completion: nil)
    }
}

extension Reactive where Base: UIImagePickerController {
    static func createWithParent(_ parent: UIViewController?,
                                 animated: Bool = true,
                                 configureImagePicker: @escaping (UIImagePickerController) throws -> () = { x in })
        -> Observable<UIImagePickerController> {
            
            return Observable.create { [weak parent] observer in
                
                let imagePicker = UIImagePickerController()
                
                let dismissDisposable = Observable.merge(
                    imagePicker.rx.didFinishPickingMediaWithInfo.map{_ in ()},
                    imagePicker.rx.didCancel
                    )
                    .subscribe(onNext: {  _ in
                        observer.on(.completed)
                    })
                
                do {
                    try configureImagePicker(imagePicker)
                }
                catch let error {
                    observer.on(.error(error))
                    return Disposables.create()
                }
                
                guard let parent = parent else {
                    observer.on(.completed)
                    return Disposables.create()
                }
                
                parent.present(imagePicker, animated: animated, completion: nil)
                observer.on(.next(imagePicker))
                
                return Disposables.create(dismissDisposable, Disposables.create {
                    dismissViewController(imagePicker, animated: animated)
                })
            }
    }
}
