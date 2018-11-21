//
//  BSMemberIntroController.swift
//  ben_son
//
//  Created by ZS on 2018/10/25.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa
class BSMemberIntroController: BSBaseController {

    let disposeBag = DisposeBag()

    var viewModel = BSMemberIntroViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func setupUI() {
        super.setupUI()
        title = "本森会员"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "placer_head"), style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        view.addSubview(memberIntroView)
        view.addSubview(collectionMember)
        
        //设置单元格数据（其实就是对 cellForItemAt 的封装）
        viewModel.subjectCard.bind(to: collectionMember.rx.items) { (collectionView, row, element) in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BSMemberIntroCell",for: indexPath) as! BSMemberIntroCell
                cell.intro = element
                return cell
            }.disposed(by: disposeBag)
        
        
        navigationItem.rightBarButtonItem?.rx.tap.subscribe(onNext: {[weak self] in
            let rulesVc = BSMemberRulesController()
            self?.navigationController?.pushViewController(rulesVc, animated: true)
        }).disposed(by: disposeBag)
        memberIntroView.btnClick.subscribe(onNext: {[weak self] (index) in
            switch index {
            case 0:
                self?.viewModel.subjectCard.onNext((self?.viewModel.arrayGoldCardList)!)
                break
            case 1:
                self?.viewModel.subjectCard.onNext((self?.viewModel.arrayBlackCardList)!)
                break
            default:
                self?.viewModel.subjectCard.onNext((self?.viewModel.arrayNormalCardList)!)
                break
            }
        }).disposed(by: memberIntroView.disposeBag)
        
    
        
        viewModel.subjectCard.onNext(viewModel.arrayGoldCardList)
    }
    
    private lazy var memberIntroView: BSMemberIntroView = {
        let member = BSMemberIntroView()
        member.origin = CGPoint(x: 0, y: 0)
        return member
    }()
    
    private lazy var collectionMember: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: kScreenWidth * 0.5, height: kScreenWidth * 0.4)
        let collection = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collection.size = CGSize(width: kScreenWidth, height: UIDevice.current.contentNoTabBarHeight() - memberIntroView.height)
        collection.origin = CGPoint(x: 0, y: memberIntroView.bottom)
        collection.register(BSMemberIntroCell.self, forCellWithReuseIdentifier: "BSMemberIntroCell")
        collection.backgroundColor = UIColor.colorWidthHexString(hex: "141414")
        collection.alwaysBounceVertical = true
        return collection
    }()

}
