//
//  UIView+Create.swift
//  MobileProject
//
//  Created by Yu on 2025/4/4.
//

import UIKit

// MARK: - 闭包封装工具类（解决循环引用）
final class ViewClosureWrapper: NSObject {
    private let closure: () -> Void
    
    init(_ closure: @escaping () -> Void) {
        self.closure = closure
        super.init()
    }
    
    @objc func invoke() {
        closure()
    }
}

// MARK: - UIView 点击事件扩展
extension UIView {
    private struct AssociatedKeys {
        static var tapWrapper = "tapWrapper_\(UUID().uuidString)"
        static var tapGesture = "tapGesture_\(UUID().uuidString)"
    }
    
    // MARK: 私有属性
    private var tapWrapper: ViewClosureWrapper? {
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.tapWrapper) as? ViewClosureWrapper
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.tapWrapper,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    private var tapGesture: UITapGestureRecognizer? {
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.tapGesture) as? UITapGestureRecognizer
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.tapGesture,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    // MARK: 公开方法
    
    /// 添加点击事件
    @discardableResult
    func onTap(_ closure: @escaping () -> Void) -> Self {
        enable(true)
        removeTap() // 先移除旧的点击事件
        
        let wrapper = ViewClosureWrapper(closure)
        self.tapWrapper = wrapper
        
        let gesture = UITapGestureRecognizer(target: wrapper, action: #selector(ViewClosureWrapper.invoke))
        addGestureRecognizer(gesture)
        self.tapGesture = gesture
        
        return self
    }
    
    /// 移除点击事件
    @discardableResult
    func removeTap() -> Self {
        if let gesture = tapGesture {
            removeGestureRecognizer(gesture)
            tapGesture = nil
        }
        tapWrapper = nil
        return self
    }
    
    // MARK: 常用链式方法
    @discardableResult
    func backgroundColor(_ color: UIColor) -> Self {
        backgroundColor = color
        return self
    }
    
    @discardableResult
    func addChildView(_ viewArray: [UIView]) -> Self {
        for view in viewArray {
            if !subviews.contains(view) {
                addSubview(view)
            }
        }
        return self
    }
    @discardableResult
    func addSubView(_ view: UIView) -> Self {
        addSubview(view)
        return self
    }
    
    @discardableResult
    func cornerRadius(_ radius: CGFloat) -> Self {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        return self
    }
    
    @discardableResult
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner = .allCorners) -> Self {
        var masked: CACornerMask = []
        if corners.contains(.topLeft) {
            masked.insert(.layerMinXMinYCorner)
        }
        if corners.contains(.topRight) {
            masked.insert(.layerMaxXMinYCorner)
        }
        if corners.contains(.bottomLeft) {
            masked.insert(.layerMinXMaxYCorner)
        }
        if corners.contains(.bottomRight) {
            masked.insert(.layerMaxXMaxYCorner)
        }

        layer.maskedCorners = masked
        layer.cornerRadius = radius
        layer.masksToBounds = true
        return self
    }
    
    @discardableResult
    func border(width: CGFloat, color: UIColor) -> Self {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        return self
    }
    
    @discardableResult
    func alpha(_ alpha: CGFloat) -> Self {
        self.alpha = alpha
        return self
    }
    
    @discardableResult
    func hidden(_ hidden: Bool) -> Self {
        isHidden = hidden
        return self
    }
    
    @discardableResult
    func clipsToBounds(_ clips: Bool) -> Self {
        clipsToBounds = clips
        return self
    }
    
    @discardableResult
    func contentMode(_ mode: UIView.ContentMode) -> Self {
        contentMode = mode
        return self
    }
    
    @discardableResult
    func enable(_ enable: Bool) -> Self {
        isUserInteractionEnabled = enable
        return self
    }
    
    @discardableResult
    func tag(_ tag: Int) -> Self {
        self.tag = tag
        return self
    }
}
