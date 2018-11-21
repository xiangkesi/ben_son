//
//  NewFeaturesView.swift
//  ben_son
//
//  Created by ZS on 2018/8/29.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import FLAnimatedImage

public enum DataType: String {
    case gif    = "gif"
    case png    = "png"
    case jpeg   = "jpeg"
    case tiff   = "tiff"
    case defaultType
}

class NewFeaturesView: UIView {
    
    private var imageModels = [FratureModel]()
    
    private var currentIndex: Int = 0
    
    private weak var flowLayout: UICollectionViewFlowLayout?
    
    override init(frame: CGRect) {
        let selfFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        super.init(frame: selfFrame)
        addSubview(collectionView)
    }
    
    class func showImages(arrayImages: [String]) {
        let fratureView = NewFeaturesView()
        kRootVc?.view.addSubview(fratureView)        
        DispatchQueue.global().async {
            for (index, imageName) in arrayImages.enumerated() {
                let urlString = Bundle.main.url(forResource: imageName, withExtension: nil)
                let imageData: Data? = try? Data.init(contentsOf: urlString!, options: Data.ReadingOptions.uncached)
                let model = FratureModel()
                if checkDataType(data: imageData) == DataType.gif {
                    let animatedImage = FLAnimatedImage.init(animatedGIFData: imageData)
                    model.isAnimImage = true
                    model.imageAnim = animatedImage
                }else{
                    model.imageNormal = imageData
                    model.isAnimImage = false
                }
                model.hiddenButtonSkip = (index == arrayImages.count - 1) ? false : true
                fratureView.imageModels.append(model)
            }
            DispatchQueue.main.async(execute: {
                fratureView.collectionView.reloadData()
            })
        }
    }
    
    
    deinit {
        collectionView.delegate = nil
        collectionView.dataSource = nil
        print("销毁了")
    }
    
    //DispatchQueue.global().async {
    //    print("处理耗时任务\(Thread.current)")
    //    Thread.sleep(forTimeInterval: 2.0)
    //    let arrayD:[String] = ["小王","校长","小李"]
    //
    //    DispatchQueue.main.async(execute: {
    //        print("主线程更新UI \(Thread.current)")
    //        complection(arrayD,100)
    //    })
    //}
    //DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.4) {
    //
    //    self.scrollViewDidEndDecelerating(self.adScrollView)
    //
    //}
    
    //perform(#selector(scrollViewDidEndDecelerating), with: self, afterDelay: 0.4)
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kScreenWidth, height: kScreenHeight)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        flowLayout = layout
        let collection = UICollectionView.init(frame: CGRect(), collectionViewLayout: layout)
        collection.isPagingEnabled = true
        collection.origin = CGPoint(x: 0, y: 0)
        collection.size = CGSize(width: kScreenWidth, height: height)
        collection.register(NewFeaturesViewCell.self, forCellWithReuseIdentifier: "NewFeaturesViewCell")
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NewFeaturesView: UICollectionViewDelegate, UICollectionViewDataSource  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewFeaturesViewCell", for: indexPath) as! NewFeaturesViewCell
        cCell.frature = imageModels[indexPath.row]
        return cCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        UIView.animate(withDuration: 1.0, animations: {
            self.alpha = 0.0
        }) { (finish) in
            self.removeFromSuperview()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if imageModels.count > 0 {
            if currentIndex != getCurrentIndex() {
                currentIndex = getCurrentIndex()
            
            }
        }
    }
//    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//
//    }
    
    private class func checkDataType(data: Data?) -> DataType {
        guard data != nil else {
            return .defaultType
        }
        let c = data![0]
        switch (c) {
        case 0xFF:
            return .jpeg
        case 0x89:
            return .png
        case 0x47:
            return .gif
        case 0x49, 0x4D:
            return .tiff
        default:
            return .defaultType
        }
    }
    
    private func getCurrentIndex() -> Int {
        return Int((collectionView.contentOffset.x + (flowLayout?.itemSize.width)! * 0.5) / (flowLayout?.itemSize.width)!)
    }
}

class NewFeaturesViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(animAtedView)
        contentView.addSubview(buttonSkip)
    }
    var frature: FratureModel? {
        didSet{
            if (frature?.isAnimImage)! {
                animAtedView.animatedImage = frature?.imageAnim
            }else{
                animAtedView.image = UIImage.init(data: (frature?.imageNormal)!)
            }
            buttonSkip.isHidden = (frature?.hiddenButtonSkip)!
        }
    }
    
    lazy var animAtedView: FLAnimatedImageView = {
        let viewAnim = FLAnimatedImageView.init()
        viewAnim.origin = CGPoint(x: 0, y: 0)
        viewAnim.size = CGSize(width: kScreenWidth, height: kScreenHeight)
        viewAnim.contentMode = .scaleAspectFill
        viewAnim.clipsToBounds = true
        viewAnim.loopCompletionBlock = { (loopCountRemaining) in
//            print(loopCountRemaining)
//            viewAnim.animationRepeatCount = 1

        }
        return viewAnim
    }()
    
//    @property (nonatomic, copy) void(^loopCompletionBlock)(NSUInteger loopCountRemaining);

    
    private lazy var buttonSkip: UIButton = {
        let skip = UIButton()
        skip.size = CGSize(width: 80, height: 30)
        skip.top = height - 50
        skip.left = width * 0.5 - 40
        skip.backgroundColor = UIColor.red
        skip.isHidden = true
        return skip
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FratureModel {
    
    var imageNormal: Data?
    
    var imageAnim: FLAnimatedImage?
    
    var isAnimImage: Bool = false
    
    var hiddenButtonSkip: Bool = false
    
    
}
