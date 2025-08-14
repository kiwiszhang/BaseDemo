//
//  NavigationController.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/5/5.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    //MARK: ----------懒加载-----------
    private lazy var backBtn: NavigationBackBtn = {
        let backBtn = NavigationBackBtn.init(frame: CGRect.init(x: 0, y: 0, width: 44.0, height: 44.0), obj: self, methord: #selector(backBtnMethord))
        return backBtn
    }()
    //MARK: ----------系统方法-----------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactivePopGestureRecognizer?.delegate = self
        setValue(NavigationBar(), forKey: "navigationBar")
        setAppearance()
    }
}
//MARK: ----------UIGestureRecognizerDelegate-----------
extension NavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return children.count > 1
    }
}
//MARK: ----------UINavigationControllerDelegate-----------
extension NavigationController: UINavigationControllerDelegate {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if !children.isEmpty {
            viewController.hidesBottomBarWhenPushed = true
            
            viewController.navigationItem.backBarButtonItem = UIBarButtonItem()
            viewController.navigationItem.hidesBackButton = true
            viewController.navigationItem.setLeftBarButton(UIBarButtonItem.init(customView: backBtn), animated: true)
        }
        super.pushViewController(viewController, animated: animated)
    }
}
//MARK: ----------其他-----------
extension NavigationController {
    @objc private func backBtnMethord() {
        popViewController(animated: true)
    }
    private func setAppearance() {
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = UIColor.white
            appearance.backgroundEffect = nil
            self.navigationBar.standardAppearance = appearance
            self.navigationBar.scrollEdgeAppearance = appearance
        }
    }
}
