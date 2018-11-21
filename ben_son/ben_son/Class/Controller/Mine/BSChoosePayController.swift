//
//  BSChoosePayController.swift
//  ben_son
//
//  Created by ZS on 2018/10/29.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift
class BSChoosePayController: BSBaseController {

    private let disposeBag = DisposeBag()

    let viewModel = BSChoosePayViewModel()
    
    var isPopToHome: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    var msg: BSOrderModel? {
        didSet{
            headView.labelCarDesc.text = (msg?.brand_name ?? "") + (msg?.car_model ?? "")
            headView.labelPhoneDesc.text = msg?.telephone
            headView.labelNameDesc.text = msg?.name
            headView.labelAddressSesc.text = msg?.removed_address
            headView.colorLine.backgroundColor = UIColor.colorWidthHexString(hex: (msg?.colorString ?? "FFFFFF"))
            btnPay.setTitle("预付定金(人民币): \(msg!.pay_price ?? "")", for: UIControl.State.normal)
            viewModel.param_pay.orderId = (msg?.order_id)!
        }
    }
    

    override func setupUI() {
        super.setupUI()
        title = "支付方式"
        if isPopToHome {
            fd_interactivePopDisabled = true
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "common_back"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(clickBack))
        }
        tableViewPlainCommon.height = UIDevice.current.contentNoTabBarHeight()
        tableViewPlainCommon.rowHeight = 62
        tableViewPlainCommon.tableHeaderView = headView
        tableViewPlainCommon.register(BSPayOrderChooseCell.self, forCellReuseIdentifier: "BSPayOrderChooseCell")
        view.addSubview(tableViewPlainCommon)
        view.addSubview(btnPay)
        
        viewModel.publishPay.bind(to: tableViewPlainCommon.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "BSPayOrderChooseCell") as! BSPayOrderChooseCell
            cell.model = element
            return cell
        }.disposed(by: disposeBag)
        
        //获取选中项的内容
        tableViewPlainCommon.rx.modelSelected(BSChoosePayModel.self).subscribe(onNext: {[weak self] item in
            self?.viewModel.selectedCell(item: item)
        }).disposed(by: disposeBag)
        
        
        btnPay.rx.tap.subscribe(onNext: {[weak self] in
            self?.viewModel.subjectSent.onNext((self?.viewModel.param_pay)!)
        }).disposed(by: disposeBag)
        
        viewModel.summitResult?.subscribe(onNext: {[weak self] (finish) in
            if finish {
               self?.pay()
            }
        }).disposed(by: viewModel.disposeBag)
        viewModel.publishPay.onNext(viewModel.pays)
    }
    
    @objc func clickBack() {
        BSPromatView.show_prompt(Prompt_type.prompt_type_all, "是否确认退出支付? 退出支付后可以在 我的 -> 我的订单 -> 未支付 找到该订单重新支付") {[weak self] (type) in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func pay() {
        if viewModel.param_pay.driver == "alipay" {
            BSPayManager.manager.alipayPay(pay_param: (viewModel.pay_alipay)!, payResult: {[weak self] (payCode) in
                self?.pay_Code(code: payCode)
            })
        }else{
            BSPayManager.manager.wxPay(pay_param: viewModel.wechatPay!, payResult: {[weak self] (payCode) in
                self?.pay_Code(code: payCode)
            })
        }
    }
    
    func pay_Code(code: PayCode) {
        switch code {
        case .WXSUCESS, .ALIPAYSUCESS:
            let payResult = BSPayResultController()
            payResult.msg = msg
            self.navigationController?.pushViewController(payResult, animated: true)
            break
        case .ALIPAYCANCEL, .WXSCANCEL:
            BSPromatView.show_prompt(Prompt_type.prompt_type_all, "取消支付,是否重新支付", (self.navigationController?.view)!, complete: {[weak self] (prompt) in
                self?.pay()
            })
            break
        default:
            BSPromatView.show_prompt(Prompt_type.prompt_type_all, "支付失败,是否重新支付", (self.navigationController?.view)!, complete: {[weak self] (prompt) in
                self?.pay()
            })
            break
        }
    }
    
    private lazy var headView: BSChoosePayHeadView = {
        let head = BSChoosePayHeadView()
        return head
    }()
    
    private lazy var btnPay: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.backgroundColor = kMainColor
        btn.setTitle("预付定金(人民币): 12000", for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.setTitleColor(UIColor.colorWidthHexString(hex: "FCFCFC"), for: UIControl.State.normal)
        btn.size = CGSize(width: kScreenWidth, height: UIDevice.current.tabbarBottomHeight() + 50)
        btn.origin = CGPoint(x: 0, y: UIDevice.current.contentNoTabBarHeight() - btn.height)
        if UIDevice.current.isX() {
            btn.titleEdgeInsets = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        }
        return btn
    }()
    
}
