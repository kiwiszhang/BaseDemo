//
//  PurchaseTableHeaderView.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/7/31.
//

import UIKit

class PurchaseTableHeaderView: SuperTableViewHeaderFooterView {
    // MARK: -  =====================lazyload=========================
    private let subLab1: UILabel = {
        return UILabel().color(.black).hnFont(size: 16.h)
    }()
    // MARK: -  =====================Intial Methods===================
    override func setUpUI() {
        self.addSubView(subLab1)
        subLab1.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    // MARK: -  =======================actions========================
    func configure(with item: String) {
        subLab1.text(item)
    }
    
    
    // MARK: -  =====================delegate=========================
    
}
