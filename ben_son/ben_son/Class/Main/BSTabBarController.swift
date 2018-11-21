//
//  BSTabBarController.swift
//  ben_son
//
//  Created by ZS on 2018/8/28.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
class BSTabBarController: UITabBarController {

    private let selectedImageBgWidth: CGFloat = kScreenWidth * 0.2
    private var imageViews = [UIImageView]()
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        let myTabBar = BSTabBarView()
        setValue(myTabBar, forKey: "tabBar")
        
        tabBar.isTranslucent = false
        
        tabBar.addSubview(tabbarBackView)
        tabBar.addSubview(selectedImageView)
        setupChildController()
        
        for item in tabBar.subviews {
            if item.isKind(of: NSClassFromString("UITabBarButton")!) {
                let imageView = item.value(forKey: "_info")
                if let imageIconView = imageView as? UIImageView {
                    imageViews.append(imageIconView)
                }
            }
        }
        
    }
    
    private lazy var tabbarBackView: UIImageView = {
        let bgView = UIImageView()
        bgView.origin = CGPoint(x: 0, y: 0)
        bgView.size = CGSize(width: kScreenWidth, height: UIDevice.current.tabBarHeight() )
        let image = UIImage(named: "tabbar_backimage")
        bgView.image = zs_imageSize(size: bgView.size, imageOr: image!)
        return bgView
    }()
    
    private lazy var selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.size = CGSize(width: selectedImageBgWidth, height: 10)
        imageView.left = 0
        imageView.top = tabBar.height - 10
        imageView.image = UIImage(named: "tabbar_selectedbg")
        return imageView
    }()

    private func zs_imageSize(size: CGSize, imageOr: UIImage) -> UIImage?{
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        imageOr.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension BSTabBarController: UITabBarControllerDelegate {
    private func setupChildController() {
        let arrayVcMsg = [["clsName":"BSHomeController",
                           "title":"首页",
                           "imageName":"tabbar_home"],
                          ["clsName":"BSCarController",
                           "title":"车型",
                           "imageName":"tabbar_car"],
                          ["clsName":"UIViewController"],
                          ["clsName":"BSDiscoverController",
                           "title":"发现",
                           "imageName":"tabbar_search"],
                          ["clsName":"BSMineController",
                           "title":"我的",
                           "imageName":"tabbar_mine"]]
        var arrayVcs = [UIViewController]()
        for dic in arrayVcMsg {
            arrayVcs.append(controller(dic: dic))
        }
        
        viewControllers = arrayVcs
    }
//
//    private func getTabbarButtonImageView(item: UITabBarItem) -> UIImageView? {
//        if let tabBarButtonControl = item.value(forKey: "view"), let control = tabBarButtonControl as? UIControl, let tabBarSwappableImageView = control.value(forKey: "info"), let tabbarImageView = tabBarSwappableImageView as? UIImageView {
//            return tabbarImageView
//        }
//        return nil
//
//    }
    
    private func controller(dic: [String: String]) -> UIViewController {
        guard let clsName = dic["clsName"], let title = dic["title"], let imageName = dic["imageName"] else {
            return UIViewController()
        }
        var cls: UIViewController.Type?
        
        if (NSClassFromString(Bundle.main.nameSpace + "." + clsName) as? UIViewController.Type) != nil{
            cls = NSClassFromString(Bundle.main.nameSpace + "." + clsName) as? UIViewController.Type
        }else{
            return UIViewController()
        }
        let vc = cls!.init()
        
        vc.title = title

        let navVc = BSNavgationController.init(rootViewController: vc)
        navVc.tabBarItem.image = UIImage(named: imageName + "_normal")?.withRenderingMode(.alwaysOriginal)
        
        navVc.tabBarItem.selectedImage = UIImage(named: imageName + "_selected")?.withRenderingMode(.alwaysOriginal)
        navVc.tabBarItem.imageInsets = UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0)
        navVc.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
        navVc.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.colorWidthHexString(hex: "FFFFFF"), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], for: .normal)

        navVc.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.colorWidthHexString(hex: "A98054"), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], for: .selected)
        
        return navVc
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let index = tabBarController.viewControllers?.index(where: {$0 === viewController}) {
            if tabBarController.selectedIndex == index {
                return false
            }
        }
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        var selectedIndex = tabBarController.selectedIndex
        if selectedIndex > 1 {
            selectedIndex = selectedIndex - 1
        }
        if selectedIndex < imageViews.count {
            let selecteLeft = CGFloat(tabBarController.selectedIndex) * selectedImageBgWidth
            UIView.animate(withDuration: 0.2) {
                self.selectedImageView.left = selecteLeft
            }
            let imageView = imageViews[selectedIndex]
           playAnimationBounce(imageView)
        }
    }
    
    //翻转动画
    private func playAnimation(_ icon: UIImageView) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
        rotateAnimation.duration = 1.0
        rotateAnimation.repeatCount = 1
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat.pi * 2
        rotateAnimation.isRemovedOnCompletion = true
        icon.layer.add(rotateAnimation, forKey: nil)
    }
    
    //旋转动画
    private func playZAnimation(_ icon: UIImageView) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.duration = 1.0
        rotateAnimation.repeatCount = 1
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat.pi * 2
        rotateAnimation.isRemovedOnCompletion = true
        icon.layer.add(rotateAnimation, forKey: nil)
    }
    
    private func playAnimationBounce(_ icon: UIImageView) {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = 1.0
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        bounceAnimation.isRemovedOnCompletion = true
        icon.layer.add(bounceAnimation, forKey: nil)
    }
}
