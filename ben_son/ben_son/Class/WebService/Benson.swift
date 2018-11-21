//
//  Benson.swift
//  ben_son
//
//  Created by ZS on 2018/8/28.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxCocoa
import FDFullscreenPopGesture

let kScreenWidth = UIScreen.main.bounds.size.width

let kScreenHeight = UIScreen.main.bounds.size.height

let kRootVc = UIApplication.shared.keyWindow?.rootViewController

let kSpacing: CGFloat = 15.0

let kContentWidth = kScreenWidth - kSpacing * 2


let kMainColor = UIColor.colorWidthHexString(hex: "A98054")

let kMainBackBgColor = UIColor.colorWidthHexString(hex: "141414")

let ben_son_number = "400643099"

let image_placholder = UIImage(named: "image_placholder")

let head_image_placholder = UIImage(named: "placer_head")

public let line_color = "322A21"

public let news_detail_url = "https://m-benson-car.raykart.com/news-details/index.html?id="

public let mine_about_url = "https://m-benson-car.raykart.com/about-us/index.html"

/// 打印
///
/// - Parameters:
///   - message: 输出信息
///   - file: 文件名
///   - funcName: 函数名
///   - lineNum: 行数
func BSLog<T>(_ message : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("\n>>> \(Date())  \(fileName) (line: \(lineNum)): \(message)\n")
    #endif
}


//DispatchQueue.global().async {
//    print("处理耗时任务\(Thread.current)")
//    Thread.sleep(forTimeInterval: 2.0)
//    let arrayD:[String] = ["小王","校长","小李"]
//
//    DispatchQueue.main.async(execute: {
//        print("主线程更新UI \(Thread.current)")
//        complection(arrayD,100)
//    })
//}
//DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.4) {
//
//    self.scrollViewDidEndDecelerating(self.adScrollView)
//
//}

//perform(#selector(scrollViewDidEndDecelerating), with: self, afterDelay: 0.4)



//获取被取消选中项的索引
//        tableViewPlainCommon.rx.itemDeselected.subscribe({ [weak self] indexPath in
//            BSLog("被取消选中项的indexPath为：\(indexPath)")
//        }).disposed(by: disposeBag)
//
//        //获取被取消选中项的内容
//        tableViewPlainCommon.rx.modelDeselected(String.self).subscribe({[weak self] item in
//            BSLog("被取消选中项的的标题为：\(item)")
//        }).disposed(by: disposeBag)


//获取删除项的索引
//        tableViewPlainCommon.rx.itemDeleted.subscribe(onNext: { [weak self] indexPath in
//            BSLog("删除项的indexPath为：\(indexPath)")
//        }).disposed(by: disposeBag)
//
//        //获取删除项的内容
//        tableViewPlainCommon.rx.modelDeleted(String.self).subscribe(onNext: {[weak self] item in
//            BSLog("删除项的的标题为：\(item)")
//        }).disposed(by: disposeBag)


//获取移动项的索引
//tableViewPlainCommon.rx.itemMoved.subscribe(onNext: { [weak self]
//    sourceIndexPath, destinationIndexPath in
//    BSLog("移动项原来的indexPath为：\(sourceIndexPath)")
//    BSLog("移动项现在的indexPath为：\(destinationIndexPath)")
//}).disposed(by: disposeBag)
