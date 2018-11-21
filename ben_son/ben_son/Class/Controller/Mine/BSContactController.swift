//
//  BScontactController.swift
//  ben_son
//
//  Created by ZS on 2018/9/20.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class BSContactController: BSBaseController {

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupUI() {
        super.setupUI()
        fd_prefersNavigationBarHidden = true
        tableViewPlainCommon.height = kScreenHeight
        tableViewPlainCommon.register(BSContactCell.self, forCellReuseIdentifier: "BSContactCell")
        tableViewPlainCommon.rowHeight = 56
        tableViewPlainCommon.tableHeaderView = headView
        tableViewPlainCommon.tableFooterView = footView
        view.addSubview(tableViewPlainCommon)
        view.addSubview(navView)
        let  head = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        head.backgroundColor = kMainBackBgColor
        tableViewPlainCommon.backgroundView = head
        let items = Observable.just(creatDicArray())
        
        items.bind(to: tableViewPlainCommon.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "BSContactCell") as! BSContactCell
            cell.dic = element
            return cell
        }.disposed(by: disposeBag)
        
        navView.buttonBack.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    private lazy var headView: BSContactHeadView = {
        let headView = BSContactHeadView()
        headView.origin = CGPoint(x: 0, y: 0)
        return headView
    }()
    
    private lazy var footView: BSContactFootView = {
        let foot = BSContactFootView()
        foot.origin = CGPoint(x: 0, y: 0)
        return foot
    }()
    
    private lazy var navView: BSCommonNavView = {
        let nav = BSCommonNavView()
        nav.origin = CGPoint(x: 0, y: 0)
        return nav
    }()
    
    
    func creatDicArray() -> [[String: String]] {
        return [["icon":"contact_cooperation","title":"商务合作","desc":"021-34979796"],
                ["icon":"contact_mail","title":"电子信箱","desc":"bensonkang@benson-car.com"],
                ["icon":"contact_website","title":"官方网站","desc":"www.benson-car.com"]]
    }
}
