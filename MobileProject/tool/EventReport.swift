//
//  EventReport.swift
//  teleprompter
//
//  Created by 笔尚文化 on 2025/4/29.
//

import Foundation
import TrackReport

struct EventReport {
    enum CustomEvent: String {
        ///进入引导订阅页
        case entryGuidSubscriptionPage = "2915"
        ///进入引导订阅挽留页
        case entryGuidRetrieveSubscriptionPage = "2916"
        ///点击首页Get ALL按钮
        case clickHomeGetAll = "2917"
        ///设置页进订阅页埋点
        case settingPageEntrySubscribtion = "2918"
        ///点击邀请好友
        case clickInvaite = "2919"
        ///私聊进入whatsApp
        case privateEntryWhatApp = "2920"
        ///群聊进入whatsApp
        case groupEntryWhatApp = "2921"
        
    }
    
    static func config() {
        TrackReportKit.config(appId: "62")
    }
    
    static func registerUser() {
#if !DEBUG
        TrackReportKit.registerUser()
#endif
    }
    
    static func subscription(with transactionId: String, isAutomaticRenewal: Bool) {
#if !DEBUG
        TrackReportKit.subscription(with: transactionId, page: isAutomaticRenewal ? .automaticRenewal : .newSubscription)
#endif
    }
    
    static func subscriptionSuccess(from event: CustomEvent, behaviorContent: String? = nil) {
#if !DEBUG
        TrackReportKit.customEvent(with: event.rawValue, behaviorContent: behaviorContent)
#endif
    }
    
    static func reportFeatureRequest(with desc: String) {
#if !DEBUG
//        TrackReportKit.customEvent(with: CustomEvent.featureRequest.rawValue, behaviorContent: desc)
#endif
    }
    
    static func checkAppVersion() async -> String? {
#if !DEBUG
        return await withCheckedContinuation { continuation in
            TrackReportKit.checkAppVersionWithAutoPopAlter {
                continuation.resume(returning: $0)
            }
        }
#else
        return "\(Int.max)"
#endif
    }
}


extension EventReport {
    enum ABTestType: String, CaseIterable {
        case delayTime = "40"
        case appIconChange = "43"
//        case retrieve = "19"
//        case homeAlert = "31"
    }
    
    static func getABTestConfig(with type: ABTestType) async -> String? {
        #if DEBUG
            return nil
        #else
            return await withCheckedContinuation { continuation in
                TrackReportKit.getAppConfig(with: type.rawValue) {
                    continuation.resume(returning: $0)
                }
            }
        #endif
    }
}
