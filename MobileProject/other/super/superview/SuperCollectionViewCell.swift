//
//  SuperCollectionViewCell.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/5/7.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import UIKit

class SuperCollectionViewCell: UICollectionViewCell {
    //MARK: ----------懒加载-----------
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpUI()
    }
    var collectionView: UICollectionView {
        get {
            var collectionView = superview
            while collectionView != nil && collectionView!.isKind(of: UICollectionView.classForCoder()) {
                collectionView = collectionView?.superview
            }
            return collectionView as! UICollectionView
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
}
//MARK: ----------UI-----------
extension SuperCollectionViewCell {
    @objc func setUpUI() {
        if #available(iOS 14.0, *) {
            backgroundConfiguration = UIBackgroundConfiguration.clear()
        }
        backgroundColor(.clear)
    }
}
