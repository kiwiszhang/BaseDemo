//
//  AppDelegate.swift
//  MobileProject
//
//  Created by Yu on 2025/4/5.
//

import UIKit
import FirebaseCore
import Localize_Swift
import FirebaseCrashlytics

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var allowLandscapeRight = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //内购代码
        loadUserInfo()
        //应用分析
        startAppInfo()
        //创建表
        creatTable()
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if allowLandscapeRight {
            return .landscapeRight
        }
        return .portrait
    }
}

private
extension AppDelegate {
    func loadUserInfo() {
        SubscriptionManager.shared.loadAllProducts()
        if !isPremiumUser {
            // 非会员重置状态
        }
    }
    
    //Firebase
    func startAppInfo() {
        EventReport.config()
        FirebaseApp.configure()
        let crashlytics = Crashlytics.crashlytics()
#if DEBUG
        crashlytics.setCustomValue("developer", forKey: "environment")
#else
        crashlytics.setCustomValue("production", forKey: "environment")
#endif
        crashlytics.log("Crashlytics.crashlytics 开始")
        crashlytics.setCustomValue(kkAppVersion, forKey: "app_version")
        crashlytics.setCustomValue(kkBuildNumber, forKey: "build_number")
        crashlytics.setCustomValue(kkSystemVersion, forKey: "kkSystem_Version")
        crashlytics.setCustomValue(kkDeviceModelCode, forKey: "kkDeviceModel_Code")
        crashlytics.setCustomValue(kkLanguage, forKey: "kkLanguage")
        crashlytics.setCustomValue(kkRegion, forKey: "kkRegion")

//        DispatchQueue.global().asyncAfter(deadline: .now() + 26) {
//            let arr:[String] = ["fff"]
//            let str = arr[2]
//        }
//        let simpleError = NSError(
//            domain: "com.xxxxxx.domain",
//            code: 1001,
//            userInfo: [NSLocalizedDescriptionKey: "文件8989898989899读取失败"]
//        )
//        Crashlytics.crashlytics().record(error: simpleError)
        
//        if FirebaseApp.app() == nil {
//            print("Firebase 未初始化！")
//        } else {
//            print("Firebase 已初始化，当前配置: \(FirebaseApp.app()!.options)")
//        }
//        Crashlytics.crashlytics().checkForUnsentReports { hasUnsent in
//            print("存在未上传的报告: \(hasUnsent)")
//            if hasUnsent {
//                Crashlytics.crashlytics().sendUnsentReports()
//            }
//        }
        
    }
    
    ///
    func creatTable(){
//        Localize.setCurrentLanguage("en")
        DataBaseTool.sharedInstance.creatTable(model: ChatHistoryData())
    }
}

