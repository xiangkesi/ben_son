//
//  BSAddressListController.swift
//  ben_son
//
//  Created by ZS on 2018/9/26.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift

class BSAddressListController: BSBaseController {

    let disposeBag = DisposeBag()
    
    let viewModel = BSAddressListViewModel()
    
    let publish_sent = PublishSubject<String>()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewPlainCommon.zHead.beginRefreshing()
    }

    
    override func setupUI() {
        super.setupUI()
        title = "送车地址"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btnAddAddress)
        tableViewPlainCommon.height = UIDevice.current.contentNoTabBarHeight()
        tableViewPlainCommon.register(BSAddressListCell.self, forCellReuseIdentifier: "BSAddressListCell")
        tableViewPlainCommon.backgroundView = placerView
        tableViewPlainCommon.rowHeight = 84
        view.addSubview(tableViewPlainCommon)
        tableViewPlainCommon.zHead = BSRefreshHeader { [weak self] in
            self?.viewModel.publish_loaddata.onNext(1)
        }
        
        viewModel.publishAddress.bind(to: tableViewPlainCommon.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "BSAddressListCell") as! BSAddressListCell
                cell.address = element
                return cell
        }.disposed(by: disposeBag)
        
        //获取选中项的内容
        tableViewPlainCommon.rx.modelSelected(AddressList.self).subscribe(onNext: {[weak self] item in
            self?.publish_sent.onNext(item.address_final!)
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        tableViewPlainCommon.rx.modelDeleted(AddressList.self).subscribe(onNext: {[weak self] item in
            BSPromatView.show_prompt(Prompt_type.prompt_type_all, "是否确认删除?", (self?.navigationController?.view)!, complete: { (prompt) in
                self?.viewModel.delete_publish.onNext(item)
            })
            
        }).disposed(by: disposeBag)
        
        viewModel.delete_address_result?.subscribe(onNext: {[weak self] (finish) in
            if finish {
                self?.viewModel.publishAddress.onNext((self?.viewModel.address_lists)!)
            }
        }).disposed(by: disposeBag)
        
        btnAddAddress.rx.tap.subscribe(onNext: { [weak self] in
            let addAddressVc = BSAddAddressController()
            addAddressVc.publish_sent.subscribe(onNext: { (address) in
                self?.viewModel.address_lists.insert(address, at: 0)
                self?.viewModel.publishAddress.onNext((self?.viewModel.address_lists)!)
            }).disposed(by: addAddressVc.disposeBag)
            self?.navigationController?.pushViewController(addAddressVc, animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.address_list_result?.subscribe(onNext: {[weak self] (finish) in
            DispatchQueue.main.async(execute: {
                self?.tableViewPlainCommon.refreshStatus(status: BSRefreshStatus.DropDownSuccess)
                self?.viewModel.publishAddress.onNext((self?.viewModel.address_lists)!)
                self?.placerView.showType(BSOrderPlacerType.orderPlacerTypeOther, finish, (self?.viewModel.address_lists.count)!)
            })
        }).disposed(by: disposeBag)
        
        tableViewPlainCommon.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private lazy var placerView: BSOrderPlacerView = {
        let placer = BSOrderPlacerView()
        placer.height = UIDevice.current.contentNoTabBarHeight()
        return placer
    }()
    
    private lazy var btnAddAddress: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.size = CGSize(width: 50, height: 30)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn.setTitleColor(UIColor.white, for: UIControl.State.highlighted)
        btn.setTitle("新增地址", for: UIControl.State.normal)
        return btn
    }()
}

extension BSAddressListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.address_lists[indexPath.row].rowHeight
    }
    
}
