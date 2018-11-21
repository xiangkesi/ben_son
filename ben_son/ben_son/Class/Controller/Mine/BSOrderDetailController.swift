//
//  BSOrderDetailController.swift
//  ben_son
//
//  Created by ZS on 2018/11/8.
//  Copyright © 2018 ZS. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BSOrderDetailController: BSBaseController {

    let disposeBag = DisposeBag()
    
    let viewModel = BSOrderDetailViewModel()
    
    var orderId: Int = 0
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.publish_loadData.onNext(orderId)
    }
    
    override func setupUI() {
        super.setupUI()
        title = "订单详情"
        tableViewPlainCommon.height = UIDevice.current.contentNoTabBarHeight() - bottomView.height
        tableViewPlainCommon.backgroundColor = UIColor.colorWidthHexString(hex: "111111")
        tableViewPlainCommon.register(BSOrderDetailCell.self, forCellReuseIdentifier: "BSOrderDetailCell_ID")
        tableViewPlainCommon.rowHeight = 35
        tableViewPlainCommon.tableHeaderView = headView
        tableViewPlainCommon.tableFooterView = viewFooter
        view.addSubview(tableViewPlainCommon)
        view.addSubview(bottomView)
        view.addSubview(placerHolderView)
        viewModel.publish_msgs.bind(to: tableViewPlainCommon.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "BSOrderDetailCell_ID") as! BSOrderDetailCell
                cell.order = element
            return cell
        }.disposed(by: disposeBag)
        viewModel.result_data?.subscribe(onNext: {[weak self] (finish) in
                DispatchQueue.main.async(execute: {
                    if finish {
                        self?.headView.order = self?.viewModel.orderMsg
                        self?.bottomView.order = self?.viewModel.orderMsg
                        self?.viewModel.sent_signal()
                        self?.placerHolderView.showType(finish)
                    }
                })
        }).disposed(by: disposeBag)
        
        placerHolderView.click_subject.subscribe(onNext: {[weak self] (finish) in
            self?.viewModel.publish_loadData.onNext((self?.orderId)!)
        }).disposed(by: placerHolderView.disposeBag)
        bottomView.btnClick.rx.tap.subscribe(onNext: { [weak self] in
            let choosePay = BSChoosePayController()
            choosePay.msg = self?.viewModel.orderMsg
            self?.navigationController?.pushViewController(choosePay, animated: true)
        }).disposed(by: disposeBag)
        headView.btnLeft.rx.tap.subscribe(onNext: { [weak self] in
            let detailVc = RSCommonWebController()
            detailVc.requestUrl = "http://p.qiao.baidu.com/cps2/chatIndex?reqParam=%7B%22from%22%3A0%2C%22sessionid%22%3A%22%22%2C%22siteId%22%3A%226109277%22%2C%22tid%22%3A%22-1%22%2C%22userId%22%3A%225643636%22%2C%22ttype%22%3A1%2C%22siteConfig%22%3A%7B%22eid%22%3A%225643636%22%2C%22queuing%22%3A%22%22%2C%22session%22%3A%7B%22displayName%22%3A%221**6%22%2C%22headUrl%22%3A%22https%3A%2F%2Fss0.bdstatic.com%2F7Ls0a8Sm1A5BphGlnYG%2Fsys%2Fportraitn%2Fitem%2F15881097.jpg%22%2C%22status%22%3A0%2C%22uid%22%3A0%2C%22uname%22%3A%22%22%7D%2C%22siteId%22%3A%226109277%22%2C%22online%22%3A%22true%22%2C%22webRoot%22%3A%22%2F%2Fp.qiao.baidu.com%2Fcps2%2F%22%2C%22bid%22%3A%222534443029061092770%22%2C%22userId%22%3A%225643636%22%2C%22invited%22%3A0%7D%2C%22config%22%3A%7B%22themeColor%22%3A%22000000%22%7D%7D&from=singlemessage&isappinstalled=0"
            self?.navigationController?.pushViewController(detailVc, animated: true)
        }).disposed(by: disposeBag)
        
        headView.btnRight.rx.tap.subscribe(onNext: {
            BSTool.callPhone(phone: ben_son_number)
        }).disposed(by: disposeBag)
    }
    
    private lazy var headView: BSOrderDetailHeadView = {
        let head = BSOrderDetailHeadView()
        return head
    }()
    
    private lazy var bottomView: BSOrderDetailBottomView = {
        let bottom = BSOrderDetailBottomView()
        bottom.origin = CGPoint(x: 0, y: UIDevice.current.contentNoTabBarHeight() - bottom.height)
        return bottom
    }()
    
    private lazy var viewFooter: UIView = {
        let bg = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 20))
        bg.backgroundColor = kMainBackBgColor
        return bg
    }()

    private lazy var placerHolderView: RSPlacerHolderView = {
        let holderView = RSPlacerHolderView()
        holderView.startAnimal()
        return holderView
    }()
}
