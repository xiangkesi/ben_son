//
//  BSMyMemberController.swift
//  ben_son
//
//  Created by ZS on 2018/10/25.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BSMyMemberController: BSBaseController {
    
    let disposeBag = DisposeBag()
    
    var viewModel = BSMemberIntroViewModel()
    
    var user: Login_user? {
        didSet {
            headView.user = user
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        fd_prefersNavigationBarHidden = true
        view.addSubview(collectionMember)
        collectionMember.addSubview(headView)
        view.addSubview(btnBack)
        //设置单元格数据（其实就是对 cellForItemAt 的封装）
        viewModel.subjectCard.bind(to: collectionMember.rx.items) { (collectionView, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BSMemberIntroCell",for: indexPath) as! BSMemberIntroCell
            cell.intro = element
            return cell
            }.disposed(by: disposeBag)
        btnBack.rx.tap.subscribe(onNext: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        if user?.level == 1 {
            viewModel.subjectCard.onNext(viewModel.arrayNormalCardList)
        }else if user?.level == 2 {
            viewModel.subjectCard.onNext(viewModel.arrayGoldCardList)
        }else {
            viewModel.subjectCard.onNext(viewModel.arrayBlackCardList)
        }
    }

    private lazy var headView: MyMemberIntroHeadView = {
        let head = MyMemberIntroHeadView()
        head.top = -head.height
        return head
    }()
    
    private lazy var btnBack: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "common_back"), for: .normal)
        btn.setImage(UIImage(named: "common_back"), for: .selected)
        btn.bounds.size = CGSize(width: 50, height: 30)
        btn.contentHorizontalAlignment = .left
        btn.imageView?.isUserInteractionEnabled = false
        btn.origin = CGPoint(x: 15, y: UIDevice.current.navigationSubviewY() - 7)
        return btn
    }()
    
    private lazy var collectionMember: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: kScreenWidth * 0.5, height: kScreenWidth * 0.4)
        let collection = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collection.size = CGSize(width: kScreenWidth, height: kScreenHeight)
        collection.origin = CGPoint(x: 0, y: 0)
        collection.register(BSMemberIntroCell.self, forCellWithReuseIdentifier: "BSMemberIntroCell")
        collection.alwaysBounceVertical = true
        if #available(iOS 11.0, *) {
            collection.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        collection.contentInset = UIEdgeInsets(top: headView.height, left: 0, bottom: 0, right: 0)
        return collection
    }()

}
