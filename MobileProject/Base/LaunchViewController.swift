//
//  TableViewCell.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/7/26.
//

import UIKit
import Network

class LaunchViewController: SuperViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        checkNetworkAuthorization()
    }
    
    override func setUpUI() {
        view.addGradientBackground(colors: [.colorWithHexString("52238B"), .colorWithHexString("040439")], direction: .bottomToTop)
        
        let launchImgV = UIImageView(image: Asset.launchBg.image).contentMode(.scaleAspectFill)
        view.addSubview(launchImgV)
        launchImgV.snp.makeConstraints { make in
            make.height.top.left.width.equalToSuperview()
        }
        
//        let launchImgV1 = UIImageView(image: Asset.launchImg.image)
//        view.addSubview(launchImgV1)
//        launchImgV1.snp.makeConstraints { make in
//            make.width.equalTo(402.w)
//            make.height.equalTo(194.h)
//            make.centerX.equalToSuperview()
//            make.centerY.equalToSuperview()
//        }
//        launchImgV1.transform = CGAffineTransform(rotationAngle: degreesToRadians(7))

        let iconImgV = UIImageView(image: Asset.appIconLogo.image).hidden(true)
        view.addSubview(iconImgV)
        iconImgV.snp.makeConstraints { make in
            make.width.height.equalTo(125.w)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.snp.top).offset(214.h)
        }
        
        let nameLab = UILabel().text("WAlytics").fontSize(24.h, weight: .regular).centerAligned().color(.white).hidden(true)
        view.addSubview(nameLab)
        nameLab.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(30.h)
            make.top.equalTo(iconImgV.snp.bottom).offset(25.h)
        }
        
//        let leftImg = UIImageView(image: Asset.buyAlertLeft.image)
//        view.addSubview(leftImg)
//        leftImg.snp.makeConstraints { make in
//            make.width.equalTo(50.w)
//            make.height.equalTo(111.h)
//            make.bottom.equalTo(view.snp.bottom).offset(-109.h)
//            make.left.equalTo(view.snp.left).offset(50.w)
//        }
//
//        let rightImg = UIImageView(image: Asset.buyAlertRight.image)
//        view.addSubview(rightImg)
//        rightImg.snp.makeConstraints { make in
//            make.width.equalTo(50.w)
//            make.height.equalTo(111.h)
//            make.bottom.equalTo(view.snp.bottom).offset(-109.h)
//            make.right.equalTo(view.snp.right).offset(-50.w)
//        }
//
//        let lab1 = UILabel().text("The choice of").fontSize(20.h, weight: .regular).color(.white).centerAligned()
//        view.addSubview(lab1)
//        lab1.snp.makeConstraints { make in
//            make.left.right.equalToSuperview()
//            make.top.equalTo(leftImg.snp.top).offset(6.h)
//            make.height.equalTo(30.h)
//        }
//
//        let lab2 = UILabel().text("10w+").fontSize(32.h, weight: .regular).color(.colorWithHexString("14E934")).centerAligned()
//        view.addSubview(lab2)
//        lab2.snp.makeConstraints { make in
//            make.left.right.equalToSuperview()
//            make.top.equalTo(lab1.snp.bottom).offset(0.h)
//            make.height.equalTo(40.h)
//        }
//        let lab3 = UILabel().text("users worldwide").fontSize(20.h, weight: .regular).color(.white).centerAligned()
//        view.addSubview(lab3)
//        lab3.snp.makeConstraints { make in
//            make.left.right.equalToSuperview()
//            make.top.equalTo(lab2.snp.bottom).offset(0.h)
//            make.height.equalTo(40.h)
//        }
    }

    func degreesToRadians(_ degrees: CGFloat) -> CGFloat {
        return degrees * .pi / 180
    }
}

private
extension LaunchViewController {
    
    func requestConfig() {
        Task {
            // 检查版本
            if let version = await EventReport.checkAppVersion() {
                if kkAppVersion.compare(version, options: .numeric) == .orderedDescending {
                    // 当前版本大于线上版本
                    AppHelper.isWaiting = true
                } else {
                    AppHelper.isWaiting = false
                }
            } else {
                AppHelper.isWaiting = true
            }
            // 请求ABTest配置(没有引导页AB测试就不用同步等待)
            AppHelper.getABTestConfig()
            
            // 模拟延迟后跳转主界面
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if let window = kkKeyWindow() {
                    if !isPremiumUser {
                        window.showInitialViewController()
                    }else{
                        window.showMainViewController()
                    }
                }
            }
//            await MainActor.run {
//                UIApplication.topWindow?.showInitialViewController()
//            }
        }
    }
    
    func checkNetworkAuthorization() {
        let queue = DispatchQueue(label: "NetworkMonitor")
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                monitor.cancel()
                DispatchQueue.main.async {
                    MyLog("网络已连接")
//                    self.loadingView.stopAnimating()
                    // 注册用户
                    EventReport.registerUser()
                    self.requestConfig()
                }
            } else {
                DispatchQueue.main.async {
                    MyLog("网络未连接或受限")
//                    self.loadingView.startAnimating()
                    MBProgressHUD.showMessage(L10n.notConnectedLimited)
                }
            }
        }
        monitor.start(queue: queue)
    }
}
