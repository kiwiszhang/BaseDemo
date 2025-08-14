//
//  AppHelper.swift
//  teleprompter
//
//  Created by 笔尚文化 on 2024/11/25.
//

import Localize_Swift
import SafariServices
import UIKit

public final class AppHelper {
    enum AppHelperUserDefaultsKeys: String {
        case isWaiting = "AppHelperUserDefaultsKeys_isWaiting"
        case isFirstOpenApp = "AppHelperUserDefaultsKeys_isFirstOpenApp"
        case isShowGuidView = "AppHelperUserDefaultsKeys_isShowGuidView"

        
        case ABTest_delayTimeValue = "AppHelperUserDefaultsKeys_ABTest_delayTimeValue"
        case ABTest_retrieveValue = "AppHelperUserDefaultsKeys_ABTest_retrieveValue"
        case ABTest_homeAlertValue = "AppHelperUserDefaultsKeys_ABTest_homeAlertValue"
        case ABTest_AppIconChangeValue = "AppHelperUserDefaultsKeys_ABTest_AppIconChangeValue"
    }

    
    // MARK: - Public

    /// 是否为Waitting状态
    @UserDefault(AppHelperUserDefaultsKeys.isWaiting.rawValue, defaultValue: true)
    static var isWaiting: Bool
    /// 配置首次打开app需要做的操作
    @UserDefault(AppHelperUserDefaultsKeys.isFirstOpenApp.rawValue, defaultValue: true)
    static var isFirstOpenApp: Bool
    
    /// 是否显示引导页
    @UserDefault(AppHelperUserDefaultsKeys.isShowGuidView.rawValue, defaultValue: true)
    static var isShowGuidView: Bool

    /// 各营销订阅页面按钮隐藏时间（秒）
    @UserDefault(AppHelperUserDefaultsKeys.ABTest_delayTimeValue.rawValue, defaultValue: 5)
    static var ABTest_delayTimeValue: Double
    
    /// 挽留页AB测试的值
    @UserDefault(AppHelperUserDefaultsKeys.ABTest_retrieveValue.rawValue, defaultValue: "A")
    static var ABTest_retrieveValue: String
    /// 首页弹窗AB测试（A评价轮播，B设置订阅页，C无弹窗）
    @UserDefault(AppHelperUserDefaultsKeys.ABTest_homeAlertValue.rawValue, defaultValue: "A")
    static var ABTest_homeAlertValue: String
    
    /// App图标选择
    @UserDefault(AppHelperUserDefaultsKeys.ABTest_AppIconChangeValue.rawValue, defaultValue: "AppIcon")
    static var ABTest_AppIconChangeValue: String

    static func launch(with window: UIWindow?) {
        #if DEBUG
//            let abTextConfigVC = ABTestDebugConfigPage()
//            abTextConfigVC.dismissHandler = {
//                if AppHelper.isWaiting {
//                    window?.rootViewController = LaunchViewController()
//                } else {
//                    AppHelper.getABTestConfig()
//                    window?.showMainOrBuyWithPermium()
//                    AppHelper.checkAppVersion()
//                }
//            }
//            window?.rootViewController = UINavigationController(rootViewController: abTextConfigVC)
            window?.showMainViewController()
        #else
            if AppHelper.isWaiting {
                window?.rootViewController = LaunchViewController()
            } else {
                AppHelper.getABTestConfig()
                window?.showMainOrBuyWithPermium()
                AppHelper.checkAppVersion()
            }
        #endif
    }
    
    static func changeAppIcon(to iconName: String?) {
        var newName = iconName
        if newName == "AppIcon" {
            newName = nil
        }
        
        // iconName 传 nil 表示切回默认
        guard UIApplication.shared.supportsAlternateIcons else {
            print("不支持动态更换图标")
            return
        }

        UIApplication.shared.setAlternateIconName(newName) { error in
            if let error = error {
                print("更换图标失败：\(error.localizedDescription)")
            } else {
                print("图标已更换为 \(newName ?? "默认")")
            }
        }
    }

    /// 获取当前正在显示控制器
    static func currentViewController() -> UIViewController? {
        var resultVC = _topViewController(kkKeyWindow()?.rootViewController)
        while resultVC?.presentedViewController != nil {
            resultVC = _topViewController((resultVC?.presentedViewController)!
            )
        }
        return resultVC
    }

    static func getABTestConfig() {
        Task {
            // 请求ABTest配置
            if let value = await EventReport.getABTestConfig(with: .delayTime), let duration = Double(value) {
                AppHelper.ABTest_delayTimeValue = duration
            }
//            if let value = await EventReport.getABTestConfig(with: .retrieve) {
//                AppHelper.ABTest_retrieveValue = value
//            }
//            if let value = await EventReport.getABTestConfig(with: .homeAlert) {
//                AppHelper.ABTest_homeAlertValue = value
//            }
            if let value = await EventReport.getABTestConfig(with: .appIconChange) {
                AppHelper.ABTest_AppIconChangeValue = value
            }
        }
    }

    static func checkAppVersion() {
        Task {
            await EventReport.checkAppVersion()
        }
    }

    static func showHomeAlert() {
        guard !isPremiumUser && !AppHelper.isWaiting else { return }
        if ABTest_homeAlertValue == "A" {
//            currentViewController()?.present(NewGuidSpecialViewController(isFromHomePage: true), animated: true)
        } else if ABTest_homeAlertValue == "B" {
//            currentViewController()?.present(BuyViewController(isFromHomeAlert: true), animated: true)
//            currentViewController()?.present(BuyViewController(), animated: true)
        }
    }

    static func showWebPage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let safariVC = SFSafariViewController(url: url)
        currentViewController()?.present(safariVC, animated: true)
    }

    static func clearTemporaryDirectory(complete: (() -> Void)? = nil) {
        Task {
            let fileManager = FileManager.default
            do {
                let tempFolderPath = NSTemporaryDirectory()
                var filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath).map { (tempFolderPath as NSString).appendingPathComponent($0) }

                let documentDirectory = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let inBoxPath = documentDirectory?.appendingPathComponent("Inbox")
                if let inBoxPath, fileManager.fileExists(atPath: inBoxPath.path) {
                    filePaths.append(contentsOf: try fileManager.contentsOfDirectory(atPath: inBoxPath.path).map { (inBoxPath.path as NSString).appendingPathComponent($0) })
                }

                try filePaths.forEach { filePath in
                    try fileManager.removeItem(atPath: filePath)
                }
                await MainActor.run {
                    complete?()
                }
            } catch {
                MyLog("清理临时文件失败: \(error.localizedDescription)")
                await MainActor.run {
                    complete?()
                }
            }
        }
    }
}

// MARK: - Private

private extension AppHelper {
    static func _topViewController(_ vc: UIViewController?) -> UIViewController? {
        if let vc = vc as? UINavigationController {
            return _topViewController(vc.topViewController)
        } else if let vc = vc as? UITabBarController {
            return _topViewController(vc.selectedViewController)
        } else {
            return vc
        }
    }
}
