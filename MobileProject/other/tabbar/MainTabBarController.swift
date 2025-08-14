//
//  CustomTabBarController.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/8/13.
//

import VisionKit
import UIKit
import Vision


class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 替换系统 TabBar
        let customTabBar = CustomTabBar()
        setValue(customTabBar, forKey: "tabBar")
        
        // 添加子控制器
        viewControllers = [
            createNav(LaunchViewController(), title: "首页", image: "setting-delete", selectedImage: "setting-rate"),
            createNav(WeScanViewController(), title: "发现", image: "setting-language", selectedImage: "setting-privacy"),
            createNav(WeScanViewController111(), title: "消息", image: "setting-privacy", selectedImage: "setting-language"),
            createNav(LaunchViewController(), title: "我的", image: "setting-rate", selectedImage: "setting-delete")
        ]
        
        // 中间按钮点击
        if let customTabBar = tabBar as? CustomTabBar {
            customTabBar.centerButton.addTarget(self, action: #selector(centerButtonTapped), for: .touchUpInside)
        }
    }
    
    private func createNav(_ rootVC: UIViewController, title: String, image: String, selectedImage: String) -> UINavigationController {
        let nav = NavigationController(rootViewController: rootVC)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = UIImage(named: image)?.withRenderingMode(.alwaysOriginal)
        nav.tabBarItem.selectedImage = UIImage(named: selectedImage)?.withRenderingMode(.alwaysOriginal)
        return nav
    }
    
    @objc private func centerButtonTapped() {
        print("中间按钮点击了")
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        present(documentCameraViewController, animated: true)
    }
}

extension MainTabBarController: VNDocumentCameraViewControllerDelegate {
    // 扫描完成
    func documentCameraViewController(_ controller: VNDocumentCameraViewController,
                                    didFinishWith scan: VNDocumentCameraScan) {
        controller.dismiss(animated: true)
        
        // 处理扫描结果
    }
    
    // 用户取消扫描
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
    
    // 扫描失败
    func documentCameraViewController(_ controller: VNDocumentCameraViewController,
                                    didFailWithError error: Error) {
        controller.dismiss(animated: true)
//        showAlert(title: "扫描失败", message: error.localizedDescription)
    }
}

