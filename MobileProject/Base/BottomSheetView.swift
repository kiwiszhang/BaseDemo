//
//  BottomSheetView.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/7/17.
//

import UIKit

class BottomSheetView: UIView,UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    private var contentView: UIView!
    private var isPresented = false
    
    // MARK: - Initialization
    init(contentView: UIView) {
        super.init(frame: CGRect.zero)
        self.contentView = contentView
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        // Set up the base background
        self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.frame = UIScreen.main.bounds
        
        // Set up the content view
        contentView.frame = CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: contentView.frame.height)
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
        self.addSubview(contentView)
        
        // Add tap gesture recognizer to dismiss the view when tapped outside (background area)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
        
        // Prevent tap gesture from triggering dismiss on the content view
//        let contentTapGesture = UITapGestureRecognizer(target: self, action: #selector(contentTapped))
//        contentView.addGestureRecognizer(contentTapGesture)
        
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismiss))
        swipeDownGesture.direction = .down
        self.addGestureRecognizer(swipeDownGesture)
    }
    
    // MARK: - Actions
    @objc func dismiss() {
        // Animation for hiding the view
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.frame.origin.y = self.bounds.height
        }) { _ in
            self.isPresented = false
            self.contentView.removeFromSuperview()
            self.removeFromSuperview()
        }
    }
    
    @objc private func contentTapped() {
        // Do nothing here, just prevent dismissal when tapping the content view
    }
    
    // MARK: - Animations
    func present() {
        guard !isPresented else { return }
        
        // Animation for showing the view
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.frame.origin.y = self.bounds.height - self.contentView.frame.height
        }) { _ in
            self.isPresented = true
        }
    }
    
    func show(in viewController: UIViewController) {
        viewController.view.addSubview(self)
        self.present()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if contentView.frame.contains(touch.location(in: self)) {
            return false
        }
        return true
    }
}
