//
//  BSDiscoverController.swift
//  ben_son
//
//  Created by ZS on 2018/8/28.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BSDiscoverController: BSBaseController {
    let disposeBag = DisposeBag()

    let viewModel = DiscoverViewModel.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.loadData.onNext(1)
        viewModel.load_mine_user.onNext(1)
    }
    override func setupUI() {
        super.setupUI()
        fd_prefersNavigationBarHidden = true
        view.addSubview(collectionView)
        view.addSubview(placerHolderView)
        
        viewModel.result?.subscribe(onNext: {[weak self] (model) in
            if model != nil {
                self?.viewModel.activeLists = (model?.activeLists)!
                self?.viewModel.customeLists = (model?.customerLists)!
                self?.viewModel.msg = model?.msgModel
                self?.collectionView.reloadData()
                self?.placerHolderView.stopAnimation()
            }else {
                self?.placerHolderView.netError()
            }
        }).disposed(by: viewModel.disposeBag)
        
        viewModel.result_user_msg?.subscribe(onNext: {[weak self] (finish) in
            if finish {
                self?.collectionView.reloadData()
            }
        }).disposed(by: viewModel.disposeBag)
        
        placerHolderView.click_subject.subscribe(onNext: {[weak self] (finish) in
            self?.viewModel.loadData.onNext(1)
        }).disposed(by: placerHolderView.disposeBag)
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collection = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collection.origin = CGPoint(x: 0, y: 0)
        collection.size = CGSize(width: kScreenWidth, height: UIDevice.current.contentNoNavHeight())
        collection.register(BSDiscoverMemberHeadView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "BSDiscoverMemberHeadView")
        collection.register(BSDiscoverActiveCell.self, forCellWithReuseIdentifier: "BSDiscoverActiveCell")
//        collection.register(BSDiscoverCommonHeadView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "BSDiscoverCommonHeadView")
//        collection.register(BSDiscoverShopCell.self, forCellWithReuseIdentifier: "BSDiscoverShopCell")
        collection.register(BSDiscoverCustomerHeadView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "BSDiscoverCustomerHeadView")
        collection.register(BSDiscoverCustomerCell.self, forCellWithReuseIdentifier: "BSDiscoverCustomerCell")
        collection.delegate = self
        collection.dataSource = self
        if #available(iOS 11.0, *) {
            collection.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        collection.backgroundColor = kMainBackBgColor
        return collection
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if AccountManager.shareManager().isLogin {
            viewModel.load_mine_user.onNext(1)
        }else {
            
        }
    }
    
    private lazy var placerHolderView: RSPlacerHolderView = {
        let holderView = RSPlacerHolderView()
        holderView.startAnimal()
        return holderView
    }()
}


extension BSDiscoverController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.activeLists.count
        default:
            return viewModel.customeLists.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
             let cCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BSDiscoverActiveCell", for: indexPath) as! BSDiscoverActiveCell
                cCell.active = viewModel.activeLists[indexPath.item]
             return cCell
//        case 1:
//            let cCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BSDiscoverShopCell", for: indexPath)
//            return cCell
        default:
            let cCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BSDiscoverCustomerCell", for: indexPath) as! BSDiscoverCustomerCell
            cCell.cuetome = viewModel.customeLists[indexPath.item]
            return cCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: kScreenWidth, height: 120)
//        case 1:
//            return CGSize(width: shopCellWidth, height: shopCellWidth + 30)
        default:
            return CGSize(width: customercellWidth, height: customercellHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return CGSize(width: kScreenWidth, height: memberHeadViewHeight)
//        case 1:
//            return CGSize(width: kScreenWidth, height: 80)
        default:
            return CGSize(width: kScreenWidth, height: 270)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        

        switch indexPath.section {
        case 0:
            let headView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "BSDiscoverMemberHeadView", for: indexPath) as! BSDiscoverMemberHeadView
            headView.login_user = viewModel.login_user
            headView.complcote = { [weak self] (type) in
                switch type {
                case 100:
                    if !AccountManager.shareManager().isLogin {
                        AccountManager.shareManager().showLoginController()
                        return
                    }
                    break
                case 200:
                    let newsListVc = BSNewsListController()
                    newsListVc.title = "本森活动"
                    self?.navigationController?.pushViewController(newsListVc, animated: true)
                    break
                case 300:
                    let vc = BSConsultingController()
                    let nav = BSNavgationController.init(rootViewController: vc)
                    self?.present(nav, animated: true, completion: nil)
                    break
                default:
                    let webVc = RSCommonWebController()
                    webVc.requestUrl = mine_about_url
                    self?.navigationController?.pushViewController(webVc, animated: true)
                    break
                }
            
            }
            return headView
//        case 1:
//            let headView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "BSDiscoverCommonHeadView", for: indexPath)
//            return headView
        default:
            let headView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "BSDiscoverCustomerHeadView", for: indexPath) as! BSDiscoverCustomerHeadView
            headView.complete = { [weak self] in
                let VC = BSCustomerController()
                VC.models = self?.viewModel.customeLists
                self?.navigationController?.pushViewController(VC, animated: true)
            }
            return headView
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var newsId = ""
        switch indexPath.section {
        case 0:
            let model = viewModel.activeLists[indexPath.item]
            newsId = String(model.activeId)
        default:
            let model = viewModel.customeLists[indexPath.item]
            if model.customerId == 0 {return}
            newsId = String(model.customerId)
        }
        let webVc = RSCommonWebController()
        webVc.requestUrl = news_detail_url + newsId
        navigationController?.pushViewController(webVc, animated: true)

    }
    
    
}
