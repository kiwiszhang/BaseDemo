//
//  UIView+Create.swift
//  MobileProject
//
//  Created by Yu on 2025/4/4.
//

import UIKit

extension UIImageView {
    @discardableResult
    func image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }
    
    @discardableResult
    func tintColor(_ color: UIColor) -> Self {
        tintColor = color
        return self
    }
}
