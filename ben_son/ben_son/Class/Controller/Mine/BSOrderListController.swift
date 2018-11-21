//
//  BSOrderListController.swift
//  ben_son
//
//  Created by ZS on 2018/10/24.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift

class BSOrderListController: BSBaseController {

    private let disposeBag = DisposeBag()
    
    let viewModel = BSOrderListViewModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()        
        viewModel.subjectSent.onNext("unfinished")
    }
    
    override func setupUI() {
        super.setupUI()
        title = "我的订单"
        tableViewPlainCommon.height = UIDevice.current.contentNoTabBarHeight() - headView.height
        tableViewPlainCommon.top = headView.bottom
        tableViewPlainCommon.register(BSOrderListCell.self, forCellReuseIdentifier: "BSOrderListCell")
        tableViewPlainCommon.rowHeight = 241
        tableViewPlainCommon.backgroundView = placerView
        view.addSubview(headView)
        view.addSubview(tableViewPlainCommon)
        
        //设置单元格数据（其实就是对 cellForRowAt 的封装）
        viewModel.result_orders.bind(to: tableViewPlainCommon.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "BSOrderListCell") as! BSOrderListCell
            cell.order_cell = element
            cell.click_pay = {[weak self] in
                let choosePay = BSChoosePayController()
                choosePay.msg = element
                self?.navigationController?.pushViewController(choosePay, animated: true)
            }
            return cell
        }.disposed(by: disposeBag)
        
        tableViewPlainCommon.rx.modelSelected(BSOrderModel.self).subscribe(onNext: {[weak self] item in
            let vc = BSOrderDetailController()
            vc.orderId = item.order_id
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
        headView.subClickBtn.subscribe(onNext: {[weak self] (status) in
            self?.viewModel.order_lists.removeAll()
            self?.viewModel.subjectSent.onNext(status)
        }).disposed(by: headView.disposeBag)
        
        viewModel.summitResult?.subscribe(onNext: {[weak self] (finish) in
            self?.placerView.showType(BSOrderPlacerType.orderPlacerTypeOrder, finish, (self?.viewModel.order_lists.count)!)
            self?.viewModel.result_orders.onNext((self?.viewModel.order_lists)!)
        }).disposed(by: viewModel.disposeBag)
        
    }
    private lazy var headView: BSOrderHeadView = {
        let head = BSOrderHeadView()
        head.origin = CGPoint(x: 0, y: 0)
        return head
    }()
    
    private lazy var placerView: BSOrderPlacerView = {
        let placer = BSOrderPlacerView()
        return placer
    }()
}
