//
//  BSFlyerController.swift
//  ben_son
//
//  Created by ZS on 2018/10/25.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift

class BSFlyerController: BSBaseController {

    private let disposeBag = DisposeBag()
    
    private let viewModel = BSFlyerViewModel()

    var score: Int? {
        didSet {
            headView.labelTitle.text = String(score ?? 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setupUI() {
        super.setupUI()
        fd_prefersNavigationBarHidden = true
        tableViewPlainCommon.height = kScreenHeight
        tableViewPlainCommon.rowHeight = 75
        tableViewPlainCommon.register(BSFlyerCell.self, forCellReuseIdentifier: "BSFlyerCell")
        tableViewPlainCommon.tableHeaderView = headView
        view.addSubview(tableViewPlainCommon)
        view.addSubview(navView)
        
        //设置单元格数据（其实就是对 cellForRowAt 的封装）
        viewModel.result_flays.bind(to: tableViewPlainCommon.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "BSFlyerCell") as! BSFlyerCell
            cell.list = element
            return cell
        }.disposed(by: disposeBag)
        
        
        navView.btnRules.rx.tap.subscribe(onNext: {[weak self] in
            let rulesVc = BSMemberRulesController()
            self?.navigationController?.pushViewController(rulesVc, animated: true)
        }).disposed(by: navView.disposeBag)
        navView.btnBack.rx.tap.subscribe(onNext: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: navView.disposeBag)
        
        viewModel.result_json?.subscribe(onNext: {[weak self] (finish) in
            if finish {
                self?.viewModel.result_flays.onNext((self?.viewModel.flyer_lists)!)
            }
        }).disposed(by: disposeBag)
        
        viewModel.publish_loadData.onNext(1)
    }
    
    private lazy var headView: BSFlyerHeadView = {
        let head = BSFlyerHeadView()
        
        return head
    }()
    
    private lazy var navView: BSFlyerNavView = {
        let nav = BSFlyerNavView()
        return nav
    }()

}
