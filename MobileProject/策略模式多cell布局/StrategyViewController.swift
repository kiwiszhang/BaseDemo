//
//  StrategyViewController.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/8/19.
//

import UIKit

class StrategyViewController: SuperViewController {
    
    private var sectionArr: [MeHomeSectionModel] = []
    
    private let cellMap: [String: (SuperCollectionViewCell & MeHomeCellProtocol).Type] = [
        "cellA": StrategyCellA.self,
        "cellB": StrategyCellB.self
    ]

    // MARK: - =====================lazy load=======================
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        return UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout).delegate(self).dataSource(self).showsHV(false).backgroundColor(.systemBrown)
    }()
    
    // MARK: - =====================life cycle=======================
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpUI()
        getData()
    }
    
    // MARK: - ===================Intial Methods=======================
    override func setUpUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    override func getData() {
        // 注册 cell
        for cellType in cellMap.values {
            collectionView.registerCells(cellType)
        }
        
        let cellAList = ["AAA","BBB","CCC","DDD","EEE","FFF"]
        let cellBList = ["222","333","444","555"]
        
        // 模拟数据
        sectionArr = [
            MeHomeSectionModel(type: "cellA",data: SectionDetailModel(dataList: cellAList)),
            MeHomeSectionModel(type: "cellB",data: SectionDetailModel(dataList: cellBList)),
        ]
    }
    // MARK: - =====================actions==========================

    
    // MARK: - =====================delegate==========================
    
    
    // MARK: - =====================Deinit==========================

}

// MARK: - CollectionView Delegate + DataSource
extension StrategyViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let model = sectionArr[section]
        return cellMap[model.type]?.numberOfItems(for: model) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = sectionArr[indexPath.section]
        guard let cellType = cellMap[model.type] else {
            fatalError("未找到对应 cell 类型")
        }
        let cell = collectionView.dequeueCell(cellType, for: indexPath) as! (UICollectionViewCell & MeHomeCellProtocol)
        cell.configure(with: model, indexPath: indexPath, controller: self)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.view.isUserInteractionEnabled = true
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? (SuperCollectionViewCell & MeHomeCellProtocol) {
            cell.didSelectItem()
        }
    }
    
    // MARK: - FlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = sectionArr[indexPath.section]
        return cellMap[model.type]?.sizeForItem(for: model) ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let model = sectionArr[section]
        return cellMap[model.type]?.edgeInsets(for: model) ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let model = sectionArr[section]
        return cellMap[model.type]?.lineSpacing(for: model) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let model = sectionArr[section]
        return cellMap[model.type]?.interitemSpacing(for: model) ?? 0
    }
}
