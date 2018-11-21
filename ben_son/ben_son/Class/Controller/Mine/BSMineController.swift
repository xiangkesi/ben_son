//
//  BSMineController.swift
//  ben_son
//
//  Created by ZS on 2018/8/28.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class BSMineController: UIViewController {

    let viewModel = BSMineViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if AccountManager.shareManager().isLogin {
            viewModel.loadData.onNext(1)
        }else{
            headView.login_user = nil
        }
    }
    
    private func setupUI() {
        fd_prefersNavigationBarHidden = true
        view.addSubview(tableViewPlainCommon)
        headView.subjectClickBtn.subscribe(onNext: {[weak self] (index) in
            if !AccountManager.shareManager().isLogin {
                AccountManager.shareManager().showLoginController()
                return
            }
            switch index {
            case 100:
                let flyerVc = BSFlyerController()
                flyerVc.score = self?.viewModel.login_user?.score
                self?.navigationController?.pushViewController(flyerVc, animated: true)
                break
            case 101:
                let walterVc = BSMineWalletController()
                walterVc.score = self?.viewModel.login_user?.score
                self?.navigationController?.pushViewController(walterVc, animated: true)
                break
            case 102:
                let memberVc = BSMyMemberController()
                memberVc.user = self?.viewModel.login_user
                self?.navigationController?.pushViewController(memberVc, animated: true)
                break
            case 1000:
                AccountManager.shareManager().showLoginController()
                break
            default:
                let orderVc = BSOrderListController()
                self?.navigationController?.pushViewController(orderVc, animated: true)
                break
                
            }
        }).disposed(by: headView.disposeBag)
        
        viewModel.result?.subscribe(onNext: {[weak self] (finish) in
            self?.tableViewPlainCommon.refreshStatus(status: .DropDownSuccess)
            if finish {
                self?.headView.login_user = self?.viewModel.login_user
            }
        }).disposed(by: viewModel.disposeBag)
        
  
    }
    
    private lazy var headView: BSMineHeadView = {
        let head = BSMineHeadView()
        return head
    }()
    
    lazy var tableViewPlainCommon: UITableView = {
        let tableView = UITableView.init(frame: CGRect(), style: UITableView.Style.grouped)
        tableView.separatorStyle = .none
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
            tableView.estimatedRowHeight = 0;
            tableView.estimatedSectionFooterHeight = 0;
            tableView.estimatedSectionHeaderHeight = 0;
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.origin = CGPoint(x: 0, y: 0)
        tableView.size = CGSize(width: kScreenWidth, height:UIDevice.current.contentNoNavHeight())
        
        tableView.register(BSMineCell.self, forCellReuseIdentifier: "BSMineCell")
        tableView.rowHeight = 62
        tableView.tableHeaderView = headView
        tableView.backgroundColor = UIColor.colorWidthHexString(hex: "1A1A1A")
        tableView.zHead = BSRefreshHeader { [weak self] in
            if AccountManager.shareManager().isLogin {
                self?.viewModel.loadData.onNext(1)
                return
            }
            self?.tableViewPlainCommon.refreshStatus(status: .DropDownSuccess)
        }
        return tableView
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}

extension BSMineController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.dataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cCell = tableView.dequeueReusableCell(withIdentifier: "BSMineCell") as! BSMineCell
        cCell.title = viewModel.dataSource[indexPath.section][indexPath.row]["title"]
        return cCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = viewModel.dataSource[indexPath.section][indexPath.row]["type"]!
        switch type {
        case "1":
            let orderVc = StayTunedController()
            navigationController?.pushViewController(orderVc, animated: true)
            break
        case "2":
            if !AccountManager.shareManager().isLogin {
                AccountManager.shareManager().showLoginController()
                return
            }
            let feedbackVc = BSCollectionController()
            navigationController?.pushViewController(feedbackVc, animated: true)
            break
        case "3":
            let shareVc = BSShareController()
            navigationController?.pushViewController(shareVc, animated: true)
            break
        case "4":
            let webVc = RSCommonWebController()
            webVc.requestUrl = mine_about_url
            navigationController?.pushViewController(webVc, animated: true)
            break
        case "5":
            let feedbackVc = BSContactController()
            navigationController?.pushViewController(feedbackVc, animated: true)
            break
        case "6":
            let feedbackVc = BSFeedbackController()
            navigationController?.pushViewController(feedbackVc, animated: true)
            break
        case "7":
            if !AccountManager.shareManager().isLogin {
                AccountManager.shareManager().showLoginController()
                return
            }
            let setingVc = BSSettingController()
            setingVc.viewModel.login_user = viewModel.login_user
            navigationController?.pushViewController(setingVc, animated: true)
            break
        default:
            break
        }
        
    }
    
    
}
