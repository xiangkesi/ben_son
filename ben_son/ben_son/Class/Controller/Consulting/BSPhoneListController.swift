//
//  BSPhoneListController.swift
//  ben_son
//
//  Created by ZS on 2018/10/16.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class BSPhoneListController: BSBaseController {

    private let disposeBag = DisposeBag()
    
    private let viewModel = PhoneAddressViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        title = "全国门店客服"
        tableViewPlainCommon.height = UIDevice.current.contentNoTabBarHeight()
        tableViewPlainCommon.register(PhoneAddressCell.self, forCellReuseIdentifier: "PhoneAddressCell")
        tableViewPlainCommon.rowHeight = 76
        tableViewPlainCommon.tableHeaderView = headImageView
        tableViewPlainCommon.tableFooterView = footView
        view.addSubview(tableViewPlainCommon)
        
        //初始化数据
        viewModel.publish_result.bind(to: tableViewPlainCommon.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneAddressCell") as! PhoneAddressCell
            
            cell.btnCall.rx.tap.subscribe(onNext: {
                BSTool.callPhone(phone: element.phone)
            }).disposed(by: cell.disposeBag)
            cell.btnAddress.rx.tap.subscribe(onNext: {[weak self] in
                BSTool.toMapApp(vc: self!, latitude: Double(element.latitude ?? "0"), longitude: Double(element.longitude ?? "0"), destName: element.address)
            }).disposed(by: cell.disposeBag)
            cell.model = element
            return cell
            }.disposed(by: disposeBag)
        
        
        viewModel.result_singal?.subscribe(onNext: {[weak self] (finish) in
            if finish {
                self?.viewModel.publish_result.onNext((self?.viewModel.addresss)!)
            }
        }).disposed(by: disposeBag)
        viewModel.load_request.onNext(1)

    }
    
    private lazy var headImageView: UIImageView = {
        let head = UIImageView(image: UIImage(named: "phone_address_banner"))
        head.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth * 0.43)
        return head
    }()
    
    private lazy var footView: PhoneAddressFooterView = {
        let foot = PhoneAddressFooterView()
        return foot
    }()
    
    
}
