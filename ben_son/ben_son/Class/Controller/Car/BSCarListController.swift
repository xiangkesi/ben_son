
//
//  BSCarListController.swift
//  ben_son
//
//  Created by ZS on 2018/10/29.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BSCarListController: BSBaseController {

    private let viewModel = BSCarModelListsViewModel()
    let disposeBag = DisposeBag()

    var brandId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewPlainCommon.zHead.beginRefreshing()
    }
    
    override func setupUI() {
        super.setupUI()
        tableViewPlainCommon.height = UIDevice.current.contentNoTabBarHeight()
        tableViewPlainCommon.register(RSCarListCell.self, forCellReuseIdentifier: "RSCarListCell")
        tableViewPlainCommon.rowHeight = kScreenWidth * 0.7
        tableViewPlainCommon.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kSpacing))
        tableViewPlainCommon.backgroundView = placerView
        view.addSubview(tableViewPlainCommon)
        tableViewPlainCommon.zHead = BSRefreshHeader { [weak self] in
            self?.viewModel.request_publist.onNext((self?.brandId)!)
        }
        
        viewModel.result_publish.bind(to: tableViewPlainCommon.rx.items) { (tableView, row, element) in
            let cCell = tableView.dequeueReusableCell(withIdentifier: "RSCarListCell") as! RSCarListCell
            cCell.model = element
            return cCell
        }.disposed(by: disposeBag)
        
        viewModel.result_obser?.subscribe(onNext: {[weak self] (finish) in
            self?.tableViewPlainCommon.refreshStatus(status: BSRefreshStatus.DropDownSuccess)
            self?.placerView.showType(BSOrderPlacerType.orderPlacerTypeOther, finish, (self?.viewModel.cars.count)!)
            self?.viewModel.result_publish.onNext((self?.viewModel.cars)!)

        }).disposed(by: disposeBag)
        
        tableViewPlainCommon.rx.modelSelected(CarModel.self).subscribe {[weak self] (event) in
            let carDetailVc = BSCarDetailController()
            carDetailVc.car_id = (event.element?.carId)!
            self?.navigationController?.pushViewController(carDetailVc, animated: true)
            }.disposed(by: disposeBag)
        tableViewPlainCommon.rx.willDisplayCell.subscribe(onNext: {[weak self] (cell, indexPath) in
            cell.tableView((self?.tableViewPlainCommon)!, indexPath, UITableViewCellDisplayAnimationStyle.top)
        }).disposed(by: disposeBag)
    }
    
    private lazy var placerView: BSOrderPlacerView = {
        let placer = BSOrderPlacerView()
        placer.height = UIDevice.current.contentNoTabBarHeight()
        return placer
    }()

}
