//
//  CustomTransDelegate.swift
//  MobileProgect
//
//  Created by 于晓杰 on 2020/10/31.
//  Copyright © 2020 于晓杰. All rights reserved.
//

import UIKit

class CustomTransDelegate: NSObject {
    private var customFrame: CGRect = .zero
    private var coverBtnFrame: CGRect = .zero
    private var closeBlock: CustomPresentingVCDisMissBlock?
    
    class func shareCustomTransVC(_ customFrame: CGRect = .zero, coverBtnFrame: CGRect = .zero, closeBlock: CustomPresentingVCDisMissBlock? = nil) -> CustomTransDelegate {
        let instance = CustomTransDelegate.init()
        instance.customFrame = customFrame.equalTo(.zero) ? CGRect.init(x: 0, y: 0, width: kkScreenWidth, height: kkScreenHeight) : customFrame
        instance.coverBtnFrame = coverBtnFrame.equalTo(.zero) ? CGRect.init(x: 0, y: 0, width: kkScreenWidth, height: kkScreenHeight) : coverBtnFrame
        instance.closeBlock = closeBlock
        return instance
    }
}
extension CustomTransDelegate: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animation = CustomAnimation()
        animation.customFrame = customFrame
        return animation
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animation = CustomAnimation()
        animation.customFrame = customFrame
        return animation
    }
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentVC = CustomPresentingViewController.init(presentedViewController: presented, presenting: presenting)
        presentVC.coverBtnFrame = coverBtnFrame
        presentVC.customFrame = customFrame
        presentVC.closeBlock = closeBlock
        return presentVC
    }
    /*
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    }
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    }
     */
}
