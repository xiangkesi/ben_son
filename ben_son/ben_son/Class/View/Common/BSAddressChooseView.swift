//
//  BSAddressChooseView.swift
//  ben_son
//
//  Created by ZS on 2018/10/26.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import ObjectMapper
import RxSwift
import RxCocoa
class BSAddressChooseView: UIView {

    let subiectAddress = PublishSubject<[Province]>()
    private let disposeBag = DisposeBag()
    private var complete:((_ address: String) -> ())?

    var isChooseCity: Bool = false
    

    let param = AddressParam()
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        super.init(frame: selfFrame)
        setupUI()
    }
    
    private lazy var addressView: UIView = {
        let address = UIView()
        address.size = CGSize(width: kScreenWidth, height: kScreenHeight * 0.7)
        address.origin = CGPoint(x: 0, y: kScreenHeight)
        address.backgroundColor = UIColor.white
        return address
    }()
    
    private lazy var tableViewAddressList: UITableView = {
        let table = UITableView(frame: CGRect(), style: UITableView.Style.plain)
        table.origin = CGPoint(x: 0, y: addressHeadView.bottom)
        table.size = CGSize(width: width, height: addressView.height - addressHeadView.height)
        table.rowHeight = 50
        table.register(BSAddressChooseCell.self, forCellReuseIdentifier: "BSAddressChooseCell")
        table.separatorStyle = .none
        return table
    }()
    
    deinit {
        BSLog("地址选择起--销毁了")
    }
    
    private lazy var addressHeadView: AddressView = {
        let address = AddressView()
        address.origin = CGPoint(x: 0, y: 0)
        return address
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BSAddressChooseView: UIGestureRecognizerDelegate {
    
    private func setupUI() {
        backgroundColor = UIColor.init(white: 0.3, alpha: 0.3)
        addSubview(addressView)
        addressView.addSubview(addressHeadView)
        addressView.addSubview(tableViewAddressList)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dimiss))
        tap.numberOfTapsRequired = 1
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        
        loadData()
        
        subiectAddress.bind(to: tableViewAddressList.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "BSAddressChooseCell") as! BSAddressChooseCell
            cell.labelAddress.text = element.name
            return cell
        }.disposed(by: disposeBag)
        
        tableViewAddressList.rx.modelSelected(Province.self).subscribe(onNext: {[weak self] item in
            self?.addressHeadView.setupTitle(type: (self?.param.address_type)!, area: item)

            if self?.param.address_type == 0 {
                self?.param.citys = item.citys!
                self?.param.address_type = 1
                self?.param.provinceString = item.name
                self?.subiectAddress.onNext((self?.param.citys)!)
            }else if self?.param.address_type == 1 {
                self?.param.areas = item.areas!
                self?.param.address_type = 2
                self?.param.cityString = item.name
                if self?.isChooseCity == true {
                    self?.dimiss()
                }else{
                    self?.subiectAddress.onNext((self?.param.areas)!)
                }
            }else if self?.param.address_type == 2 {
                self?.param.areaString = item.name
                self?.dimiss()
            }

        }).disposed(by: disposeBag)
        
        addressHeadView.addressSubject.subscribe(onNext: {[weak self] (tag) in
            switch tag {
            case 100:
                self?.param.address_type = 0
                self?.subiectAddress.onNext((self?.param.provinces)!)
                self?.param.areaString = nil
                self?.param.cityString = nil
                break
            case 200:
                self?.param.address_type = 1
                self?.subiectAddress.onNext((self?.param.citys)!)
                self?.param.areaString = nil
                break
            default:
                self?.param.address_type = 2
                break
            }
        }).disposed(by: addressHeadView.disposeBag)
        
        subiectAddress.onNext(param.provinces)
    }
    
    class func showAddressView(view: UIView,_ chooseCity: Bool = false, completion:@escaping (_ address: String) -> ()) {
        let showView = BSAddressChooseView()
        showView.complete = completion
        showView.isChooseCity = chooseCity
        view.addSubview(showView)
        showView.show()
        
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isEqual(self))! {
            return true
        }
        return false
    }
    
    private func show() {
        UIView.animate(withDuration: 0.25, animations: {
            self.addressView.top = kScreenHeight * 0.3
        }) { (finish) in
        }
    }
    
    @objc private func dimiss() {
        
        let addressString = (param.provinceString ?? "") + (param.cityString ?? "") + (param.areaString ?? "")
        if complete != nil && addressString.count > 1 {
            complete!(addressString)
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.addressView.top = kScreenHeight
        }) { (finish) in
            self.removeFromSuperview()
        }
    }
    
    private func loadData() {
        let jsonPath = Bundle.main.path(forResource: "address.json", ofType: nil)
        if jsonPath == nil { return }
        let jsonData = NSData.init(contentsOfFile: jsonPath!)
        if  let addressData = jsonData{
            let jsonObject = try? JSONSerialization.jsonObject(with: addressData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
            if let json = jsonObject, let dicArray = json as? [[String: Any]] {
                for dic in dicArray {
                    if let model = Province(JSON: dic) {
                        param.provinces.append(model)
                    }
                }
            }

        }
    }
}

class BSAddressChooseCell: BSCommentCell {
    
    override func setupUI() {
        super.setupUI()
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(labelAddress)
    }
    
    lazy var labelAddress: UILabel = {
        let address = UILabel()
        address.setupAttribute(14,
                               nil,
                               "333333",
                               CGSize(width: 180, height: 20),
                               CGPoint(x: kSpacing, y: 15))
        return address
    }()
}

class AddressView: UIView {
    
    let addressSubject = PublishSubject<Int>()
    let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 50)
        super.init(frame: selfFrame)
        
        addSubview(btnAddressFirst)
        addSubview(btnAddressSecond)
        addSubview(btnAddressThree)
        layer.addSublayer(line)
        addBottomLine(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), UIColor.colorWidthHexString(hex: "F0F0F0"), 0.5)

    }
    
    @objc func actionClickBtn(btn: UIButton) {
        
        if btn.tag == 100 {
            line.left = btnAddressFirst.left
            line.width = btnAddressFirst.width
            
            btnAddressSecond.isHidden = true
            btnAddressThree.isHidden = true
        }else if btn.tag == 200 {
            line.left = btnAddressSecond.left
            line.width = btnAddressSecond.width
            
            btnAddressThree.isHidden = true
        }
        addressSubject.onNext(btn.tag)
    }
    
    func setupTitle(type: Int, area: Province) {
        
        if type == 0 {
            btnAddressFirst.setTitle(area.name, for: UIControl.State.normal)
            btnAddressFirst.isSelected = true
            btnAddressFirst.sizeToFit()
            btnAddressFirst.height = 50
            
            
            btnAddressSecond.isHidden = false
            btnAddressSecond.setTitle("请选择", for: UIControl.State.normal)
            btnAddressSecond.isSelected = false
            btnAddressSecond.sizeToFit()
            btnAddressSecond.height = 50
            btnAddressSecond.left = btnAddressFirst.right + 20
            line.left = btnAddressSecond.left
            line.width = btnAddressSecond.width
            
            btnAddressThree.isHidden = true
        }else if type == 1 {
            btnAddressSecond.setTitle(area.name, for: UIControl.State.normal)
            btnAddressSecond.isSelected = true
            btnAddressSecond.sizeToFit()
            btnAddressSecond.height = 50
            
            
            btnAddressThree.isHidden = false
            btnAddressThree.setTitle("请选择", for: UIControl.State.normal)
            btnAddressThree.isSelected = false
            btnAddressThree.sizeToFit()
            btnAddressThree.height = 50
            btnAddressThree.left = btnAddressSecond.right + 20
            line.left = btnAddressThree.left
            line.width = btnAddressThree.width
            
        }else {
        }
    }
    
    
    lazy var line: CALayer = {
        let lineBottom = CALayer()
        lineBottom.backgroundColor = kMainColor.cgColor
        lineBottom.frameSize = CGSize(width: 35, height: 2)
        lineBottom.left = kSpacing
        lineBottom.top = height - 2
        return lineBottom
    }()
    lazy var btnAddressFirst: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.origin = CGPoint(x: kSpacing, y: 0)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setTitleColor(kMainColor, for: UIControl.State.normal)
        btn.setTitleColor(UIColor.black, for: UIControl.State.selected)
        btn.setTitle("请选择", for: UIControl.State.normal)
        btn.sizeToFit()
        btn.height = 50
        btn.tag = 100
        btn.addTarget(self, action: #selector(actionClickBtn(btn:)), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    lazy var btnAddressSecond: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.origin = CGPoint(x: btnAddressFirst.right, y: 0)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setTitleColor(kMainColor, for: UIControl.State.normal)
        btn.setTitleColor(UIColor.black, for: UIControl.State.selected)
        btn.setTitle("请选择", for: UIControl.State.normal)
        btn.sizeToFit()
        btn.height = 50
        btn.isHidden = true
        btn.tag = 200
        btn.addTarget(self, action: #selector(actionClickBtn(btn:)), for: UIControl.Event.touchUpInside)
        return btn
    }()
    lazy var btnAddressThree: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.origin = CGPoint(x: btnAddressSecond.right, y: 0)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setTitleColor(kMainColor, for: UIControl.State.normal)
        btn.setTitleColor(UIColor.black, for: UIControl.State.selected)
        btn.setTitle("请选择", for: UIControl.State.normal)
        btn.sizeToFit()
        btn.height = 50
        btn.isHidden = true
        btn.tag = 300
        btn.addTarget(self, action: #selector(actionClickBtn(btn:)), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AddressParam {
    
    var provinces = [Province]()
    
    var citys = [Province]()
    
    var areas = [Province]()
    
    var provinceString: String?
    
    var cityString: String?
    
    var areaString: String?
    
    var address_type: Int = 0
    
}


class Province: Mappable {
    
    var name: String?
    
    var citys: [Province]?

    var areas: [Province]?

    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name        <- map["name"]
        citys        <- map["cityList"]
        areas        <- map["areaList"]

    }
    
}

