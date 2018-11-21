//
//  BSSearchController.swift
//  ben_son
//
//  Created by ZS on 2018/9/21.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift

class BSSearchController: BSBaseController {

    let disposeBag = DisposeBag()
    
    let viewModel = BSSearchViewModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.hotSearchLoadData.onNext(1)
    }
    
    override func setupUI() {
        super.setupUI()
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
     
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
        tableViewPlainCommon.height = UIDevice.current.contentNoTabBarHeight()
        tableViewPlainCommon.rowHeight = 50
        tableViewPlainCommon.register(BSSearchCarPromatCell.self, forCellReuseIdentifier: "BSSearchCarPromatCell")
        tableViewPlainCommon.tableHeaderView = labelTitle
        view.addSubview(tableViewPlainCommon)
        view.addSubview(searchCarView)
        searchBar.rx.text.orEmpty.asObservable().subscribe(onNext: { [weak self] in
            let text = $0
            if text.count > 0 && self?.searchCarView.isHidden == true {
                self?.searchCarView.isHidden = false
                return
            }
            if text.count <= 0 && self?.searchCarView.isHidden == false {
                self?.searchCarView.isHidden = true
            }
            self?.viewModel.result_cars.removeAll()
            self?.viewModel.publish_cars.onNext((self?.viewModel.result_cars)!)
        }).disposed(by: disposeBag)
//

        
        viewModel.hotSearchList!.bind(to: tableViewPlainCommon.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "BSSearchCarPromatCell") as! BSSearchCarPromatCell
            cell.keywords = element
            return cell
        }.disposed(by: disposeBag)
        
        tableViewPlainCommon.rx.modelSelected(SearchHot_keyword.self).subscribe(onNext: {[weak self] item in
            if item.keyword == nil { return }
            self?.searchBar.resignFirstResponder()
            self?.searchBar.text = item.keyword
            self?.searchCarView.isHidden = false
            self?.viewModel.searchLoadData.onNext(item.keyword!)
        }).disposed(by: disposeBag)

        viewModel.searchResult?.subscribe(onNext: {[weak self] (finish) in
            self?.viewModel.publish_cars.onNext((self?.viewModel.result_cars)!)
        }).disposed(by: viewModel.disposeBag)
        
        viewModel.publish_cars.bind(to: searchCarView.tableViewCarList.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "BSSearchCarCell") as! BSSearchCarCell
            cell.car = element
            return cell
        }.disposed(by: viewModel.disposeBag)
        
        searchCarView.tableViewCarList.rx.modelSelected(CarModel.self).subscribe(onNext: {[weak self] item in
            let carDetailVc = BSCarDetailController()
            carDetailVc.car_id = (item.carId)
            self?.navigationController?.pushViewController(carDetailVc, animated: true)
        }).disposed(by: disposeBag)
    }
    
    
    private lazy var searchCarView: BSSearchCarView = {
        let search = BSSearchCarView()
        search.isHidden = true
        return search
    }()
    
    private lazy var searchBar: ZSSearchBar = {
        let search = ZSSearchBar.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth - 200, height: 30))
        search.tintColor = UIColor.colorWidthHexString(hex: "999999")
        search.showsCancelButton = true
        search.delegate = self
        search.barStyle = .default
        search.placeholder = "输入您要搜索的车型"
        search.contentInset = UIEdgeInsets(top: 7, left: 15, bottom: 7, right: 80)
        let searchField = search.value(forKey: "searchField")
        if let _ = searchField, let textField = searchField as? UITextField {
            textField.backgroundColor = UIColor.colorWidthHexString(hex: "333333")
            textField.font = UIFont.systemFont(ofSize: 15)
            textField.textColor = UIColor.white
        }
        if #available(iOS 11.0, *) {
            search.heightAnchor.constraint(equalToConstant: 44).isActive = true
        } 
        return search
    }()
    
    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 50)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.colorWidthHexString(hex: "5C5C5C")
        label.text = "     热门搜索"
        return label
    }()
}

extension BSSearchController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.popViewController(animated: false)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.searchLoadData.onNext(searchBar.text!)
        
    }
    
}
