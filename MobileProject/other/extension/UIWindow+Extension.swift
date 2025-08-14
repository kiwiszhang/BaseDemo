//
//  UIWindow+Extension.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/5/20.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import UIKit

extension UIWindow {
    /// 切换根控制器
    private func switchRootViewController(_ newRootVC: UIViewController, animated: Bool = true) {
        guard animated else {
            rootViewController = newRootVC
            return
        }

        UIView.transition(with: self,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
            self.rootViewController = newRootVC
        })
    }
    
    func showInitialViewController() {
//        if VersionTool.shouldShowGuide() {
        if AppHelper.isShowGuidView {
            AppHelper.isShowGuidView = false
            // 显示引导页
//            switchRootViewController(GuidViewController())
        } else {
            // 进入引导购买页
            showGuidBuyViewController()
        }
    }
    
    func showMainOrBuyWithPermium(){
        if let window = kkKeyWindow() {
            if !isPremiumUser {
                window.showInitialViewController()
            }else{
                window.showMainViewController()
            }
        }
    }
    
    /// 显示主界面
    func showMainViewController() {
//        let mainVC = NavigationController(rootViewController: ViewController())
        let tabVC = MainTabBarController()
        switchRootViewController(tabVC)
    }
    
    /// 引导购买界面
    func showGuidBuyViewController() {
//        let mainVC = NavigationController(rootViewController: BuyDisCountGuidViewController())
//        switchRootViewController(mainVC)
    }
    
    /// 显示进度
    func showLoadingViewController(filePath: String) {
//        // 引导页
//        if rootViewController?.isKind(of: GuidViewController.self) ?? false {
//        }
//        // 正常程序
//        if rootViewController?.isKind(of: NavigationController.self) ?? false {
//            let navVC = rootViewController as! NavigationController
//            navVC.pushViewController(LoadViewController(filePath: filePath), animated: true)
//        }
    }
    /// 显示启动页
    func showLanchViewController(){
        let vc = LaunchViewController()
        self.rootViewController = vc
    }
}
