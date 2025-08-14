//
//  SuperCollectionViewController.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/4/30.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import UIKit

class SuperCollectionViewController: UICollectionViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    //MARK: ----------懒加载-----------
    private lazy var closeBtn: NavigationBackBtn = {
        let closeBtn = NavigationBackBtn.init(frame: CGRect.init(x: 0, y: 0, width: 44, height: 44), obj: self, methord: #selector(closeBtnMethord))
        return closeBtn
    }()
    //MARK: ----------系统方法-----------
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        getData()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        MyLog("\(NSStringFromClass(self.classForCoder))")
    }
}
//MARK: ----------UI-----------
extension SuperCollectionViewController {
    @objc func setUpUI() {
        if navigationController?.viewControllers.first == self && (tabBarController == nil || (tabBarController != nil && tabBarController!.tabBar.isHidden)) && presentingViewController != nil {
            navigationItem.setLeftBarButton(UIBarButtonItem.init(customView: closeBtn), animated: true)
        }
    }
}
//MARK: ----------网络请求-----------
extension SuperCollectionViewController {
    @objc func getData() {

    }
}
//MARK: ----------其他-----------
extension SuperCollectionViewController {
    @objc func closeBtnMethord() {
        dismiss(animated: true, completion: nil)
    }
}
