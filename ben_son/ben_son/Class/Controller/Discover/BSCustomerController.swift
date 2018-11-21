//
//  BSCustomerController.swift
//  ben_son
//
//  Created by ZS on 2018/11/7.
//  Copyright © 2018 ZS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BSCustomerController: BSBaseController {

    let subject_customer = PublishSubject<[CustomerListModel]>()
    let disposeBag = DisposeBag()
    var layout_item: UICollectionViewFlowLayout?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        subject_customer.onNext(models!)
    }

    var models: [CustomerListModel]? {
        didSet {
        }
    }
    
    override func setupUI() {
        super.setupUI()
        title = "合作客户"
        view.addSubview(collectionView)
        
        subject_customer.bind(to: collectionView.rx.items) { (collectionView, row, element) in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BSDiscoverCustomerCell", for: indexPath) as! BSDiscoverCustomerCell
                cell.cuetome = element
                return cell
            }.disposed(by: disposeBag)
        
        headView.subject_headview.subscribe(onNext: {[weak self] (height) in
            self?.layout_item!.sectionInset = UIEdgeInsets(top: height, left: 15, bottom: 15, right: 15)
        }).disposed(by: disposeBag)
    }
    

    private lazy var headView: CustomerHeadView = {
        let head = CustomerHeadView()
        return head
    }()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout_item = layout
        layout.itemSize = CGSize(width: customercellWidth, height: customercellHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collection = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collection.origin = CGPoint(x: 0, y: 0)
        collection.size = CGSize(width: kScreenWidth, height: UIDevice.current.contentNoTabBarHeight())
//        collection.register(BSDiscoverCustomerHeadView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "BSDiscoverCustomerHeadView")
        collection.register(BSDiscoverCustomerCell.self, forCellWithReuseIdentifier: "BSDiscoverCustomerCell")
        if #available(iOS 11.0, *) {
            collection.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        collection.addSubview(headView)
        layout.sectionInset = UIEdgeInsets(top: headView.height, left: 15, bottom: 15, right: 15)
        return collection
    }()
}
