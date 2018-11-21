//
//  BSCityListController.swift
//  ben_son
//
//  Created by ZS on 2018/9/21.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa


enum CitySectionItem {
    case TitleCurrentCity(title: String)
    case TitleHotCity(addressArray: [BSAddressColumn])
    case TitleCityList(address: BSAddressColumn)
}
class BSCityListController: BSBaseController {

    let disposeBag = DisposeBag()
    
    private let viewModel = BSCityListViewModel()
    
    let citySubject = PublishSubject<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadWebData {[weak self] (citys) in
            let a = self?.filterResult(data: SectionModel(model: "", items: citys))
            self?.searchView.bindResultCitys(items: a!)
        }
    }
    
    override func setupUI() {
        super.setupUI()
        title = "城市选择"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: buttonClose)
        tableViewPlainCommon.height = UIDevice.current.contentNoTabBarHeight() - headView.height
        tableViewPlainCommon.top = headView.height
        tableViewPlainCommon.register(BSAddressCell.self, forCellReuseIdentifier: "BSAddressCell")
        tableViewPlainCommon.register(BSAddressCurrentCell.self, forCellReuseIdentifier: "BSAddressCurrentCell")
        tableViewPlainCommon.register(BSAddressHotCell.self, forCellReuseIdentifier: "BSAddressHotCell")
        tableViewPlainCommon.register(BSAddressHeadView.self, forHeaderFooterViewReuseIdentifier: "BSAddressHeadView")
        tableViewPlainCommon.backgroundColor = UIColor.white
        tableViewPlainCommon.sectionIndexColor = kMainColor
        tableViewPlainCommon.sectionIndexBackgroundColor = UIColor.white
//        tableViewPlainCommon.tableHeaderView = headView
        view.addSubview(headView)
        view.addSubview(tableViewPlainCommon)
        view.addSubview(searchView)

        //创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String?, CitySectionItem>>(
            configureCell: { dataSource, tableView, indexPath, item in
                switch dataSource[indexPath] {
                case CitySectionItem.TitleCurrentCity(title: _):
                        let cell = tableView.dequeueReusableCell(withIdentifier: "BSAddressCurrentCell")
                        return cell!
                case let CitySectionItem.TitleHotCity(addressArray):
                    let cell = tableView.dequeueReusableCell(withIdentifier: "BSAddressHotCell") as! BSAddressHotCell
                        cell.addressModel = addressArray
                    cell.publishSubject.subscribe(onNext: {[weak self] (city) in
                        self?.citySubject.onNext(city)
                        self?.navigationController?.dismiss(animated: true, completion: nil)
                    }).disposed(by: cell.disposeBag)
                    return cell
                case let CitySectionItem.TitleCityList(address):
                    let cell = tableView.dequeueReusableCell(withIdentifier: "BSAddressCell") as! BSAddressCell
                    cell.cityMsg = address
                    cell.publishSubject.subscribe(onNext: {[weak self] (city) in
                        self?.citySubject.onNext(city)
                        self?.navigationController?.dismiss(animated: true, completion: nil)
                    }).disposed(by: cell.disposeBag)
                    return cell
                }
        })
        dataSource.sectionIndexTitles = {[weak self] (ds) in
            return self?.viewModel.sectionTitles
        }
        dataSource.sectionForSectionIndexTitle = {_, _, index in
            return index
        }


        viewModel.subjectCity.bind(to: tableViewPlainCommon.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableViewPlainCommon.rx.setDelegate(self).disposed(by: disposeBag)
        
        
        buttonClose.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        //不知道为什么会那么慢,难倒有线程阻塞,放弃使用
//        tableViewPlainCommon.rx.itemSelected
//            .map { [weak dataSource] indexPath in
//                return (indexPath, dataSource?[indexPath])
//            }.subscribe(onNext: {[weak self] (indexPath, item) in
//                if item == nil {return}
//                switch item! {
//                case let CitySectionItem.TitleCityList(address):
//                    self?.citySubject.onNext(address.cityName!)
//                    self?.navigationController?.dismiss(animated: true, completion: nil)
//                break
//                default:
//                    break
//                }
//            }).disposed(by: disposeBag)
        
        searchView.publishSublic.subscribe(onNext: {[weak self] (city) in
            self?.citySubject.onNext(city)
            self?.navigationController?.dismiss(animated: true, completion: nil)
        }).disposed(by: searchView.disposeBag)
//        searchBar.rx.text.orEmpty.asObservable().subscribe(onNext: { [weak self] in
//            let text = $0
////            if text.count > 0 && self?.searchView.isHidden == true {
////                self?.searchView.isHidden = false
////                return
////            }
////            if text.count <= 0 && self?.searchView.isHidden == false {
////                self?.searchV

    }
    
    
    private lazy var buttonClose: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.size = CGSize(width: 30, height: 30)
        btn.origin = CGPoint(x: 10, y: UIDevice.current.isX() ? 51 : 27)
        btn.setImage(UIImage(named: "common_close"), for: UIControl.State.normal)
        btn.setImage(UIImage(named: "common_close"), for: UIControl.State.highlighted)
        return btn
    }()
    

    
    private lazy var headView: UIView = {
        let head = UIView()
        head.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: searchBar.height)
        head.addSubview(searchBar)
        head.backgroundColor = UIColor.white
        return head
    }()
    
    
    private lazy var searchBar: UISearchBar = {
        let search = UISearchBar(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 50))
        search.delegate = self
        search.barStyle = .default
        search.placeholder = "输入您要搜索的内容"
        search.tintColor = kMainColor
        let searchField = search.value(forKey: "searchField")
        if let _ = searchField, let textField = searchField as? UITextField {
//            textField.backgroundColor = UIColor.colorWidthHexString(hex: "999999")
            textField.font = UIFont.systemFont(ofSize: 15)
            textField.textColor = UIColor.colorWidthHexString(hex: "333333")

        }
//        if #available(iOS 11.0, *) {
//            search.heightAnchor.constraint(equalToConstant: 44).isActive = true
//        }
//        search.sizeToFit()
        
        return search
    }()
    
    private lazy var searchView: BSSearchCityView = {
        let viewSearch = BSSearchCityView()
        viewSearch.top = headView.bottom
        viewSearch.isHidden = true
        return viewSearch
    }()
}

extension BSCityListController: UITableViewDelegate, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 { return 60 }
        return indexPath.section == 1 ? 105 : 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BSAddressHeadView")
        headView?.textLabel?.text = self.viewModel.sectionTitles[section]
        return headView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchView.isHidden = true
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        searchView.isHidden = false
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
    

    
    func filterResult(data: SectionModel<String, String>) -> Observable<[SectionModel<String, String>]>{
        return searchBar.rx.text.orEmpty.flatMapLatest{
                query -> Observable<[SectionModel<String, String>]> in
                if query.isEmpty{
                    return Observable.just([])
                }
                else{
                    var newData:[SectionModel<String, String>] = []
                    let items = data.items.filter{ "\($0)".contains(query) }
                    newData.append(SectionModel(model: "", items: items))
                    return Observable.just(newData)
                }
        }
    }
    
}
