//
//  BSNewsListController.swift
//  ben_son
//
//  Created by ZS on 2018/10/18.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift
class BSNewsListController: BSBaseController {

    var type: String?
    
    let viewModel = BSNewsListViewModel.init()
    let disposeBag = DisposeBag()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewPlainCommon.zHead.beginRefreshing()
    }
    
    override func setupUI() {
        super.setupUI()
        tableViewPlainCommon.register(BSNewsCell.self, forCellReuseIdentifier: "BSNewsCell")
        tableViewPlainCommon.height = UIDevice.current.contentNoTabBarHeight()
        tableViewPlainCommon.rowHeight = kScreenWidth * 0.6 + 20
        tableViewPlainCommon.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 10))
        tableViewPlainCommon.zHead = BSRefreshHeader { [weak self] in
            self?.viewModel.loadWebData(type: 0)
        }
        tableViewPlainCommon.zFoot = BSRefreshFooter {[weak self] in
            self?.viewModel.loadWebData()
        }
        view.addSubview(tableViewPlainCommon)
       
        
        viewModel.resultNews!.bind(to: tableViewPlainCommon.rx.items) { (tableView, row, element) in
            let cCell = tableView.dequeueReusableCell(withIdentifier: "BSNewsCell") as! BSNewsCell
            cCell.news = element
            return cCell
        }.disposed(by: viewModel.disposeBag)
        
        viewModel.refreshStatus.asObservable().subscribe {[weak self] (status) in
            self?.tableViewPlainCommon.refreshStatus(status: status.element!)
        }.disposed(by: viewModel.disposeBag)
        
        tableViewPlainCommon.rx.modelSelected(BSNews.self).subscribe {[weak self] (event) in
            if let newId = event.element?.newsId {
                let webVc = RSCommonWebController()
                webVc.requestUrl = news_detail_url + String(newId)
                self?.navigationController?.pushViewController(webVc, animated: true)
            }
        }.disposed(by: disposeBag)
        
        
        //获取选中项的索引
        tableViewPlainCommon.rx.willDisplayCell.subscribe(onNext: {[weak self] (cell, indexPath) in
            cell.tableView((self?.tableViewPlainCommon)!, indexPath, UITableViewCellDisplayAnimationStyle.bottom)
        }).disposed(by: disposeBag)

        
    }
    
}
