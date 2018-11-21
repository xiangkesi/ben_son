//
//  RxSwiftStudyController.swift
//  ben_son
//
//  Created by ZS on 2018/9/12.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RxSwiftStudyController: UIViewController {
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        RxSwift5()
    }

}

extension RxSwiftStudyController {
    
//  3  Swift - RxSwift的使用详解3（Observable介绍、创建可观察序列）
//    1，Observable<T>
//    Observable<T> 这个类就是Rx 框架的基础，我们可以称它为可观察序列。它的作用就是可以异步地产生一系列的 Event（事件），即一个 Observable<T> 对象会随着时间推移不定期地发出 event(element : T) 这样一个东西。
//    而且这些 Event 还可以携带数据，它的泛型 <T> 就是用来指定这个Event携带的数据的类型。
//    有了可观察序列，我们还需要有一个Observer（订阅者）来订阅它，这样这个订阅者才能收到 Observable<T> 不时发出的 Event。

//    2，Event
//    查看 RxSwift 源码可以发现，事件 Event 的定义如下：
//    public enum Event<Element> {
//        /// Next element is produced.
//        case next(Element) next：next事件就是那个可以携带数据 <T> 的事件，可以说它就是一个“最正常”的事件。
//
//        /// Sequence terminated with an error.
//        case error(Swift.Error) error：error 事件表示一个错误，它可以携带具体的错误内容，一旦 Observable 发出了 error event，则这个 Observable 就等于终止了，以后它再也不会发出 event 事件了。
//
//        /// Sequence completed successfully. completed 事件表示Observable 发出的事件正常地结束了，跟 error 一样，一旦 Observable 发出了 completed event，则这个 Observable 就等于终止了，以后它再也不会发出 event 事件了。
//        case completed
//    }
    
//    四、创建 Observable 序列
//    我们可以通过如下几种方法来创建一个 Observable序列
    private func RxSwift3() {
//        1，just() 方法
//        （1）该方法通过传入一个默认值来初始化。
//
//        （2）下面样例我们显式地标注出了 observable 的类型为 Observable<Int>，即指定了这个 Observable所发出的事件携带的数据类型必须是 Int 类型的。
//        Observable<Int>.just(8).subscribe { (event) in
//            BSLog(event)
//        }.disposed(by: disposeBag)
        
//        2，of() 方法
//        （1）该方法可以接受可变数量的参数（必需要是同类型的）
//        （2）下面样例中我没有显式地声明出 Observable 的泛型类型，Swift 也会自动推断类型。
//        Observable.of("A","b","c").subscribe { (event) in
//            BSLog(event)
//        }.disposed(by: disposeBag)
        
//        3，from() 方法
//        （1）该方法需要一个数组参数。
//        （2）下面样例中数据里的元素就会被当做这个 Observable 所发出 event携带的数据内容，最终效果同上面饿 of()样例是一样的。
//        Observable.from(["a",1,"3"]).subscribe { (event) in
//            BSLog(event.element)
//        }.disposed(by: disposeBag)
        
//        4，empty() 方法
//        该方法创建一个空内容的 Observable 序列。
//
//        let observable = Observable<Int>.empty()
        
//        5，never() 方法
//        该方法创建一个永远不会发出 Event（也不会终止）的 Observable 序列。
//
//        let observable = Observable<Int>.never()
        
//        6，error() 方法
//        该方法创建一个不做任何操作，而是直接发送一个错误的 Observable 序列。
//
//        enum MyError: Error {
//            case A
//            case B
//        }
//        let observable = Observable<Int>.error(MyError.A)
        

//        7，range() 方法
//        （1）该方法通过指定起始和结束数值，创建一个以这个范围内所有值作为初始值的Observable序列。
//
//        （2）下面样例中，两种方法创建的 Observable 序列都是一样的。
//
//        //使用range()
//        let observable = Observable.range(start: 1, count: 5)
//
//        //使用of()
//        let observable = Observable.of(1, 2, 3 ,4 ,5)

        
//        8，repeatElement() 方法 慎重使用
//        该方法创建一个可以无限发出给定元素的 Event的 Observable 序列（永不终止）。
//        Observable.repeatElement(1).subscribe { (event) in
//            print(event)
//        }.disposed(by: disposeBag)
        
//        9，generate() 方法
//        （1）该方法创建一个只有当提供的所有的判断条件都为 true 的时候，才会给出动作的 Observable 序列。
//        （2）下面样例中，两种方法创建的 Observable 序列都是一样的。
//        //使用generate()方法
//        let observable = Observable.generate(
//            initialState: 0,
//            condition: { $0 <= 10 },
//            iterate: { $0 + 2 }
//        )
//        //使用of()方法
//        let observable = Observable.of(0 , 2 ,4 ,6 ,8 ,10)
        
//        10，create() 方法
//        （1）该方法接受一个 block 形式的参数，任务是对每一个过来的订阅进行处理。
//        （2）下面是一个简单的样例。为方便演示，这里增加了订阅相关代码（关于订阅我之后会详细介绍的）。
    
        //这个block有一个回调参数observer就是订阅这个Observable对象的订阅者
        //当一个订阅者订阅这个Observable对象的时候，就会将订阅者作为参数传入这个block来执行一些内容
//        let observable = Observable<String>.create{observer in
//            //对订阅者发出了.next事件，且携带了一个数据"hangge.com"
//            observer.onNext("hangge.com")
//            //对订阅者发出了.completed事件
//            observer.onCompleted()
//            //因为一个订阅行为会有一个Disposable类型的返回值，所以在结尾一定要returen一个Disposable
//            return Disposables.create()
//        }
//
//        //订阅测试
//        observable.subscribe {
//            print($0)
//        }.disposed(by: disposeBag)
        
        
//        11，deferred() 方法
//        （1）该个方法相当于是创建一个 Observable 工厂，通过传入一个 block 来执行延迟 Observable序列创建的行为，而这个 block 里就是真正的实例化序列对象的地方。
//
//        （2）下面是一个简单的演示样例：
        //用于标记是奇数、还是偶数
//        var isOdd = true
//
//        //使用deferred()方法延迟Observable序列的初始化，通过传入的block来实现Observable序列的初始化并且返回。
//        let factory : Observable<Int> = Observable.deferred {
//
//            //让每次执行这个block时候都会让奇、偶数进行交替
//            isOdd = !isOdd
//
//            //根据isOdd参数，决定创建并返回的是奇数Observable、还是偶数Observable
//            if isOdd {
//                return Observable.of(1, 3, 5 ,7)
//            }else {
//                return Observable.of(2, 4, 6, 8)
//            }
//        }
//
//        //第1次订阅测试
//        factory.subscribe { event in
//            print("\(isOdd)", event)
//        }.disposed(by: disposeBag)
//
//        //第2次订阅测试
//        factory.subscribe { event in
//            print("\(isOdd)", event)
//        }.disposed(by: disposeBag)
        
        
//        12，interval() 方法 类似定时器吧
//        （1）这个方法创建的 Observable 序列每隔一段设定的时间，会发出一个索引数的元素。而且它会一直发送下去。
//
//        （2）下面方法让其每 1 秒发送一次，并且是在主线程（MainScheduler）发送。
        
//        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
//        observable.subscribe { event in
//            print(event)
//        }.disposed(by: disposeBag)
        
        
//        13，timer() 方法,延时使用
//        （1）这个方法有两种用法，一种是创建的 Observable序列在经过设定的一段时间后，产生唯一的一个元素。
        //5秒种后发出唯一的一个元素0,只运行一次就结束了
//        let observable = Observable<Int>.timer(5, scheduler: MainScheduler.instance)
//        observable.subscribe { event in
//            print(event)
//        }.disposed(by: disposeBag)
//        （2）另一种是创建的 Observable 序列在经过设定的一段时间后，每隔一段时间产生一个元素。
        //延时5秒种后，每隔1秒钟发出一个元素
//        let observable = Observable<Int>.timer(5, period: 1, scheduler: MainScheduler.instance)
//        observable.subscribe { event in
//            print(event)
//        }.disposed(by: disposeBag)
        
    }
    
    
//    Swift - RxSwift的使用详解4（Observable订阅、事件监听、订阅销毁）
    private func RxSwift4() {
//        五、订阅 Observable
//        有了 Observable，我们还要使用 subscribe() 方法来订阅它，接收它发出的 Event。
//        第一种用法：
//        （1）我们使用 subscribe() 订阅了一个Observable 对象，该方法的 block 的回调参数就是被发出的 event 事件，我们将其直接打印出来。
//        let observable = Observable.of("A", "B", "C")
//        observable.subscribe { event in
//            print(event)
//        }.disposed(by: disposeBag)
        
//        第二种用法：
//        （1）RxSwift 还提供了另一个 subscribe方法，它可以把 event 进行分类：
//
//        通过不同的 block 回调处理不同类型的 event。（其中 onDisposed 表示订阅行为被 dispose 后的回调，这个我后面会说）
//        同时会把 event 携带的数据直接解包出来作为参数，方便我们使用。
  
//        let observable = Observable.of("A", "B", "C")
//
//        observable.subscribe(onNext: { element in
//            print(element)
//        }, onError: { error in
//            print(error)
//        }, onCompleted: {
//            print("completed")
//        }, onDisposed: {
//            print("disposed")
//        }).disposed(by: disposeBag)
//        2）subscribe() 方法的 onNext、onError、onCompleted 和 onDisposed 这四个回调 block 参数都是有默认值的，即它们都是可选的。所以我们也可以只处理 onNext而不管其他的情况。
        
        
//        六、监听事件的生命周期
//        1，doOn 介绍
//        （1）我们可以使用 doOn 方法来监听事件的生命周期，它会在每一次事件发送前被调用。
//
//        （2）同时它和 subscribe 一样，可以通过不同的block 回调处理不同类型的 event。比如：
//
//        do(onNext:)方法就是在subscribe(onNext:) 前调用
//        而 do(onCompleted:) 方法则会在 subscribe(onCompleted:) 前面调用。
        
//        2，使用样例
//        let observable = Observable.of("A", "B", "C")
//
//        observable
//            .do(onNext: { element in
//                print("Intercepted Next：", element)
//            }, onError: { error in
//                print("Intercepted Error：", error)
//            }, onCompleted: {
//                print("Intercepted Completed")
//            }, onDispose: {
//                print("Intercepted Disposed")
//            })
//            .subscribe(onNext: { element in
//                print(element)
//            }, onError: { error in
//                print(error)
//            }, onCompleted: {
//                print("completed")
//            }, onDisposed: {
//                print("disposed")
//            }).disposed(by: disposeBag)
//        七、Observable 的销毁（Dispose）
//        1，Observable 从创建到终结流程
//        （1）一个 Observable 序列被创建出来后它不会马上就开始被激活从而发出 Event，而是要等到它被某个人订阅了才会激活它。
//
//        （2）而 Observable 序列激活之后要一直等到它发出了.error或者 .completed的 event 后，它才被终结。
        
//        2，dispose() 方法
//        （1）使用该方法我们可以手动取消一个订阅行为。
//
//        （2）如果我们觉得这个订阅结束了不再需要了，就可以调用 dispose()方法把这个订阅给销毁掉，防止内存泄漏。
//
//        （3）当一个订阅行为被dispose 了，那么之后 observable 如果再发出 event，这个已经 dispose 的订阅就收不到消息了。下面是一个简单的使用样例。
        
//        let observable = Observable.of("A", "B", "C")
//
//        //使用subscription常量存储这个订阅方法
//        let subscription = observable.subscribe { event in
//            print(event)
//        }
//
//        //调用这个订阅的dispose()方法
//        subscription.dispose()
//        3，DisposeBag
//        （1）除了 dispose()方法之外，我们更经常用到的是一个叫 DisposeBag 的对象来管理多个订阅行为的销毁：
//
//        我们可以把一个 DisposeBag对象看成一个垃圾袋，把用过的订阅行为都放进去。
//        而这个DisposeBag 就会在自己快要dealloc 的时候，对它里面的所有订阅行为都调用  dispose()方法。
//        （2）下面是一个简单的使用样例
//        let disposeBag = DisposeBag()
//
//        //第1个Observable，及其订阅
//        let observable1 = Observable.of("A", "B", "C")
//        observable1.subscribe { event in
//            print(event)
//            }.disposed(by: disposeBag)
//
//        //第2个Observable，及其订阅
//        let observable2 = Observable.of(1, 2, 3)
//        observable2.subscribe { event in
//            print(event)
//            }.disposed(by: disposeBag)

    }
    
    
//    Swift - RxSwift的使用详解5（观察者1： AnyObserver、Binder）
//    一、观察者（Observer）介绍
//    观察者（Observer）的作用就是监听事件，然后对这个事件做出响应。或者说任何响应事件的行为都是观察者。比如：
//    当我们点击按钮，弹出一个提示框。那么这个“弹出一个提示框”就是观察者Observer<Void>
//    当我们请求一个远程的json 数据后，将其打印出来。那么这个“打印 json 数据”就是观察者 Observer<JSON>
    
//    二、直接在 subscribe、bind 方法中创建观察者
//    1，在 subscribe 方法中创建
//    1）创建观察者最直接的方法就是在 Observable 的 subscribe 方法后面描述当事件发生时，需要如何做出响应。
//
//    （2）比如下面的样例，观察者就是由后面的 onNext，onError，onCompleted 这些闭包构建出来的。
    private func RxSwift5() {
        
//        let observable = Observable.of("A", "B", "C")
//
//        observable.subscribe(onNext: { element in
//            print(element)
//        }, onError: { error in
//            print(error)
//        }, onCompleted: {
//            print("completed")
//        }).disposed(by: disposeBag)
        
        
//        2，在 bind 方法中创建
//        （1）下面代码我们创建一个定时生成索引数的 Observable 序列，并将索引数不断显示在 label 标签上：
        
//        let labelT = UILabel.init()
//        labelT.font = UIFont.systemFont(ofSize: 15)
//        labelT.textColor = UIColor.black
//        labelT.backgroundColor = UIColor.purple
//        labelT.frame = CGRect(x: 10, y: 100, width: 200, height: 20)
//        view.addSubview(labelT)
//        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
//        observable.map { (a) -> String in
//            return "当前索引数：\(a)"
//            }.bind { (text) in
//                labelT.text = text
//        }.disposed(by: disposeBag)
        
        
//        三、使用 AnyObserver 创建观察者
//        AnyObserver 可以用来描叙任意一种观察者。
//        1，配合 subscribe 方法使用
//        比如上面第一个样例我们可以改成如下代码：
        //观察者
//        let observer: AnyObserver<String> = AnyObserver { (event) in
//            switch event {
//            case .next(let data):
//                print(data)
//            case .error(let error):
//                print(error)
//            case .completed:
//                print("completed")
//            }
//        }
//
//        let observable = Observable.of("A", "B", "C")
//        observable.subscribe(observer).disposed(by: disposeBag)
        
//        2，配合 bindTo 方法使用
//        也可配合 Observable 的数据绑定方法（bindTo）使用。比如上面的第二个样例我可以改成如下代码：
        //观察者
//        let observer: AnyObserver<String> = AnyObserver { [weak self] (event) in
//            switch event {
//            case .next(let text):
//                //收到发出的索引数后显示到label上
//            default:
//                break
//            }
//        }
//
//        //Observable序列（每隔1秒钟发出一个索引数）
//        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
//        observable
//            .map { "当前索引数：\($0 )"}
//            .bind(to: observer)
//            .disposed(by: disposeBag)
        
        
//        四、使用 Binder 创建观察者
//        1，基本介绍
//        1）相较于AnyObserver 的大而全，Binder 更专注于特定的场景。Binder 主要有以下两个特征：
//        不会处理错误事件
//        确保绑定都是在给定 Scheduler 上执行（默认 MainScheduler）
//        （2）一旦产生错误事件，在调试环境下将执行 fatalError，在发布环境下将打印错误信息。
//        2，使用样例
//        1）在上面序列数显示样例中，label 标签的文字显示就是一个典型的 UI 观察者。它在响应事件时，只会处理 next 事件，而且更新 UI 的操作需要在主线程上执行。那么这种情况下更好的方案就是使用 Binder。
//        （2）上面的样例我们改用 Binder 会简单许多：
        //观察者
//        let observer: Binder<String> = Binder(label) { (view, text) in
//            //收到发出的索引数后显示到label上
//            view.text = text
//        }
//
//        //Observable序列（每隔1秒钟发出一个索引数）
//        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
//        observable
//            .map { "当前索引数：\($0 )"}
//            .bind(to: observer)
//            .disposed(by: disposeBag)
        
//                let labelT = UILabel.init()
//                labelT.font = UIFont.systemFont(ofSize: 15)
//                labelT.textColor = UIColor.black
//                labelT.backgroundColor = UIColor.purple
//                labelT.frame = CGRect(x: 10, y: 100, width: 200, height: 20)
//                view.addSubview(labelT)
        
        
        
//        Swift - RxSwift的使用详解6（观察者2： 自定义可绑定属性）
//        五、自定义可绑定属性
//        有时我们想让 UI 控件创建出来后默认就有一些观察者，而不必每次都为它们单独去创建观察者。比如我们想要让所有的 UIlabel 都有个 fontSize 可绑定属性，它会根据事件值自动改变标签的字体大小。
        
//        方式一：通过对 UI 类进行扩展
//        （1）这里我们通过对 UILabel 进行扩展，增加了一个fontSize 可绑定属性。
        //Observable序列（每隔0.5秒钟发出一个索引数）
//        let observable = Observable<Int>.interval(0.5, scheduler: MainScheduler.instance)
//        observable
//            .map { CGFloat($0) }
//            .bind(to: label.fontSize) //根据索引数不断变放大字体
//            .disposed(by: disposeBag)
//        extension UILabel {
//            public var fontSize: Binder<CGFloat> {
//                return Binder(self) { label, fontSize in
//                    label.font = UIFont.systemFont(ofSize: fontSize)
//                }
//            }
//        }
        
//       方式二：通过对 Reactive 类进行扩展
//        既然使用了 RxSwift，那么更规范的写法应该是对 Reactive 进行扩展。这里同样是给 UILabel 增加了一个 fontSize 可绑定属性。
//        （注意：这种方式下，我们绑定属性时要写成 label.rx.fontSize）
        //Observable序列（每隔0.5秒钟发出一个索引数）
//        let observable = Observable<Int>.interval(0.5, scheduler: MainScheduler.instance)
//        observable
//            .map { CGFloat($0) }
//            .bind(to: label.rx.fontSize) //根据索引数不断变放大字体
//            .disposed(by: disposeBag)
//        extension Reactive where Base: UILabel {
//            public var fontSize: Binder<CGFloat> {
//                return Binder(self.base) { label, fontSize in
//                    label.font = UIFont.systemFont(ofSize: fontSize)
//                }
//            }
//        }
        
        
//        六、RxSwift 自带的可绑定属性（UI 观察者）
//        1）其实 RxSwift 已经为我们提供许多常用的可绑定属性。比如 UILabel 就有 text 和 attributedText 这两个可绑定属性。
//        extension Reactive where Base: UILabel {
//            /// Bindable sink for `text` property.
//            public var text: Binder<String?> {
//                return Binder(self.base) { label, text in
//                    label.text = text
//                }
//            }
//            /// Bindable sink for `attributedText` property.
//            public var attributedText: Binder<NSAttributedString?> {
//                return Binder(self.base) { label, text in
//                    label.attributedText = text
//                }
//            }
//            
//        }
//        2）那么上文那个定时显示索引数的样例，我们其实不需要自定义 UI 观察者，直接使用 RxSwift 提供的绑定属性即可。
//        //Observable序列（每隔1秒钟发出一个索引数）
//        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
//        observable
//            .map { "当前索引数：\($0 )"}
//            .bind(to: label.rx.text) //收到发出的索引数后显示到label上
//            .disposed(by: disposeBag)


        
        //Observable序列（每隔1秒钟发出一个索引数）
//        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
//        observable
//            .map { "当前索引数：\($0 )"}
//            .bind(to: labelT.rx.text) //收到发出的索引数后显示到label上
//            .disposed(by: disposeBag)

    

    
    
    

 
    
    
    
    
    
    
    
    }
}
