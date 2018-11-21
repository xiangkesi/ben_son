//
//  BSMesgCenterController.swift
//  ben_son
//
//  Created by ZS on 2018/10/17.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift
class BSMesgCenterController: BSBaseController {

    private let disposeBag = DisposeBag()

    let viewModel = BSMsgCenterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.publish_load.onNext(1)
    }
    
    override func setupUI() {
        super.setupUI()
        title = "消息中心"
        tableViewPlainCommon.height = UIDevice.current.contentNoTabBarHeight()
        tableViewPlainCommon.rowHeight = 88
        tableViewPlainCommon.register(BSMsgCenterCell.self, forCellReuseIdentifier: "BSMsgCenterCell")
        view.addSubview(tableViewPlainCommon)
        
        //设置单元格数据（其实就是对 cellForRowAt 的封装）
        viewModel.publish_data.bind(to: tableViewPlainCommon.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "BSMsgCenterCell") as! BSMsgCenterCell
                cell.list = element
                return cell
        }.disposed(by: disposeBag)
   
        tableViewPlainCommon.rx.modelSelected(BSMsgCenterList.self).subscribe(onNext: {[weak self] item in
            item.is_read = 1
            self?.viewModel.publish_data.onNext((self?.viewModel.msg_lists)!)
            let detailVc = BSSysterMsgDetailcontroller()
            detailVc.msg_id = item.msgId
            self?.navigationController?.pushViewController(detailVc, animated: true)
            }).disposed(by: disposeBag)
        tableViewPlainCommon.rx.willDisplayCell.subscribe(onNext: {[weak self] (cell, indexPath) in
            cell.tableView((self?.tableViewPlainCommon)!, indexPath, UITableViewCellDisplayAnimationStyle.top)
        }).disposed(by: disposeBag)
        viewModel.result_list!.subscribe(onNext: {[weak self] (finish) in
            if finish {
                self?.viewModel.publish_data.onNext((self?.viewModel.msg_lists)!)
            }
        }).disposed(by: disposeBag)
        
    }

}
