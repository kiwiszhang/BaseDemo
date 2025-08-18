//
//  PersistenceController.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/8/15.
//


import CoreData

final class CoerDataPersistenceController {
    static let shared = CoerDataPersistenceController()
    let container: NSPersistentContainer
    init() {
        container = NSPersistentContainer(name: "MyModel") // 对应 .xcdatamodeld 文件名
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("❌ 加载数据库失败: \(error)")
            }
        }
    }
}
