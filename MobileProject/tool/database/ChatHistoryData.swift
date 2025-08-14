//
//  ChatHistoryData.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/7/22.
//

import UIKit

class ChatHistoryData: SuperModel,Codable {
    /// 是否为群聊
    var isGroup:Bool = false
    /// 是否为demo数据
    var isDemo:Bool = false
    /// 生成时间
    var generatTime:String!
    ///  人名或者群名
    var name:String!
    
    //MARK: - 个人第一张报告
    /// 前十条消息
//    var firstTenChatMessage: [ChatMessage]?
    var firstTenChatMessage: String?

    //MARK: - 个人第二张报告
    /// 总消息数量
    var totalMessages: Int = 0
    /// 平均每天消息数量
    var averageMessagesPerDay: Double = 0.0
    
    //MARK: - 个人第三和第四张报告
    /// 每个人使用的表情排名，是每个人使用多少个表情，每个表情使用数量
//    var memberMostUsedEmojis: [String: [EmojiCount]] = [:]
    var memberMostUsedEmojis: String?

    //MARK: - 个人第五张报告
    /// 自己高频词汇使用
//    var highFrequencyWords: [WordCount] = []
    var highFrequencyWords: String?
    //MARK: - 个人第六张报告
    /// 别人高频词汇使用
//    var highOtherFrequencyWords: [WordCount] = []
    var highOtherFrequencyWords: String?
    //MARK: - 个人第七张报告
    /// 每个人每月或者每周聊天回复速度
//    var perManReplyFast:[String: [keyCount]] = [:]
    var perManReplyFast:String?
    //MARK: - 个人第八张报告
    /// 每个人每月或者每周聊天总数量
//    var perManPerMounthCount:[String: [keyCount]] = [:]
    var perManPerMounthCount:String?
    //MARK: - 个人第九张报告
    /// 已读未回消息排名
//    var unreadGhostingRanking: [nameCount] = []
    var unreadGhostingRanking: String?
    var unreadGhostingRankingNewHandle: String?
    //MARK: - 个人第十张报告
    /// 哪一天消息最多
//    var messagePeakDay: PeakDay?
    var messagePeakDay: String?
    //MARK: - 个人第十一张报告
    /// 每个人话费的聊天时间
//    var personalTimeSpentPerUser: [String: Int] = [:]
    var personalTimeSpentPerUser: String?
    /// 每天消息数量
//    var messageCountsPerDayForChart: [dateCount] = []
    var messageCountsPerDayForChart: String?
    //MARK: - 个人第十二张报告
    /// 最长聊天天数
//    var longDaysChat: LongChatRange = LongChatRange(startStr: "", endStr: "", days: 0)
    var longDaysChat: String?

    
    //MARK: - 群聊的报告
    /// 每个人聊天数量
    //var memberMessageRanking: [nameCount] = []
    var memberMessageRanking: String?
    /// 使用表情数
    //var mostUsedEmoji:[nameEmojiCount] = []
    var mostUsedEmoji: String?
    /// 过滤后的回复速度
//    var memberFilterReplySpeedRanking: [nameAvgTime] = []
    var memberFilterReplySpeedRanking: String?
}



