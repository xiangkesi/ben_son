//
//  BSSettingController.swift
//  ben_son
//
//  Created by ZS on 2018/9/22.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift

class BSSettingController: BSBaseController {

    let viewModel = BSSettingViewModel()
    let chooseModel = ChooseImage()
    
    
   private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setupUI() {
        super.setupUI()
        title = "设置"
        tableViewPlainCommon.height = UIDevice.current.contentNoNavHeight()
        tableViewPlainCommon.register(BSSettingCell.self, forCellReuseIdentifier: "BSSettingCell")
        tableViewPlainCommon.rowHeight = 72
        tableViewPlainCommon.tableFooterView = SetingFootView
        view.addSubview(tableViewPlainCommon)
        tableViewPlainCommon.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel.publishModels.bind(to: tableViewPlainCommon.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "BSSettingCell") as! BSSettingCell
            cell.seting = element
            return cell
        }.disposed(by: disposeBag)
        
        viewModel.result?.subscribe(onNext: {[weak self] (finish) in
            RSProgressHUD.hideHUDQueryHUD(view: (self?.navigationController?.view)!)
            RSProgressHUD.showSuccessOrFailureHud(titleStr: "修改成功", (self?.navigationController?.view)!)
        }).disposed(by: disposeBag)
        //获取选中项的内容
        tableViewPlainCommon.rx.modelSelected(BSSeetingModel.self).subscribe(onNext: {[weak self] item in
            switch item.type {
            case 0:
                BSPhotoView.showBtnView(view: self?.navigationController?.view, completion: {[weak self] (index) in
                    self?.chooseModel.isCamera = (index == 100 ? false : true)
                    self?.viewModel.sub.onNext((self?.chooseModel)!)
                })
                break
            case 1:
                let nickVc = BSSetingNickController()
                nickVc.type = 0
                nickVc.inputSubject.subscribe(onNext: {[weak self] (text) in
                    let model = self?.viewModel.models[1]
                    model?.describe = text
                    self?.viewModel.publishModels.onNext((self?.viewModel.models)!)
                    RSProgressHUD.showWindowesLoading(view: self?.navigationController?.view, titleStr: "修改中...")
                    self?.viewModel.modifySubject.onNext(["username":text])
                }).disposed(by: nickVc.disposeBag)
                self?.navigationController?.pushViewController(nickVc, animated: true)
                break
            case 2:
                BSSettingSexView.showView(type: self?.viewModel.login_user?.gender ?? 1, completion: { (page) in
                    let model = self?.viewModel.models[2]
                    model?.describe = page == 1 ? "男" : "女"
                    self?.viewModel.login_user?.gender = page
                    self?.viewModel.publishModels.onNext((self?.viewModel.models)!)
                    self?.viewModel.modifySubject.onNext(["gender":page])
                })
                break
            case 3:
                let nickVc = BSSetingNickController()
                nickVc.type = 1
                nickVc.inputSubject.subscribe(onNext: {[weak self] (text) in
                    let model = self?.viewModel.models[3]
                    model?.describe = text
                    self?.viewModel.publishModels.onNext((self?.viewModel.models)!)
                    RSProgressHUD.showWindowesLoading(view: self?.navigationController?.view, titleStr: "修改中...")
                    self?.viewModel.modifySubject.onNext(["signature":text])
                }).disposed(by: nickVc.disposeBag)
                self?.navigationController?.pushViewController(nickVc, animated: true)
                break
            case 4:
                BSAddressChooseView.showAddressView(view: (self?.navigationController?.view)!, completion: {[weak self] (address) in
                   let model = self?.viewModel.models[4]
                    model?.describe = address
                    self?.viewModel.publishModels.onNext((self?.viewModel.models)!)
                    RSProgressHUD.showWindowesLoading(view: self?.navigationController?.view, titleStr: "修改中...")
                    self?.viewModel.modifySubject.onNext(["address":address])
                })
                break
            default:
                BSPromatView.show_prompt(Prompt_type.prompt_type_all, "清楚缓存后所有保存数据将要消失,需要重新消耗网络加载,是否继续?", (self?.navigationController?.view)!, complete: { (prompt) in
                    RSProgressHUD.showWindowesLoading(view: self?.navigationController?.view, titleStr: "")
                    self?.viewModel.cleanCache()
                    RSProgressHUD.hideHUDQueryHUD(view: (self?.navigationController?.view)!)
                })
                break
            }
            
        }).disposed(by: disposeBag)
        
        viewModel.resultImage.subscribe(onNext: {[weak self] (image) in
            let model = self?.viewModel.models[0]
            model?.image = image
            self?.viewModel.publishModels.onNext((self?.viewModel.models)!)
            if let imageData = image?.jpegData(compressionQuality: 0.5) {
                RSProgressHUD.showWindowesLoading(view: self?.navigationController?.view, titleStr: "修改中...")
                self?.viewModel.modifySubject.onNext(["file": imageData])
            }
        }).disposed(by: disposeBag)
        
        btnLogout.rx.tap.subscribe(onNext: {[weak self] (image) in
           AccountManager.shareManager().exitLogin()
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
             
        chooseModel.controller = self
        viewModel.calculateCache()
        viewModel.publishModels.onNext(viewModel.models)
    
        
    }
    
    
    private lazy var SetingFootView: UIView = {
        let footView = UIView()
        footView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 200)
        footView.addSubview(btnLogout)
        return footView
    }()
    
    private lazy var btnLogout: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.backgroundColor = kMainColor
        btn.setTitle("退出登录", for: UIControl.State.normal)
        btn.size = CGSize(width: kContentWidth, height: 44)
        btn.left = kSpacing
        btn.top = 80
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.zs_cutCorner(sizeHeigt: CGSize(width: 5, height: 5))
        btn.isHidden = true
        if AccountManager.shareManager().isLogin {
            btn.isHidden = false
        }
        return btn
    }()


}

extension BSSettingController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 72 : 52
    }
}
