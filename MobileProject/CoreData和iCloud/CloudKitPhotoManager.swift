//
//  iCloudRecordAssetViewController.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/8/15.
//

import UIKit
import CloudKit

/// 对应的iCloud后台表
enum RecordType:String {
    case personType = "Person"
}

/// 图片存储路径文件夹
let kkAsstePhotosPath = "Assetphotos"

class CloudKitPhotoManager {
    /// 查询所有数据
    static func queryFromRecord(completion: @escaping ([CKRecord], (any Error)?) -> Void){
        let container = CKContainer(identifier: iCloudContainerID)
        // 访问私有数据库
        container.accountStatus { accountStatus, error in
            if let error = error {
                print("获取 iCloud 账号状态失败: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion([],error)
                }
                return
            }
            switch accountStatus {
                case .available:
                    print("iCloud 可用 ✅")
                    // 获取私有数据库实例
                    let db = container.privateCloudDatabase
                    let query = CKQuery(recordType: RecordType.personType.rawValue, predicate: NSPredicate(value: true))
                    // 查询数据
                    var allRecords: [CKRecord] = []

                    func fetchPage(cursor: CKQueryOperation.Cursor? = nil) {
                        if let cursor = cursor {
                            // 使用游标继续分页
                            db.fetch(withCursor: cursor, completionHandler: handleResult)
                        } else {
                            // 第一次查询
                            db.fetch(withQuery: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: CKQueryOperation.maximumResults, completionHandler: handleResult)
                        }
                    }
                    func handleResult(result: Result<(matchResults: [(CKRecord.ID, Result<CKRecord, Error>)], queryCursor: CKQueryOperation.Cursor?), Error>) {
                        switch result {
                        case .failure(let error):
                            DispatchQueue.main.async {
                                completion(allRecords, error)
                            }

                        case .success(let (matchResults, cursor)):
                            for (recordID, recordResult) in matchResults {
                                switch recordResult {
                                case .success(let record):
                                    allRecords.append(record)
                                case .failure(let error):
                                    print("⚠️ Record fetch error for \(recordID): \(error)")
                                }
                            }
                            
                            if let cursor = cursor {
                                // 递归继续分页
                                fetchPage(cursor: cursor)
                            } else {
                                // 没有更多了
                                DispatchQueue.main.async {
                                    completion(allRecords, nil)
                                }
                            }
                        }
                    }

                    // 开始第一次请求
                    fetchPage()
                case .noAccount:
                    print("用户未登录 iCloud")
                case .restricted:
                    print("iCloud 使用受限")
                case .couldNotDetermine:
                    print("无法确定 iCloud 状态")
                case .temporarilyUnavailable:
                    print("暂时不可用")
                @unknown default:
                    print("未知状态")
                }

        }
    }
    /// 添加数据到云
    static func addNewItemToRecord(completion:@escaping ((any Error)?) -> Void){
        let container = CKContainer(identifier: iCloudContainerID)
        // 1. 访问私有数据库
        container.accountStatus { accountStatus, error in
            if let error = error {
                print("获取 iCloud 账号状态失败: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            switch accountStatus {
                case .available:
                    print("iCloud 可用 ✅")
                    // 1.2 获取私有数据库实例
                    let db = container.privateCloudDatabase
                    // 新增数据
                    let record = CKRecord(recordType: RecordType.personType.rawValue)
                    record["age"] = Int.random(in: 18...80) as CKRecordValue
                    let title = "imageName\(Int.random(in: 0..<10000))"
                    record["title"] = title as CKRecordValue
                    
                    let imageName = UserDefaults.standard.string(forKey: "imageName")
                    guard let imageSandBox = loadImageFromDocumentDirectory(fileName: imageName!) else { return }
                    savePhotoToCloudKit(image: imageSandBox, fileName: "\(imageName!).jpg") { result in
                        switch result {
                        case .success(let asset):
                            record["photo"] = asset
                            db.save(record) { _, error in
                                if let error = error {
                                    print("CloudKit save error: \(error)")
                                    DispatchQueue.main.async {
                                        completion(error)
                                    }
                                } else {
                                    print("Saved successfully!")
                                    DispatchQueue.main.async {
                                        completion(error)
                                    }
                                }
                            }
                        case .failure(let error):
                            print("Save asset error: \(error)")
                        }
                    }
                case .noAccount:
                    print("用户未登录 iCloud")
                case .restricted:
                    print("iCloud 使用受限")
                case .couldNotDetermine:
                    print("无法确定 iCloud 状态")
                case .temporarilyUnavailable:
                    print("暂时不可用")
                @unknown default:
                    print("未知状态")
                }
        }
    }
    /// 删除数据
    static func deleteItemFromRecod(title: String,completion:@escaping ((any Error)?) -> Void){
        let container = CKContainer(identifier: iCloudContainerID)
        // 访问私有数据库
        container.accountStatus { accountStatus, error in
            if let error = error {
                print("获取 iCloud 账号状态失败: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            switch accountStatus {
                case .available:
                    print("iCloud 可用 ✅")
                let db = container.privateCloudDatabase
                // 1. 查询条件
                let predicate = NSPredicate(format: "title == %@", title)
                let query = CKQuery(recordType: RecordType.personType.rawValue, predicate: predicate)
                db.fetch(withQuery: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: CKQueryOperation.maximumResults) { result in
                    switch result {
                    case .failure(let error):
                        DispatchQueue.main.async {
                            completion(error)
                        }
                        
                    case .success(let (matchResults, _)):
                        let recordIDs = matchResults.compactMap { (recordID, result) -> CKRecord.ID? in
                            if case .success(_) = result { return recordID }
                            return nil
                        }
                        
                        guard !recordIDs.isEmpty else {
                            DispatchQueue.main.async {
                                print("⚠️ 没有找到符合条件的记录：title == \(title)")
                                completion(nil)
                            }
                            return
                        }
                        
                        // 2. 构造批量删除操作
                        let deleteOperation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: recordIDs)
                        deleteOperation.savePolicy = .allKeys
                        deleteOperation.isAtomic = false  // 即使部分失败也继续
                        
                        deleteOperation.modifyRecordsResultBlock = { result in
                            DispatchQueue.main.async {
                                switch result {
                                case .failure(let error):
                                    print("❌ 批量删除失败: \(error)")
                                    completion(error)
                                case .success:
                                    print("✅ 批量删除成功, 删除数量 = \(recordIDs.count)")
                                    completion(nil)
                                }
                            }
                        }
                        
                        // 3. 提交操作
                        db.add(deleteOperation)
                    }
                }
                case .noAccount:
                    print("用户未登录 iCloud")
                case .restricted:
                    print("iCloud 使用受限")
                case .couldNotDetermine:
                    print("无法确定 iCloud 状态")
                case .temporarilyUnavailable:
                    print("暂时不可用")
                @unknown default:
                    print("未知状态")
                }
        }
    }
    /// 更新数据
    static func updateItemFromRecord(oldTitle: String, newTitle: String, completion:@escaping ((any Error)?) -> Void){
        let container = CKContainer(identifier: iCloudContainerID)
        let imageName = "newName\(Int.random(in: 1...60000))"
         container.accountStatus { accountStatus, error in
             if let error = error {
                 print("获取 iCloud 账号状态失败: \(error.localizedDescription)")
                 DispatchQueue.main.async {
                     completion(error)
                 }
                 return
             }
             switch accountStatus {
                 case .available:
                 print("iCloud 可用 ✅")
                 let db = container.privateCloudDatabase
                 // 1. 条件查询 (所有 title == oldTitle 的记录)
                 let predicate = NSPredicate(format: "title == %@", oldTitle)
                 let query = CKQuery(recordType: RecordType.personType.rawValue, predicate: predicate)
                 
                 db.fetch(withQuery: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: CKQueryOperation.maximumResults) { result in
                     switch result {
                     case .failure(let error):
                         print("❌ 查询失败: \(error)")
                         DispatchQueue.main.async { completion(error) }
                         
                     case .success(let (matchResults, _)):
                         let records = matchResults.compactMap { _, result -> CKRecord? in
                             if case .success(let record) = result { return record }
                             return nil
                         }
                         guard !records.isEmpty else {
                             print("⚠️ 没有符合条件的记录")
                             DispatchQueue.main.async { completion(nil) }
                             return
                         }
                         print("✅ 找到 \(records.count) 条记录，准备更新")
                         // 2. 修改所有记录的字段
                         for record in records {
                             record["title"] = newTitle as CKRecordValue
                         }
                         // 3. 批量保存
                         let modifyOperation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
                         modifyOperation.savePolicy = .changedKeys
                         modifyOperation.modifyRecordsResultBlock = { result in
                             switch result {
                             case .failure(let error):
                                 print("❌ 批量更新失败: \(error)")
                                 DispatchQueue.main.async { completion(error) }
                             case .success:
                                 print("✅ 批量更新成功")
                                 DispatchQueue.main.async { completion(nil) }
                             }
                         }
                         db.add(modifyOperation)
                     }
                 }
                 case .noAccount:
                     print("用户未登录 iCloud")
                 case .restricted:
                     print("iCloud 使用受限")
                 case .couldNotDetermine:
                     print("无法确定 iCloud 状态")
                 case .temporarilyUnavailable:
                     print("暂时不可用")
                 @unknown default:
                     print("未知状态")
                 }
        }
    }

    
    // 把 UIImage 存为 CKAsset
    static func savePhotoToCloudKit(image: UIImage, fileName: String, completion: @escaping (Result<CKAsset, Error>) -> Void) {
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent(fileName)

        do {
            if let data = image.jpegData(compressionQuality: 0.9) {
                try data.write(to: fileURL)
                let asset = CKAsset(fileURL: fileURL)
                completion(.success(asset))
            } else {
                completion(.failure(NSError(domain: "ImageError", code: 0)))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    /// 按 title 查询
    /// 按条件查询
    static func queryPersons(title: String, completion: @escaping ([CKRecord]?, Error?) -> Void) {
        let container = CKContainer(identifier: iCloudContainerID)
        // 访问私有数据库
        container.accountStatus { accountStatus, error in
            if let error = error {
                print("获取 iCloud 账号状态失败: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion([],error)
                }
                return
            }
            switch accountStatus {
                case .available:
                    print("iCloud 可用 ✅")
                    // 获取私有数据库实例
                    let db = container.privateCloudDatabase
                    let predicate = NSPredicate(format: "title == %@", title)
                    let query = CKQuery(recordType: RecordType.personType.rawValue, predicate: predicate)
                    // 查询数据
                    var allRecords: [CKRecord] = []

                    func fetchPage(cursor: CKQueryOperation.Cursor? = nil) {
                        if let cursor = cursor {
                            // 使用游标继续分页
                            db.fetch(withCursor: cursor, completionHandler: handleResult)
                        } else {
                            // 第一次查询
                            db.fetch(withQuery: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: CKQueryOperation.maximumResults, completionHandler: handleResult)
                        }
                    }
                    func handleResult(result: Result<(matchResults: [(CKRecord.ID, Result<CKRecord, Error>)], queryCursor: CKQueryOperation.Cursor?), Error>) {
                        switch result {
                        case .failure(let error):
                            DispatchQueue.main.async {
                                completion(allRecords, error)
                            }

                        case .success(let (matchResults, cursor)):
                            for (recordID, recordResult) in matchResults {
                                switch recordResult {
                                case .success(let record):
                                    allRecords.append(record)
                                case .failure(let error):
                                    print("⚠️ Record fetch error for \(recordID): \(error)")
                                }
                            }
                            
                            if let cursor = cursor {
                                // 递归继续分页
                                fetchPage(cursor: cursor)
                            } else {
                                // 没有更多了
                                DispatchQueue.main.async {
                                    completion(allRecords, nil)
                                }
                            }
                        }
                    }

                    // 开始第一次请求
                    fetchPage()
                case .noAccount:
                    print("用户未登录 iCloud")
                case .restricted:
                    print("iCloud 使用受限")
                case .couldNotDetermine:
                    print("无法确定 iCloud 状态")
                case .temporarilyUnavailable:
                    print("暂时不可用")
                @unknown default:
                    print("未知状态")
                }

        }
    }
    
    // 把 CKAsset 转成 UIImage
    static func imageFromCKAsset(_ asset: CKAsset?) -> UIImage? {
        guard let fileURL = asset?.fileURL else { return nil }
        return UIImage(contentsOfFile: fileURL.path)
    }
    /// 从沙盒加载图片
    static func loadImageFromDocumentDirectory(fileName: String) -> UIImage? {
        guard let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let fileURL = documentsDir.appendingPathComponent("\(kkAsstePhotosPath)/\(fileName)")
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    /// 保存图片到沙盒
    static func saveImageToSandbox(image: UIImage, imageName: String) -> Bool {
        // 1. 获取 Document 目录路径
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("无法获取 Document 目录")
            return false
        }
        
        // 2. 创建子目录
        let photoDirectory = documentDirectory.appendingPathComponent(kkAsstePhotosPath)
        
        do {
            try FileManager.default.createDirectory(at: photoDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("创建目录失败: \(error.localizedDescription)")
            return false
        }
        
        // 3. 构造图片保存路径
        let imageURL = photoDirectory.appendingPathComponent(imageName)
        
        // 4. 将 UIImage 转换为 Data
        guard let imageData = image.pngData() else {
            print("无法将图片转换为 Data")
            return false
        }
        
        // 5. 写入文件
        do {
            try imageData.write(to: imageURL)
            print("图片保存成功: \(imageURL.path)")
            return true
        } catch {
            print("保存图片失败: \(error.localizedDescription)")
            return false
        }
    }
    
}
