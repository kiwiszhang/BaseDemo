//
//  SuperTableViewHeaderFooterView.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/5/24.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import UIKit

class SuperTableViewHeaderFooterView: UITableViewHeaderFooterView {
    //MARK: ----------初始化方法-----------
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
}

//MARK: ----------UI-----------
extension SuperTableViewHeaderFooterView {
    @objc func setUpUI() {
        contentView.backgroundColor(.clear)
        if #available(iOS 14.0, *) {
            backgroundConfiguration = UIBackgroundConfiguration.clear()
        }
    }
}
