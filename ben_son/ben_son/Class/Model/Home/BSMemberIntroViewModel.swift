//
//  BSMemberIntroViewModel.swift
//  ben_son
//
//  Created by ZS on 2018/10/25.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxSwift
class BSMemberIntroViewModel {
    
    let subjectCard = PublishSubject<[BSMemberIntroModel]>()
    
    
    
    lazy var arrayGoldCardList: [BSMemberIntroModel] = {
        
        let first = BSMemberIntroModel()
        first.normalIcon = "member_first_selected"
        first.title = "俱乐部门店所在地\n接送车精准送达"
        first.colorString = "A98054"
        first.showrightLine = true
        first.showBottomLeft = false
        
        let second = BSMemberIntroModel()
        second.normalIcon = "member_second_selected"
        second.title = "生日当天免费用车免费\n豪华车接、送机"
        second.colorString = "A98054"
        second.showrightLine = false
        second.showBottomLeft = true
        
        let thired = BSMemberIntroModel()
        thired.normalIcon = "member_thired_selected"
        thired.title = "指定上海顶级餐厅俱\n乐部及酒店的预订、\n优惠和礼遇"
        thired.colorString = "A98054"
        thired.showrightLine = true
        thired.showBottomLeft = false
        
        let four = BSMemberIntroModel()
        four.normalIcon = "member_four_selected"
        four.title = "单日可驾驶标准公里\n数延长不限"
        four.colorString = "A98054"
        four.showrightLine = false
        four.showBottomLeft = true
        
        let five = BSMemberIntroModel()
        five.normalIcon = "member_five_selected"
        five.title = "任意流量还车"
        five.colorString = "A98054"
        five.showrightLine = true
        five.showBottomLeft = false
        
        let six = BSMemberIntroModel()
        six.normalIcon = "member_six_selected"
        six.title = "每年免费豪车接送机\n6次"
        six.colorString = "A98054"
        six.showrightLine = false
        six.showBottomLeft = true
        
        let seven = BSMemberIntroModel()
        seven.normalIcon = "member_seven_selected"
        seven.title = "急速送达服务\n500km"
        seven.colorString = "A98054"
        seven.showrightLine = true
        seven.showBottomLeft = false
        
        let eight = BSMemberIntroModel()
        eight.normalIcon = "member_eight_selected"
        eight.title = "深圳 - 香港通关保姆车\n免费6次"
        eight.colorString = "A98054"
        eight.showrightLine = false
        eight.showBottomLeft = true

        return [first, second, thired, four, five, six, seven, eight]
    }()
    
    lazy var arrayNormalCardList: [BSMemberIntroModel] = {
        let first = BSMemberIntroModel()
        first.normalIcon = "member_first"
        first.title = "上海市区接送车\n精准速达"
        first.colorString = "53402F"
        first.showrightLine = true
        first.showBottomLeft = false
        
        let second = BSMemberIntroModel()
        second.normalIcon = "member_second"
        second.title = "生日当天免费用车免费\n豪华车接、送机"
        second.colorString = "53402F"
        second.showrightLine = false
        second.showBottomLeft = true
        
        let thired = BSMemberIntroModel()
        thired.normalIcon = "member_thired"
        thired.title = "指定上海顶级餐厅俱\n乐部及酒店的预订、\n优惠和礼遇"
        thired.colorString = "53402F"
        thired.showrightLine = true
        thired.showBottomLeft = false
        
        let four = BSMemberIntroModel()
        four.normalIcon = "member_four"
        four.title = "单日可驾驶标准公里\n数延长不限"
        four.colorString = "53402F"
        four.showrightLine = false
        four.showBottomLeft = true
        
        let five = BSMemberIntroModel()
        five.normalIcon = "member_five"
        five.title = "任意流量还车"
        five.colorString = "53402F"
        five.showrightLine = true
        five.showBottomLeft = false
        
        let six = BSMemberIntroModel()
        six.normalIcon = "member_six"
        six.title = "每年免费豪车接送机\n12次"
        six.colorString = "53402F"
        six.showrightLine = false
        six.showBottomLeft = true
        
        let seven = BSMemberIntroModel()
        seven.normalIcon = "member_seven"
        seven.title = "急速送达服务\n500km"
        seven.colorString = "53402F"
        seven.showrightLine = true
        seven.showBottomLeft = false
        
        let eight = BSMemberIntroModel()
        eight.normalIcon = "member_eight"
        eight.title = "深圳 - 香港通关保姆车\n免费12次"
        eight.colorString = "53402F"
        eight.showrightLine = false
        eight.showBottomLeft = true
        return [first, second, thired, four, five, six, seven, eight]

    }()
    
    lazy var arrayBlackCardList: [BSMemberIntroModel] = {
        
        let first = BSMemberIntroModel()
        first.normalIcon = "member_first_selected"
        first.title = "上海市区接送车\n精准速达"
        first.colorString = "A98054"
        first.showrightLine = true
        first.showBottomLeft = false
        
        let second = BSMemberIntroModel()
        second.normalIcon = "member_second_selected"
        second.title = "生日当天免费用车免费\n豪华车接、送机"
        second.colorString = "A98054"
        second.showrightLine = false
        second.showBottomLeft = true
        
        let thired = BSMemberIntroModel()
        thired.normalIcon = "member_thired_selected"
        thired.title = "指定上海顶级餐厅俱\n乐部及酒店的预订、\n优惠和礼遇"
        thired.colorString = "A98054"
        thired.showrightLine = true
        thired.showBottomLeft = false
        
        let four = BSMemberIntroModel()
        four.normalIcon = "member_four_selected"
        four.title = "单日可驾驶标准公里\n数延长不限"
        four.colorString = "A98054"
        four.showrightLine = false
        four.showBottomLeft = true
        
        let five = BSMemberIntroModel()
        five.normalIcon = "member_five_selected"
        five.title = "任意流量还车"
        five.colorString = "A98054"
        five.showrightLine = true
        five.showBottomLeft = false
        
        let six = BSMemberIntroModel()
        six.normalIcon = "member_six_selected"
        six.title = "每年免费豪车接送机\n12次"
        six.colorString = "A98054"
        six.showrightLine = false
        six.showBottomLeft = true
        
        let seven = BSMemberIntroModel()
        seven.normalIcon = "member_seven_selected"
        seven.title = "急速送达服务\n500km"
        seven.colorString = "A98054"
        seven.showrightLine = true
        seven.showBottomLeft = false
        
        let eight = BSMemberIntroModel()
        eight.normalIcon = "member_eight_selected"
        eight.title = "深圳 - 香港通关保姆车\n免费12次"
        eight.colorString = "A98054"
        eight.showrightLine = false
        eight.showBottomLeft = true
        
        return [first, second, thired, four, five, six, seven, eight]
    }()
}

class BSMemberIntroModel {
    
    var normalIcon: String?
    
    var title: String?
    
    var colorString: String?
    
    var showrightLine: Bool = false
    
    var showBottomLeft: Bool = false
    
    
    
}
