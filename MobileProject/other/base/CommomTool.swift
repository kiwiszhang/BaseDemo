//
//  TableViewCell.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/7/29.
//

import UIKit

class CommomTool{
    /// 将两个数均分成几等份
     static func divideRange(from start: Double, to end: Double, into parts: Int) -> [Double] {
        guard start < end, parts > 1 else {
            return []
        }
        
        let range = end - start
        let step = range / Double(parts - 1)
        
        return (0..<parts).map { i in
            let point = start + (step * Double(i))
            return round(point * 10) / 10  // 保留一位小数
        }
    }
    
    /// 打开WhatApp
//    static func openWhatAppAction(chatType:InfoType) {
//        if let url = URL(string: "whatsapp://") {
//            if UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                // 应用未安装，跳转到 App Store
//                let appStoreURL = URL(string: "https://apps.apple.com/app/twitter/id310633997")!
//                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
//            }
//        }
//        
//        if chatType == .group {
//            EventReport.subscriptionSuccess(from: .groupEntryWhatApp)
//        }else{
//            EventReport.subscriptionSuccess(from: .privateEntryWhatApp)
//        }
//    }

    /// 时间字符串2025-07-29 09:28:12   转为   29 July 2025, 9:28   这种字符串
    static func convertDateStringToen_US(_ dateString: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = inputFormatter.date(from: dateString) else {
            return nil
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMMM yyyy, h:mm"
        outputFormatter.locale = Locale(identifier: "en_US")

        return outputFormatter.string(from: date)
    }
    
    /// date格式 2025-03-27 07:53:15 +0000  转为   27 March 2025   这种字符串
    static func convertDateToen_US(_ date: Date) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX") // 确保月份是英文
        return formatter.string(from: date)
    }
    
    /// date格式 2025-07-23 07:53:15 +0000  转为  July 23, 2025   这种字符串
    static func convertDateToen_US_0(_ date: Date) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy" // "July 23, 2025"
        formatter.locale = Locale(identifier: "en_US_POSIX") // 确保月份是英文
        return formatter.string(from: date)
    }
    
    /// date格式 2025-03-27 07:53:15 +0000  转为   27/03/ 2025   这种字符串
    static func convertDateToddMMyyy(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }
    
    /// 获取当前时间 "yyyy-MM-dd HH:mm:ss"  "yyyy-MM-dd " 等
    static func currentTimeString(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: Date())
    }
    
    /// 订阅
    static func purchaseProduct(type:SubscriptionManager.SubscriptionType,completion: @escaping (Bool) -> Void) {
        if isPremiumUser {
            MBProgressHUD.showMessage(L10n.mbEnableBuy)
            return
        }

        DispatchQueue.main.async {
            Task {
                do {
                    try await SubscriptionManager.shared.purchase(type)
                    print("购买成功")
//                    MBProgressHUD.showMessage(L10n.mbBuySuccess)
                    completion(true)
                } catch SubscriptionManager.SubscriptionError.paymentCancelled {
                    print("用户取消了支付")
//                    MBProgressHUD.showMessage(L10n.mbBuyError)
                    completion(false)
                } catch SubscriptionManager.SubscriptionError.productNotFound {
                    print("找不到商品")
//                    MBProgressHUD.showMessage(L10n.mbBuyError)
                    completion(false)
                } catch SubscriptionManager.SubscriptionError.receiptValidationFailed {
                    print("订阅验证失败")
//                    MBProgressHUD.showMessage(L10n.mbBuyError)
                    completion(false)
                } catch SubscriptionManager.SubscriptionError.purchaseFailed(let error) {
                    print("购买失败，错误：\(error.localizedDescription)")
//                    MBProgressHUD.showMessage(L10n.mbBuyError)
                    completion(false)
                } catch {
                    print("未知错误：\(error)")
//                    MBProgressHUD.showMessage(L10n.mbBuyError)
                    completion(false)
                }
            }
        }
    }
    
}
