//
//  CustomTabBar.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/8/12.
//

import UIKit
class CustomTabBar: UITabBar {
    let centerButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemCyan
        // 配置中间按钮
        centerButton.setImage(UIImage(named: "center_normal"), for: .normal)
        centerButton.setImage(UIImage(named: "center_selected"), for: .highlighted)
        centerButton.backgroundColor = .white
        centerButton.layer.cornerRadius = 32
        centerButton.layer.shadowColor = UIColor.systemRed.cgColor
        centerButton.layer.shadowOpacity = 0.2
        centerButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        addSubview(centerButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonSize: CGFloat = 64
        let tabBarWidth = bounds.width
        
        // 设置中间按钮位置（凸起）
        centerButton.frame = CGRect(
            x: (tabBarWidth - buttonSize) / 2,
            y: -20,
            width: buttonSize,
            height: buttonSize
        )
        
        // 调整其他 TabBarItem 位置，给中间按钮留位置
        var index = 0
        let tabBarButtonWidth = tabBarWidth / 5
        for subview in subviews {
            if let control = subview as? UIControl, control != centerButton {
                var frame = control.frame
                frame.origin.x = tabBarButtonWidth * CGFloat(index)
                frame.size.width = tabBarButtonWidth
                control.frame = frame
                index += 1
                if index == 2 { index += 1 } // 跳过中间位置
            }
        }
    }
}
