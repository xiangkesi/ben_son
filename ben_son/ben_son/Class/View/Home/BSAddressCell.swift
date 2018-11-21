//
//  BSAddressCell.swift
//  ben_son
//
//  Created by ZS on 2018/9/25.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class BSAddressCell: BSCommentCell {

    var disposeBag = DisposeBag()
    
    let publishSubject = PublishSubject<String>()


    override func setupUI() {
        super.setupUI()
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(labelCityTitle)
        line.top = 43
        line.backgroundColor = UIColor.colorWidthHexString(hex: "E6E6E6").cgColor
        contentView.layer.addSublayer(line)
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickCell))
        contentView.addGestureRecognizer(tap)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    
    @objc func clickCell() {
        if labelCityTitle.text == nil {return}
        publishSubject.onNext((labelCityTitle.text!))
    }
    var cityMsg: BSAddressColumn? {
        didSet {
            labelCityTitle.text = cityMsg?.cityName
        }
    }
    
    
    lazy var labelCityTitle: UILabel = {
        let cityName = UILabel()
        cityName.size = CGSize(width: 200, height: 30)
        cityName.top = 7
        cityName.left = kSpacing
        cityName.font = UIFont.systemFont(ofSize: 15)
        return cityName
    }()
}

class BSAddressCurrentCell: BSCommentCell {
    
    let disposeBag = DisposeBag()
    
    override func setupUI() {
        super.setupUI()
        contentView.backgroundColor = UIColor.colorWidthHexString(hex: "F5F5F5")
        contentView.addSubview(buttonLocation)
        contentView.addSubview(buttonTapLocation)
    
        
 
        buttonTapLocation.rx.tap.subscribe(onNext: {[weak self] in
            self?.buttonTapLocation.isEnabled = false
            self?.locationAddress()
        }).disposed(by: disposeBag)
        buttonLocation.rx.tap.subscribe(onNext: {
            
        }).disposed(by: disposeBag)
        locationAddress()
    }
    
    
    private func locationAddress() {
        ZSLocationManager.instance.locationCity {[weak self] (city, result) in
            self?.buttonLocation.isEnabled = (result == 0 ? true : false)
            self?.buttonLocation.setTitle(city, for: UIControl.State.normal)
            self?.buttonLocation.sizeToFit()
            self?.buttonLocation.width = (self?.buttonLocation.width)! + 20
            self?.buttonTapLocation.left = (self?.buttonLocation.right)! + 20
            self?.buttonTapLocation.isEnabled = true

        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        disposeBag = DisposeBag()
    }
    
    private lazy var buttonLocation: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.size = CGSize(width: (kScreenWidth - 75) * 0.33, height: 30)
        btn.left = kSpacing
        btn.top = 10
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitle("定位中...", for: UIControl.State.normal)
//        btn.zs_cutCornerAndBorder(sizeHeigt: CGSize(width: 3, height: 3), boderColor: UIColor.colorWidthHexString(hex: "E1E1E1"))
        btn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        btn.backgroundColor = UIColor.white
        return btn
    }()
    
    private lazy var buttonTapLocation: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.size = CGSize(width: 80, height: 30)
        btn.left = buttonLocation.right + 20
        btn.top = 10
        btn.setTitle("重新定位", for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        return btn
    }()
}

class BSAddressHotCell: BSCommentCell {
    
    
    
    let publishSubject = PublishSubject<String>()
    
    var disposeBag = DisposeBag()

    private var btnArray = [UIButton]()
    
    override func setupUI() {
        super.setupUI()
        contentView.backgroundColor = UIColor.colorWidthHexString(hex: "F5F5F5")
        creatBtn()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    var addressModel:[BSAddressColumn]? {
        didSet{
            if addressModel != nil {
                for (index, model) in addressModel!.enumerated() {
                    if index < btnArray.count {
                        btnArray[index].setTitle(model.cityName, for: UIControl.State.normal)
                    }
                }
            }
        }
    }
    
    @objc func clickHotCity(btn: UIButton) {
        publishSubject.onNext(btn.currentTitle!)
    }
    
    private func creatBtn() {
        let btnWidth = (kScreenWidth - 75) * 0.33
        for index in 0...3 {
            let btn = UIButton(type: UIButton.ButtonType.custom)
            btn.size = CGSize(width: btnWidth, height: 30)
            btn.left = kSpacing + CGFloat(index % 3) * (btnWidth + kSpacing)
            btn.top = kSpacing + CGFloat(Int(index / 3)) * 45
            btn.zs_cutCornerAndBorder(sizeHeigt: CGSize(width: 3, height: 3), boderColor: UIColor.colorWidthHexString(hex: "E1E1E1"))
            btn.setTitleColor(UIColor.black, for: UIControl.State.normal)
            btn.backgroundColor = UIColor.white
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            btnArray.append(btn)
            contentView.addSubview(btn)
            btn.addTarget(self, action: #selector(clickHotCity(btn:)), for: UIControl.Event.touchUpInside)
            
        }
    }
}


class BSAddressHeadView: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.colorWidthHexString(hex: "F5F5F5")
        contentView.addSubview(labelTitle)
    }
    
    lazy var labelTitle: UILabel = {
        let titleLabel = UILabel.init()
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.size = CGSize(width: 100, height: 30)
        titleLabel.origin = CGPoint(x: kSpacing, y: 0)
        titleLabel.textColor = UIColor.colorWidthHexString(hex: "737373")
        return titleLabel
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class BSSearchCityView: UIView {
    
    
    let publishSublic = PublishSubject<String>()
    
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: UIDevice.current.contentNoTabBarHeight())
        super.init(frame: selfFrame)
        setupUI()
    }
    
    func bindResultCitys(items: Observable<[SectionModel<String, String>]>) {
        
        //创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource
            <SectionModel<String, String>>(configureCell: {
                (dataSource, tv, indexPath, element) in
                let cell = tv.dequeueReusableCell(withIdentifier: "BSAddressCell") as! BSAddressCell
                cell.labelCityTitle.text = element
                cell.publishSubject.subscribe(onNext: {[weak self] (city) in
                    self?.publishSublic.onNext(city)
                }).disposed(by: cell.disposeBag)
                return cell
            })
        
        //绑定单元格数据
        items.bind(to: tableViewCityList.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
//        tableViewCityList.rx.itemSelected
//            .map { [weak dataSource] indexPath in
//                return (indexPath, dataSource?[indexPath])
//            }.subscribe(onNext: {[weak self] (indexPath, item) in
//                if item == nil {return}
//                self?.publishSublic.onNext(item!)
//            }).disposed(by: disposeBag)
    }
    
    private func setupUI() {
        backgroundColor = UIColor.white
        addSubview(tableViewCityList)
        //设置单元格数据（其实就是对 cellForRowAt 的封装）
        

    }
    
    private lazy var tableViewCityList: UITableView = {
        let carList = UITableView.init(frame: frame, style: UITableView.Style.plain)
        carList.rowHeight = 44
        carList.register(BSAddressCell.self, forCellReuseIdentifier: "BSAddressCell")
        carList.separatorStyle = .none
        return carList
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
