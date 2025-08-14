//
//  UIDevice+Extension.swift
//  MobileProgect
//
//  Created by 于晓杰 on 2020/11/4.
//  Copyright © 2020 于晓杰. All rights reserved.
//

import UIKit

extension UIDevice {
    //竖屏
    static var isPortrait: Bool {
        UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isPortrait ?? true
    }
    
    class func setCurrentOrientation(orientation: UIInterfaceOrientation) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.allowLandscapeRight = orientation == .landscapeLeft || orientation == .landscapeRight
        UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
}

