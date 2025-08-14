//
//  SuperView.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/5/24.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import UIKit
import Localize_Swift

class SuperView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguageUI), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
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
extension SuperView {
    @objc func setUpUI() {
        backgroundColor(.clear)
    }
}

//MARK: ----------切换语言-----------
extension SuperView {
    @objc func updateLanguageUI() {
        // 子类重写此方法实现具体更新逻辑
    }
}
