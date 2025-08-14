//
//  CustomPresentingViewController.swift
//  MobileProgect
//
//  Created by 于晓杰 on 2020/10/31.
//  Copyright © 2020 于晓杰. All rights reserved.
//

import UIKit

typealias CustomPresentingVCDisMissBlock = () -> ()

class CustomPresentingViewController: UIPresentationController {
    var customFrame: CGRect = .zero
    var coverBtnFrame: CGRect = .zero
    var closeBlock: CustomPresentingVCDisMissBlock?
    
    private lazy var coverBtn: UIButton = {
        let coverBtn = UIButton.init(frame: coverBtnFrame)
        coverBtn.backgroundColor = .clear
        coverBtn.addTarget(self, action: #selector(coverBtnMethord), for: .touchUpInside)
        return coverBtn
    }()
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        presentedView?.frame = customFrame
        containerView?.insertSubview(coverBtn, at: 0)
    }
    @objc private func coverBtnMethord() {
        presentingViewController.dismiss(animated: true) {
            if self.closeBlock != nil {
                self.closeBlock!()
            }
        }
    }
}
