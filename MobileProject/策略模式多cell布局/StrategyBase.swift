//
//  呃呃呃呃ViewController.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/8/19.
//

import UIKit

class SectionDetailModel {
    var dataList: [String]
    
    init(dataList: [String]) {
        self.dataList = dataList
    }
}


// MARK: - Section 数据模型
class MeHomeSectionModel {
    var type: String   // 标记该 section 用什么 cell 类型
    var data: SectionDetailModel?     // 存放该 section 的数据
    init(type: String, data: SectionDetailModel? = nil) {
        self.type = type
        self.data = data
    }
}

// MARK: - Cell 策略协议
protocol MeHomeCellProtocol where Self: SuperCollectionViewCell {
    static func numberOfItems(for section: MeHomeSectionModel) -> Int
    static func sizeForItem(for section: MeHomeSectionModel) -> CGSize
    static func headerSize(for section: MeHomeSectionModel) -> CGSize
    static func edgeInsets(for section: MeHomeSectionModel) -> UIEdgeInsets
    static func interitemSpacing(for section: MeHomeSectionModel) -> CGFloat
    static func lineSpacing(for section: MeHomeSectionModel) -> CGFloat
    
    func configure(with model: MeHomeSectionModel, indexPath: IndexPath, controller: UIViewController)
    func didSelectItem()
}

// MARK: - 默认实现
extension MeHomeCellProtocol {
    /// 返回当前这一组有多少个cell
    static func numberOfItems(for section: MeHomeSectionModel) -> Int { return 1 }
    /// 返回当前这组的cell大小
    static func sizeForItem(for section: MeHomeSectionModel) -> CGSize { return CGSize(width: 100, height: 100) }
    /// 返回当前这组的组头大小
    static func headerSize(for section: MeHomeSectionModel) -> CGSize { return .zero }
    /// 设置内边距
    static func edgeInsets(for section: MeHomeSectionModel) -> UIEdgeInsets { return .zero }
    /// 行与行之间的最小间距（垂直滚动时）或列与列之间的间距（水平滚动时）
    static func interitemSpacing(for section: MeHomeSectionModel) -> CGFloat { return 0 }
    /// 同一行（或同一列）内，相邻单元格之间的最小间距
    static func lineSpacing(for section: MeHomeSectionModel) -> CGFloat { return 0 }
    
    func didSelectItem() {}
}

// MARK: - Header
class MeHomeHeaderView: SuperCollectionReusableView {
    var section: Int = 0
    var model: MeHomeSectionModel?
    weak var controller: UIViewController?
    
    class func headerId(for section: MeHomeSectionModel) -> String {
        return String(describing: Self.self)
    }
}
