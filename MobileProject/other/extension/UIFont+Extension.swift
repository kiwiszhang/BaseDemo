//
//  UIFont+Extension.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/4/17.
//

import Foundation

enum HelveticaNeueWeight: String {
    case ultraLight = "UltraLight"
    case light = "Light"
    case regular = ""          // HelveticaNeue 无后缀
    case medium = "Medium"
    case bold = "Bold"
    case condensedBold = "CondensedBold"
}

extension UIFont {
    static func helveticaNeue(size: CGFloat, weight: HelveticaNeueWeight = .regular) -> UIFont {
        let fontName = "HelveticaNeue" + (weight.rawValue.isEmpty ? "" : "-\(weight.rawValue)")
        if let font = UIFont(name: fontName, size: size) {
            return font
        }
        MyLog("⚠️ Helvetica Neue-\(weight) 加载失败，使用系统字体替代")
        let systemWeight: UIFont.Weight
        switch weight {
        case .ultraLight: systemWeight = .ultraLight
        case .light:      systemWeight = .light
        case .regular:    systemWeight = .regular
        case .medium:     systemWeight = .medium
        case .bold:       systemWeight = .bold
        case .condensedBold: systemWeight = .bold
        }
        return UIFont.systemFont(ofSize: size, weight: systemWeight)
    }
}
