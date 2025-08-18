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
import CloudKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var allowLandscapeRight = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //内购代码
        loadUserInfo()
        //应用分析
        startAppInfo()
        //创建表
        creatTable()
        // cloud处理
        iCloudHandle(application)
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if allowLandscapeRight {
            return .landscapeRight
        }
        return .portrait
    }
    
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        CloudKitPhotoManager.handleNotification(with: userInfo)
        completionHandler(.newData)
    }

}

private
extension AppDelegate {
    
    func iCloudHandle(_ application: UIApplication) {
        // 请求通知权限
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
        // 注册订阅（比如监听 Person 表）
        CloudKitPhotoManager.creatSubscription(to: RecordType.personType.rawValue)
    }
    
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


