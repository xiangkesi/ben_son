//
//  BSHomeController.swift
//  ben_son
//
//  Created by ZS on 2018/8/28.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift

class BSHomeController: BSBaseController {
    let disposeBag = DisposeBag()

    let viewHomeModel = RSHomeViewModel.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewPlainCommon.zHead.beginRefreshing()
    }
    
    override func setupUI() {
        super.setupUI()
        fd_prefersNavigationBarHidden = true
        tableViewPlainCommon.register(BSNewsCell.self, forCellReuseIdentifier: "BSNewsCell")
        tableViewPlainCommon.height = UIDevice.current.contentNoNavHeight()
        tableViewPlainCommon.rowHeight = kScreenWidth * 0.6 + 20
        tableViewPlainCommon.tableHeaderView = headView
        tableViewPlainCommon.zHead = BSRefreshHeader { [weak self] in
            self?.viewHomeModel.loadWebData()
        }
        tableViewPlainCommon.zFoot = BSRefreshFooter {[weak self] in
            self?.viewHomeModel.loadMoreData()
        }
        view.addSubview(tableViewPlainCommon)
        view.addSubview(navView)
        headView.bindViewModel(viewModel: viewHomeModel)
        
        viewHomeModel.recommendedResult?.subscribe(onNext: { (home) in
        }).disposed(by: viewHomeModel.disposeBag)
        viewHomeModel.resultNews!.bind(to: tableViewPlainCommon.rx.items) { (tableView, row, element) in
            let cCell = tableView.dequeueReusableCell(withIdentifier: "BSNewsCell") as! BSNewsCell
            cCell.news = element
            return cCell
        }.disposed(by: viewHomeModel.disposeBag)
        
        viewHomeModel.refreshStatus.asObservable().subscribe {[weak self] (status) in
            self?.tableViewPlainCommon.refreshStatus(status: status.element!)
        }.disposed(by: viewHomeModel.disposeBag)
        
        tableViewPlainCommon.rx.modelSelected(BSNews.self).subscribe {[weak self] (event) in
            if let newId = event.element?.newsId {
                let webVc = RSCommonWebController()
                webVc.isShouldShare = true
                webVc.requestUrl = news_detail_url + String(newId)
                self?.navigationController?.pushViewController(webVc, animated: true)
            }
        }.disposed(by: viewHomeModel.disposeBag)
        
        tableViewPlainCommon.rx.observe(CGPoint.self, "contentOffset").subscribe(onNext: {[weak self] (offset) in
            var detail = (offset?.y)! / (UIDevice.current.navigationBarHeight()) - 1
            detail = CGFloat.maximum(detail, 0)
            self?.navView.backgroundColor = UIColor.init(white: 0, alpha: CGFloat.minimum(detail, 1))
        }).disposed(by: viewHomeModel.disposeBag)
        
        navView.buttonSearch.rx.tap.subscribe(onNext: {[weak self] in
            let searchVc = BSSearchController()
            self?.navigationController?.pushViewController(searchVc, animated: false)
        }).disposed(by: navView.disposeBag)

        navView.msgViewTap!.rx.event.subscribe(onNext: {[weak self] (tap) in
            let msgVc = BSMesgCenterController()
            self?.navigationController?.pushViewController(msgVc, animated: true)
        }).disposed(by: navView.disposeBag)
        navView.viewLocationTap!.rx.event.subscribe(onNext: {[weak self] (tap) in
            let searchVc = BSCityListController()
            searchVc.citySubject.subscribe(onNext: { (city) in
                self?.navView.locationString = city + "市"
            }).disposed(by: searchVc.disposeBag)
            let nav = BSNavgationController.init(rootViewController: searchVc)
            self?.present(nav, animated: true, completion: nil)
        }).disposed(by: navView.disposeBag)
        
        headView.subjectBtnClick.subscribe(onNext: {[weak self] (index) in
            switch index {
                case 100:
                    let hostingVc = BSHostingController()
                    self?.navigationController?.pushViewController(hostingVc, animated: true)
                    break
                case 101:
                    let newsVc = BSNewsListController()
                    newsVc.title = "本森活动"
                    self?.navigationController?.pushViewController(newsVc, animated: true)
                    break
                case 102:
                    let newsVc = BSNewsListController()
                    newsVc.title = "本森头条"
                    self?.navigationController?.pushViewController(newsVc, animated: true)
                    break
                case 103:
                    let introVc = BSMemberIntroController()
                    self?.navigationController?.pushViewController(introVc, animated: true)
                    break
                case 104:
                    BSLog(4)

                    break
                case 105:
                    BSLog(5)
                    break
                default:
                    let carListVc = BSCarController()
                    carListVc.isHome = true
                    self?.navigationController?.pushViewController(carListVc, animated: true)
                    break
            }
        }).disposed(by: headView.disposed)
        headView.subjectClickBrand.subscribe(onNext: {[weak self] (brand) in
            let carListVc = BSCarListController()
            carListVc.title = brand.name
            carListVc.brandId = brand.brandId
            self?.animationTransfer()
            self?.navigationController?.pushViewController(carListVc, animated: false)
            
        }).disposed(by: headView.disposed)
        headView.subjectClickCar.subscribe(onNext: {[weak self] (car) in
            let carDetailVc = BSCarDetailController()
            carDetailVc.car_id = car.carId
            self?.animationTransfer()
            self?.navigationController?.pushViewController(carDetailVc, animated: false)
        }).disposed(by: headView.disposed)
        headView.subjectBanderClick.subscribe(onNext: {[weak self] (bander) in
            let webVc = RSCommonWebController()
            webVc.requestUrl = news_detail_url + String(bander.banderId)
            self?.navigationController?.pushViewController(webVc, animated: true)
            
        }).disposed(by: headView.disposed)
        
        ZSLocationManager.instance.locationCity {[weak self] (city, result) in
            if result == 0 {
                self?.navView.locationString = city
            }
        }
        }
    
    private func animationTransfer() {
        let transition = CATransition()
        transition.type = CATransitionType(rawValue: "rippleEffect")
//        transition.subtype = CATransitionSubtype.fromBottom
        transition.isRemovedOnCompletion = true
        transition.duration = 1.0
        tabBarController?.view.layer.add(transition, forKey: nil)
    }
    private lazy var headView: BSHomeHeadView = {
        let head = BSHomeHeadView()
        return head
    }()
    private lazy var navView: RSHomeNavView = {
        let nav = RSHomeNavView()
        nav.locationString = "上海市"
        return nav
    }()

}
