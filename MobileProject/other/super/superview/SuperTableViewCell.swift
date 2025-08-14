//
//  SuperTableViewCell.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/5/5.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import UIKit
import Localize_Swift

class SuperTableViewCell: UITableViewCell {
    //MARK: ----------懒加载-----------
    var tableView: UITableView {
        get {
            var tableView = superview
            while tableView != nil && tableView!.isKind(of: UITableView.classForCoder()) {
                tableView = tableView?.superview
            }
            return tableView as! UITableView
        }
    }
    //MARK: ----------初始化方法-----------
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
extension SuperTableViewCell {
    @objc func setUpUI() {
        if #available(iOS 14.0, *) {
            backgroundConfiguration = UIBackgroundConfiguration.clear()
        }
        backgroundColor(.clear)
        selectionStyle = .none
    }
}
//MARK: ----------切换语言-----------
extension SuperTableViewCell {
    @objc func updateLanguageUI() {
        // 子类重写此方法实现具体更新逻辑
    }
}
