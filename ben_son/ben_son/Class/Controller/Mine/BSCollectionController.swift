//
//  BSCollectionController.swift
//  ben_son
//
//  Created by ZS on 2018/9/20.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift

class BSCollectionController: BSBaseController {

    private let disposeBag = DisposeBag()

    private let viewModel = BSMineCollectionViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewPlainCommon.zHead.beginRefreshing()
    }
    
    override func setupUI() {
        super.setupUI()
        title = "我的收藏"
        tableViewPlainCommon.height = UIDevice.current.contentNoTabBarHeight()
        tableViewPlainCommon.register(BSCollectionCarCell.self, forCellReuseIdentifier: "BSCollectionCarCell")
        tableViewPlainCommon.rowHeight = kScreenWidth * 0.35
        tableViewPlainCommon.backgroundView = placerView
        tableViewPlainCommon.zHead = BSRefreshHeader { [weak self] in
            self?.viewModel.loadData.onNext(1)
        }
        view.addSubview(tableViewPlainCommon)

        viewModel.publishResult.bind(to: tableViewPlainCommon.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "BSCollectionCarCell") as! BSCollectionCarCell
            cell.car = element
            cell.buttonDelete.rx.tap.asDriver().drive(onNext: { [weak self] in
                BSPromatView.show_prompt(Prompt_type.prompt_type_all, "是否确认删除收藏?", (self?.navigationController?.view)!, complete: { (prompt) in
                    RSProgressHUD.showWindowesLoading(view: self?.view, titleStr: "删除中...")
                    self?.viewModel.signingIn.onNext(element)
                })
               
            }).disposed(by: cell.disposeBag)
            return cell
        }.disposed(by: viewModel.disposeBag)
        
        viewModel.resultNews?.subscribe(onNext: {[weak self] (finish) in
            self?.tableViewPlainCommon.refreshStatus(status: BSRefreshStatus.DropDownSuccess)
            self?.placerView.showType(BSOrderPlacerType.orderPlacerTypeOther, finish, (self?.viewModel.collectionCars.count)!)
            self?.viewModel.publishResult.onNext((self?.viewModel.collectionCars)!)
        }).disposed(by: viewModel.disposeBag)
        
        tableViewPlainCommon.rx.modelSelected(CarModel.self).subscribe(onNext: {[weak self] item in
            let carDetailVc = BSCarDetailController()
            carDetailVc.car_id = item.carId
            self?.navigationController?.pushViewController(carDetailVc, animated: true)
        }).disposed(by: disposeBag)
        
        tableViewPlainCommon.rx.willDisplayCell.subscribe(onNext: {[weak self] (cell, indexPath) in
            cell.tableView((self?.tableViewPlainCommon)!, indexPath, UITableViewCellDisplayAnimationStyle.bottomTogether)
        }).disposed(by: disposeBag)
        
        viewModel.signupResult?.subscribe(onNext: {[weak self] (finish) in
            if finish {
                self?.viewModel.loadData.onNext(100)
                RSProgressHUD.hideHUDQueryHUD(view: (self?.view)!)
            }
        }).disposed(by: viewModel.disposeBag)
        
        
        
    }
    
    private lazy var placerView: BSOrderPlacerView = {
        let placer = BSOrderPlacerView()
        placer.height = UIDevice.current.contentNoTabBarHeight()
        return placer
    }()
    

}
