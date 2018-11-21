//
//  BSCarController.swift
//  ben_son
//
//  Created by ZS on 2018/8/28.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift

class BSCarController: BSBaseController {

    
    let viewModel = BSCarViewModel.init()
    let disposeBag = DisposeBag()
    
    var isHome: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadData.onNext(200)
        viewModel.loadModelData.onNext((value: nil, type: 200))
    }
    
    override func setupUI() {
        super.setupUI()
        navigationItem.titleView = buttonSearch
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: buttonCall)
        tableViewPlainCommon.height = isHome ? UIDevice.current.contentNoTabBarHeight() : UIDevice.current.contentHeight()
        tableViewPlainCommon.register(RSCarListCell.self, forCellReuseIdentifier: "RSCarListCell")
        tableViewPlainCommon.tableHeaderView = headView
        tableViewPlainCommon.rowHeight = kScreenWidth * 0.7
        tableViewPlainCommon.zHead = BSRefreshHeader { [weak self] in
            self?.viewModel.loadData.onNext(300)
            self?.viewModel.loadModelData.onNext((value: nil, type: 300))

        }
        view.addSubview(tableViewPlainCommon)
        headView.setupViewModel(viewModel: viewModel)
        viewModel.resultCarModel!.bind(to: tableViewPlainCommon.rx.items) { (tableView, row, element) in
            let cCell = tableView.dequeueReusableCell(withIdentifier: "RSCarListCell") as! RSCarListCell
            cCell.model = element
            return cCell
        }.disposed(by: viewModel.disposeBag)
        
        viewModel.refreshStatus.asObservable().subscribe {[weak self] (status) in
            self?.tableViewPlainCommon.refreshStatus(status: status.element!)
        }.disposed(by: viewModel.disposeBag)
        viewModel.signingIn?.subscribe(onNext: {[weak self] (finish) in
            self?.viewModel.refreshStatus.value = BSRefreshStatus.DropDownSuccess
        }).disposed(by: viewModel.disposeBag)
        

        buttonSearch.rx.tap.subscribe(onNext: { [weak self] in
            let searchVc = BSSearchController()
            self?.navigationController?.pushViewController(searchVc, animated: false)
        }).disposed(by: disposeBag)
        
        buttonCall.rx.tap.subscribe(onNext: {
            BSTool.callPhone(phone: ben_son_number)
        }).disposed(by: disposeBag)
        
        tableViewPlainCommon.rx.modelSelected(CarModel.self).subscribe {[weak self] (event) in
            let carDetailVc = BSCarDetailController()
            carDetailVc.car_id = (event.element?.carId)!
            self?.navigationController?.pushViewController(carDetailVc, animated: true)
        }.disposed(by: disposeBag)
    }
    
    private lazy var headView: BSCarHeadView = {
        let head = BSCarHeadView()
        head.origin = CGPoint(x: 0, y: 0)
        return head
    }()
    
    private lazy var buttonSearch: UIButton = {
        let search = UIButton(type: UIButton.ButtonType.custom)
        search.backgroundColor = UIColor.colorWidthHexString(hex: "333333")
        search.contentHorizontalAlignment = .left
        search.origin = CGPoint(x: kSpacing, y: UIDevice.current.navigationSubviewY())
        search.size = CGSize(width: kScreenWidth - 70, height: 30)
        search.zs_corner()
        search.setTitleColor(UIColor.colorWidthHexString(hex: "666666"), for: UIControl.State.normal)
        search.setTitleColor(UIColor.colorWidthHexString(hex: "666666"), for: UIControl.State.highlighted)
        search.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        search.setImage(UIImage(named: "common_search"), for: UIControl.State.normal)
        search.setImage(UIImage(named: "common_search"), for: UIControl.State.highlighted)
        search.setTitle("搜索车型或者关键字", for: UIControl.State.normal)
        search.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        search.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        return search
    }()
    
    private lazy var buttonCall: UIButton = {
        let call = UIButton(type: UIButton.ButtonType.custom)
        call.size = CGSize(width: 30, height: 30)
        call.setImage(UIImage(named: "common_call"), for: UIControl.State.normal)
        return call
    }()

}
