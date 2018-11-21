//
//  BSSysterMsgDetailcontroller.swift
//  ben_son
//
//  Created by ZS on 2018/11/15.
//  Copyright © 2018 ZS. All rights reserved.
//

import UIKit
import RxSwift

class BSSysterMsgDetailcontroller: UIViewController {

    var msg_id: Int = 0
    
    let viewModel = BSMsgDetailViewModel()
    private let disposeBag = DisposeBag()

    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var labelTime: UILabel!
   
    
    @IBOutlet weak var labelDetail: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        
        viewModel.result_Detail?.subscribe(onNext: {[weak self] (finish) in
            if finish {
                self?.labelTitle.text = self?.viewModel.detailMsg?.title
                self?.labelTime.text = self?.viewModel.detailMsg?.created_at
                self?.labelDetail.text = self?.viewModel.detailMsg?.content
            }
            self?.placerHolderView.showType(finish)

        }).disposed(by: disposeBag)
        
        placerHolderView.click_subject.subscribe(onNext: {[weak self] (finish) in
        self?.viewModel.publish_load.onNext((self?.msg_id)!)

        }).disposed(by: placerHolderView.disposeBag)
        
        viewModel.publish_load.onNext(msg_id)

    }
    
    private lazy var placerHolderView: RSPlacerHolderView = {
        let holderView = RSPlacerHolderView()
        holderView.startAnimal()
        return holderView
    }()

}

extension BSSysterMsgDetailcontroller {
    private func setupUI() {
        view.backgroundColor = UIColor.black
        title = "消息详情"
        view.addSubview(placerHolderView)
    }
}
