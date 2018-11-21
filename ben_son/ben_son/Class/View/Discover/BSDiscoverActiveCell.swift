//
//  BSDiscoverActiveCell.swift
//  ben_son
//
//  Created by ZS on 2018/10/22.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

let shopCellWidth = kScreenWidth * 0.33
let memberHeadViewHeight = kScreenWidth * 0.9 + 340 + (UIDevice.current.isX() ? 20 : 0)
let customercellWidth = kScreenWidth * 0.5 - 20
let customercellHeight = customercellWidth * 0.6 + 10



class BSDiscoverActiveCell: BSCommonCollectionCell {

    
    override func setupUI() {
        super.setupUI()
        contentView.backgroundColor = kMainBackBgColor
        contentView.addSubview(imageIconView)
        contentView.addSubview(labelTitle)
        contentView.layer.addSublayer(lineBottom)
    }
    
    var active: DiscoverNewActive? {
        didSet{
            imageIconView.zs_setImage(urlString: active?.activePhoto, placerHolder: image_placholder)
            labelTitle.text = active?.activeTitle
        }
    }
    
    
    private lazy var lineBottom: CALayer = {
        let line = CALayer()
        line.origin = CGPoint(x: kSpacing, y: 119)
        line.frameSize = CGSize(width: kContentWidth, height: 0.5)
        line.backgroundColor = UIColor.colorWidthHexString(hex: "1A1A1A").cgColor
        return line
    }()
    private lazy var imageIconView: UIImageView = {
        let imageIcon = UIImageView()
        imageIcon.origin = CGPoint(x: kSpacing, y: 20)
        imageIcon.height = 80
        imageIcon.width = 80 * 1.5

        return imageIcon
    }()
    
    private lazy var labelTitle: UILabel = {
        let title = UILabel()
        title.left = imageIconView.right + 10
        title.top = imageIconView.top
        title.height = 40
        title.numberOfLines = 0
        title.width = kScreenWidth - imageIconView.right - 25
        title.font = UIFont.systemFont(ofSize: 15)
        title.textColor = UIColor.colorWidthHexString(hex: "BFBFBF")
        title.text = "BENSON 联手《快来救我》"
        return title
    }()
 
}

class BSDiscoverShopCell: BSCommonCollectionCell {
    
    override func setupUI() {
        super.setupUI()
        contentView.backgroundColor = kMainBackBgColor
        contentView.addSubview(imageIconView)
        contentView.addSubview(labelTitle)
        contentView.addSubview(labelPrace)
    }
    
    private lazy var imageIconView: UIImageView = {
        let imageIcon = UIImageView()
        imageIcon.origin = CGPoint(x: 20, y: 20)
        imageIcon.width = shopCellWidth - 40
        imageIcon.height = imageIcon.width
        return imageIcon
    }()
    
    private lazy var labelTitle: UILabel = {
        let title = UILabel()
        title.left = 0
        title.top = imageIconView.bottom + 10
        title.height = 20
        title.width = shopCellWidth
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 14)
        title.textColor = UIColor.colorWidthHexString(hex: "BFBFBF")
        title.text = "iPhone X全网通"
        return title
    }()
    
    private lazy var labelPrace: UILabel = {
        let title = UILabel()
        title.left = 0
        title.top = labelTitle.bottom + 3
        title.height = 17
        title.width = shopCellWidth
        title.font = UIFont.systemFont(ofSize: 13)
        title.textColor = kMainColor
        title.text = "120000积分"
        title.textAlignment = .center
        return title
    }()
}

class BSDiscoverCustomerCell: BSCommonCollectionCell {
    
    override func setupUI() {
        super.setupUI()
        contentView.addSubview(imageView)
    }
    
    var cuetome: CustomerListModel? {
        didSet{
            imageView.zs_setImage(urlString: cuetome?.customerPhoto, placerHolder: image_placholder)
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.origin = CGPoint(x: 0, y: 0)
        image.size = CGSize(width: customercellWidth, height: customercellHeight - 10)
        return image
    }()
}

class BSDiscoverMemberHeadView: UICollectionReusableView {
    

    var complcote:((_ type: Int) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = kMainBackBgColor
        addSubview(memberView)
        addSubview(aboutView)
        addSubview(titleView)
        
        memberView.memberUpBtn.addTarget(self, action: #selector(upMember), for: UIControl.Event.touchUpInside)
        titleView.buttonMore.addTarget(self, action: #selector(moreAboutClick), for: UIControl.Event.touchUpInside)
        aboutView.btn.addTarget(self, action: #selector(customerServiceClick), for: UIControl.Event.touchUpInside)
        
        aboutView.titleView.buttonMore.addTarget(self, action: #selector(about_mine), for: UIControl.Event.touchUpInside)
    }
    
    @objc func upMember() {
        if complcote != nil {
            complcote!(100)
        }
    }
    @objc func moreAboutClick() {
        if complcote != nil {
            complcote!(200)
        }
    }
    @objc func customerServiceClick() {
        if complcote != nil {
            complcote!(300)
        }
    }
    
    @objc func about_mine() {
        if complcote != nil {
            complcote!(400)
        }
    }
    
    var login_user: Login_user? {
        didSet{
            if login_user == nil {
                memberView.viewBg.image = UIImage(named: "image_cover_novip")
                memberView.memberBtn.setTitle("您还未加入本森会员", for: UIControl.State.normal)
                memberView.memberBtn.setTitleColor(UIColor.colorWidthHexString(hex: "222222"), for: UIControl.State.normal)
                memberView.labelTitle.text = "加入会员，4大权益免费送"
                memberView.labelTitle.textColor = UIColor.colorWidthHexString(hex: "919191")
                memberView.memberUpBtn.setTitle("加入会员", for: UIControl.State.normal)
                memberView.memberUpBtn.isHidden = false
                
            }else {
                switch (login_user!.level) {
                case 1:
                    memberView.viewBg.image = UIImage(named: "image_cover_novip")
                    memberView.memberBtn.setTitle("您当前是普通会员", for: UIControl.State.normal)
                    memberView.memberBtn.setTitleColor(UIColor.colorWidthHexString(hex: "222222"), for: UIControl.State.normal)
                    memberView.labelTitle.text = "升级会员，4大权益免费送"
                    memberView.labelTitle.textColor = UIColor.colorWidthHexString(hex: "919191")
                    memberView.memberUpBtn.setTitle("升级会员", for: UIControl.State.normal)
                    memberView.memberUpBtn.isHidden = false
                    
                    break
                case 2:
                    memberView.viewBg.image = UIImage(named: "image_cover_goldcard")
                    memberView.memberBtn.setTitle("您当前是金卡会员", for: UIControl.State.normal)
                    memberView.memberBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
                    memberView.labelTitle.text = "积分：80000"
                    memberView.labelTitle.textColor = UIColor.white
                    memberView.memberUpBtn.setTitle("升级黑卡", for: UIControl.State.normal)
                    memberView.memberUpBtn.isHidden = false
                    break
                default:
                    memberView.viewBg.image = UIImage(named: "image_cover_blackcard")
                    memberView.memberBtn.setTitle("您当前是黑卡会员", for: UIControl.State.normal)
                    memberView.memberBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
                    memberView.labelTitle.text = "积分：80000"
                    memberView.labelTitle.textColor = UIColor.white
                    memberView.memberUpBtn.isHidden = true
                    break
                }
            }
        }
    }
    
    
    lazy var memberView: BSDicoverView = {
        let member = BSDicoverView()
        member.origin = CGPoint(x: 0, y: 0)
        return member
    }()
    private lazy var aboutView: BSDicoverAboutView = {
        let about = BSDicoverAboutView()
        about.origin = CGPoint(x: 0, y: memberView.bottom)
        return about
    }()
    
    private lazy var titleView: BSDiscoverTitleView = {
        let viewTitle = BSDiscoverTitleView()
        viewTitle.top = aboutView.bottom
        viewTitle.left = 0
        return viewTitle
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class BSDiscoverTitleView: UIView {
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 70)
        super.init(frame: selfFrame)
        backgroundColor = kMainBackBgColor
        
        addSubview(labelTitle)
        addSubview(labelTitleDesc)
        addSubview(buttonMore)
    }
    
    func setupTitles(title: String, desc: String) {
        labelTitle.text = title
        labelTitleDesc.text = desc
    }
    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.origin = CGPoint(x: kSpacing, y: 20)
        label.size = CGSize(width: 200, height: 25)
        label.textColor = UIColor.colorWidthHexString(hex: "FFFFFF")
        label.font = UIFont.init(name: "PingFangSC-Semibold", size: 18)
        label.text = "最新活动"
        return label
    }()
    private lazy var labelTitleDesc: UILabel = {
        let label = UILabel()
        label.origin = CGPoint(x: kSpacing, y: labelTitle.bottom)
        label.size = CGSize(width: 200, height: 25)
        label.textColor = UIColor.colorWidthHexString(hex: "383838")
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "The latest activity"
        return label
    }()
    
    lazy var buttonMore: UIButton = {
        let more = UIButton(type: UIButton.ButtonType.custom)
        more.size = CGSize(width: 60, height: 30)
        more.backgroundColor = kMainBackBgColor
        more.top = 20
        more.left = kScreenWidth - 75
        more.contentHorizontalAlignment = .right
        more.setTitleColor(UIColor.colorWidthHexString(hex: "424242"), for: UIControl.State.normal)
        more.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        more.setTitle("更多 ▶", for: UIControl.State.normal)
        more.setTitle("更多 ▶", for: UIControl.State.highlighted)

        return more
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BSDiscoverCommonHeadView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(lineBottom)
        addSubview(titleView)
    }
    
    private lazy var lineBottom: CALayer = {
        let line = CALayer()
        line.origin = CGPoint(x: 0, y: 0)
        line.frameSize = CGSize(width: kScreenWidth, height: 10)
        line.backgroundColor = UIColor.colorWidthHexString(hex: "1A1A1A").cgColor
        return line
    }()
    
    private lazy var titleView: BSDiscoverTitleView = {
        let viewTitle = BSDiscoverTitleView()
        viewTitle.left = 0
        viewTitle.top = lineBottom.bottom
        
        return viewTitle
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class BSDiscoverCustomerHeadView: UICollectionReusableView {
    
    
    var complete:(() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = kMainBackBgColor
        layer.addSublayer(lineBottom)
        addSubview(titleView)
        addSubview(labelTitle)
    }
    
    @objc func clickMore() {
        if complete != nil {
            complete!()
        }
    }
    
    private lazy var lineBottom: CALayer = {
        let line = CALayer()
        line.origin = CGPoint(x: 0, y: 20)
        line.frameSize = CGSize(width: kScreenWidth, height: 10)
        line.backgroundColor = UIColor.colorWidthHexString(hex: "1A1A1A").cgColor
        return line
    }()
    
    private lazy var titleView: BSDiscoverTitleView = {
        let viewTitle = BSDiscoverTitleView()
        viewTitle.left = 0
        viewTitle.top = lineBottom.bottom
        viewTitle.setupTitles(title: "合作客户", desc: "PARTNER")
        viewTitle.buttonMore.addTarget(self, action: #selector(clickMore), for: UIControl.Event.touchUpInside)
        return viewTitle
    }()
    
    private lazy var labelTitle: UILabel = {
        let title = UILabel()
        title.left = kSpacing
        title.top = titleView.bottom + 10
        title.size = CGSize(width: kContentWidth, height: 150)
        title.numberOfLines = 0
        title.font = UIFont.systemFont(ofSize: 15)
        title.text = "  百威中国，马牌中国，联合利华，外滩悦榕庄，香格里拉，宜家，迈凯伦，兰博基尼，保时捷中国，雷诺F1，捷豹，奔驰，奥迪，大众，Roger Dubuis，TAG Heuer，adidas，PUMA，GQ杂志，鹅岛啤酒，多芬，欢乐颂，嘉实多机油，映客直播，斗鱼直播，花椒直播，Yeti，VOGUE，MOOK，UBER，BOILER ROOM，SSCC，19CLUB …出乎意料吧，一个个知名的品牌和企业都已是本森的合作伙伴。\n   时尚、高端就是本森的代名词。得天独厚的黄金地理位置，极具特色的现代工厂风独栋会所，以及具有超凡敬业精神的精英团队。如果您还在为找不到合适的场地而发愁，马上来本森吧！我们将会给您一个不同以往的全新体验，一个出乎意料的完美展现。\n   一如既往专注于您的需求，提升您的感受。保持热情、可靠、周全的服务是本森对您的承诺。"
        title.textColor = UIColor.colorWidthHexString(hex: "666666")
        return title
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class BSDicoverView: UIView {
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth * 0.65 + (UIDevice.current.isX() ? 20 : 0))
        super.init(frame: selfFrame)
        
        addSubview(imageBg)
        addSubview(viewBg)
        viewBg.addSubview(imageHead)
        viewBg.addSubview(memberBtn)
        viewBg.addSubview(labelTitle)
        viewBg.addSubview(memberUpBtn)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var imageBg: UIImageView = {
        let bg = UIImageView()
        bg.origin = CGPoint(x: 0, y: 0)
        bg.size = CGSize(width: kScreenWidth, height: height - 20)
        bg.image = UIImage(named: "found_head_bgimage_dark")
        bg.isUserInteractionEnabled = true
        return bg
    }()
    
    lazy var viewBg: UIImageView = {
        let bg = UIImageView()
        bg.image = UIImage(named: "image_cover_novip")
        bg.left = kSpacing
        bg.top = UIDevice.current.isX() ? 80 : 60
        bg.size = CGSize(width: kContentWidth, height: height - (UIDevice.current.isX() ? 80 : 60))
        bg.isUserInteractionEnabled = true
        return bg
    }()
    
    lazy var imageHead: UIImageView = {
        let head = UIImageView()
        head.image = UIImage(named: "placer_head")
        head.size = CGSize(width: 60, height: 60)
        head.left = (viewBg.width - 60) * 0.5
        head.top = -30
        head.zs_corner()
        return head
    }()
    
    lazy var memberBtn: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.size = CGSize(width: viewBg.width, height: 20)
        btn.origin = CGPoint(x: 0, y: imageHead.bottom + 20)
        btn.setTitleColor(UIColor.colorWidthHexString(hex: "222222"), for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.init(name: "PingFangSC-Medium", size: 18)
        btn.isUserInteractionEnabled = false
        return btn
    }()
    
    lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.width = viewBg.width
        label.height = 18
        label.font = UIFont.systemFont(ofSize: 13)
        label.origin = CGPoint(x: 0, y: memberBtn.bottom + 8)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    lazy var memberUpBtn: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.size = CGSize(width: 100, height: 50)
        btn.origin = CGPoint(x: (viewBg.width - 100) * 0.5, y: viewBg.height - 50)
        btn.setTitleColor(UIColor.colorWidthHexString(hex: "FFFFFF"), for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setBackgroundImage(UIImage(named: "btn_join_vip"), for: UIControl.State.normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: -12, left: 0, bottom: 0, right: 0)
        return btn
    }()
}


class BSDicoverAboutView: UIView {
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kContentWidth * 0.25 + 270)
        super.init(frame: selfFrame)
        
        
        addSubview(titleView)
        addSubview(labelTitle)
        addSubview(btn)
        
        layer.addSublayer(lineBottom)
    }
    
    lazy var titleView: BSHomeTitleView = {
        let viewTitle = BSHomeTitleView()
        viewTitle.origin = CGPoint(x: 0, y: 0)
        viewTitle.setValue(title: "关于本森", desc: "ABOUT BENSON")
        return viewTitle
    }()
    
    private lazy var labelTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 15)
        title.textColor = UIColor.colorWidthHexString(hex: "5C5C5C")
        title.text = "     |无论如何，对于超跑而言，它们理当是梦想与传奇的延伸，是极致化追求的宠儿。超跑呼啸而过，留下一串艳羡和流光溢彩。当动辄千万、性能卓越的钢铁机械出现在面前时，没有人可以否认它拥有聚焦所有目光的力量。\n     |毋庸置疑，对于超跑俱乐部而言，它们如同是一个个潜在都市里的“猎人”，它们是网络城市里最先锋又最神秘的“高富帅”\n    .|不得不承认，超跑俱乐部之路是一条光芒万丈的路，速度与激情，青春与梦想交织，曾吸引一代代年轻领袖前仆后继。当然，这也是一条孤独的路，喧嚣后的安静，寂寞的跑道，十年如初的匠心坚守。\n   |Benson Supercar Club本森超跑俱乐部，中国超跑俱乐部十年坚守者，秉承超跑文化推动者的匠心，心怀对超跑的独特情怀，致力于做全国最有情怀的豪车体验中心。"
        title.numberOfLines = 0
        title.left = kSpacing
        title.top = titleView.bottom
        title.size = CGSize(width: kContentWidth, height: 150)
        return title
    }()
    
    lazy var btn: UIButton = {
        let b = UIButton(type: UIButton.ButtonType.custom)
        b.left = kSpacing
        b.top = labelTitle.bottom + 15
        b.size = CGSize(width: kContentWidth, height: kContentWidth * 0.25)
        b.setBackgroundImage(UIImage(named: "dicover_join_member"), for: UIControl.State.normal)
        b.setBackgroundImage(UIImage(named: "dicover_join_member"), for: UIControl.State.highlighted)
        
        return b
    }()
    
    private lazy var lineBottom: CALayer = {
        let line = CALayer()
        line.backgroundColor = UIColor.colorWidthHexString(hex: "1A1A1A").cgColor
        line.frameSize = CGSize(width: kScreenWidth, height: 10)
        line.top = height - 10
        line.left = 0
        return line
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class CustomerHeadView: UIView {
    
    let subject_headview = PublishSubject<CGFloat>()
    
    
    let descHeight = "百威中国，马牌中国，联合利华，外滩悦榕庄，香格里拉，宜家，迈凯伦，兰博基尼，保时捷中国，雷诺F1，捷豹，奔驰，奥迪，大众，Roger Dubuis，TAG Heuer，adidas，PUMA，GQ杂志，鹅岛啤酒，多芬，欢乐颂，嘉实多机油，映客直播，斗鱼直播，花椒直播，Yeti，VOGUE，MOOK，UBER，BOILER ROOM，SSCC，19CLUB …出乎意料吧，一个个知名的品牌和企业都已是本森的合作伙伴。\n时尚、高端就是本森的代名词。得天独厚的黄金地理位置，极具特色的现代工厂风独栋会所，以及具有超凡敬业精神的精英团队。如果您还在为找不到合适的场地而发愁，马上来本森吧！我们将会给您一个不同以往的全新体验，一个出乎意料的完美展现。\n一如既往专注于您的需求，提升您的感受。保持热情、可靠、周全的服务是本森对您的承诺。\n\n本森BensonSupercarClub —— 无处不在\n本森上海 • 上海黄浦区中山南路1029号幸福码头4号楼\n本森北京 • 北京朝阳区醉库国际艺术区A-1".heightString(font: UIFont.systemFont(ofSize: 15), width: kContentWidth)

    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 240)
        super.init(frame: selfFrame)
        
        addSubview(labelTitle)
        addSubview(btnDown)
    }
    
    @objc func clickDown() {
        btnDown.removeFromSuperview()
        height = descHeight + 30
        UIView.animate(withDuration: 0.1, animations: {
            self.labelTitle.height = self.descHeight
        }) { (finish) in
            self.subject_headview.onNext(self.height)
        }
    }
    private lazy var labelTitle: UILabel = {
        let title = UILabel()
        title.origin = CGPoint(x: kSpacing, y: 10)
        title.size = CGSize(width: kContentWidth, height: 180)
        title.numberOfLines = 0
        title.font = UIFont.systemFont(ofSize: 15)
        title.textColor = UIColor.colorWidthHexString(hex: "666666")
        title.text = "百威中国，马牌中国，联合利华，外滩悦榕庄，香格里拉，宜家，迈凯伦，兰博基尼，保时捷中国，雷诺F1，捷豹，奔驰，奥迪，大众，Roger Dubuis，TAG Heuer，adidas，PUMA，GQ杂志，鹅岛啤酒，多芬，欢乐颂，嘉实多机油，映客直播，斗鱼直播，花椒直播，Yeti，VOGUE，MOOK，UBER，BOILER ROOM，SSCC，19CLUB …出乎意料吧，一个个知名的品牌和企业都已是本森的合作伙伴。\n时尚、高端就是本森的代名词。得天独厚的黄金地理位置，极具特色的现代工厂风独栋会所，以及具有超凡敬业精神的精英团队。如果您还在为找不到合适的场地而发愁，马上来本森吧！我们将会给您一个不同以往的全新体验，一个出乎意料的完美展现。\n一如既往专注于您的需求，提升您的感受。保持热情、可靠、周全的服务是本森对您的承诺。\n\n本森BensonSupercarClub —— 无处不在\n本森上海 • 上海黄浦区中山南路1029号幸福码头4号楼\n本森北京 • 北京朝阳区醉库国际艺术区A-1"
        return title
    }()
    
    lazy var btnDown: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.size = CGSize(width: 100, height: 30)
        btn.left = (width - 100) * 0.5
        btn.top = height - 40
//        btn.backgroundColor = UIColor.purple
        btn.setImage(UIImage(named: "zhankai_benson"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(clickDown), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
