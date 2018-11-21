//
//  BSHorizontalPageLayout.swift
//  ben_son
//
//  Created by ZS on 2018/9/5.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit

class BSHorizontalPageLayout: UICollectionViewLayout {

    var minimumLineSpacing: CGFloat = 0
    var minimumInteritemSpacing: CGFloat = 0
    var itemSize: CGSize = CGSize(width: 0, height: 0)
    var sectionInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    private var layoutAttributes = [UICollectionViewLayoutAttributes]()
    private var rowCount: Int  = 0
    private var columnCount: Int = 0
    
    override func prepare() {
        if let itemCount = collectionView?.numberOfItems(inSection: 0) {
            for index in 0..<itemCount{
                let indexPath = IndexPath.init(row: index, section: 0)
                if let attr = layoutAttributesForItem(at: indexPath) {
                    layoutAttributes.append(attr)
                }
            }
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attri = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        let item = indexPath.item
        //总页数
        let pageNumber = item / (calculateRowCount() * calculateColumnCount())
        //该页中item的序号
        let itemInPage = Int(CGFloat(item).truncatingRemainder(dividingBy: CGFloat(calculateRowCount() * calculateColumnCount())))
        
        //item
        let col = Int(CGFloat(itemInPage).truncatingRemainder(dividingBy: CGFloat(calculateColumnCount())))
        let row = itemInPage / calculateColumnCount()
        
        let x = sectionInset.left + (itemSize.width + minimumInteritemSpacing) * CGFloat(col) + CGFloat(pageNumber) * (collectionView?.bounds.size.width)!
        
        let y = sectionInset.top + (itemSize.height + minimumLineSpacing) * CGFloat(row)
        
        attri.frame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
        return attri
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes
    }
    
    override var collectionViewContentSize: CGSize {
        let itemCount = collectionView?.numberOfItems(inSection: 0)
        var pageNumber = itemCount! / (calculateRowCount() * calculateColumnCount())
        
        if CGFloat(itemCount!).truncatingRemainder(dividingBy: CGFloat(calculateRowCount() * calculateColumnCount())) >= 1 {
            pageNumber = pageNumber + 1
        }
        return CGSize(width: CGFloat(pageNumber) * (collectionView?.bounds.size.width)!, height: (collectionView?.bounds.size.height)!)
    }
    
    private func calculateRowCount() -> Int {
        if rowCount == 0 {
            let numerator = (collectionView?.bounds.size.height)! - sectionInset.top - sectionInset.bottom + minimumLineSpacing
            let denominator = minimumLineSpacing + itemSize.height
            let count = Int(numerator / denominator)
            rowCount = count
            if numerator.truncatingRemainder(dividingBy: denominator) >= 1 {
                minimumLineSpacing = ((collectionView?.bounds.size.height)! - sectionInset.top - sectionInset.bottom - CGFloat(count) * itemSize.height) / CGFloat(count - 1)
            }
        }
        return rowCount
    }
    
    private func calculateColumnCount() -> Int {
        if columnCount == 0 {
            let numerator = (collectionView?.bounds.size.width)! - sectionInset.left - sectionInset.right + minimumInteritemSpacing
            let denominator = minimumInteritemSpacing + itemSize.width
            let count = Int(numerator / denominator)
            columnCount = count
            if numerator.truncatingRemainder(dividingBy: denominator) >= 1 {
                minimumInteritemSpacing = ((collectionView?.bounds.size.width)! - sectionInset.left - sectionInset.right - CGFloat(count) * itemSize.width) / CGFloat(count - 1)
            }
        }
        return columnCount
    }
    
}
