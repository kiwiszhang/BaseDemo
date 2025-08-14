//
//  CustomAnimation.swift
//  MobileProgect
//
//  Created by 于晓杰 on 2020/10/31.
//  Copyright © 2020 于晓杰. All rights reserved.
//

import UIKit

class CustomAnimation: NSObject {
    var customFrame: CGRect = .zero
}

extension CustomAnimation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 3
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) else {
            return
        }
        guard let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        guard let fromView = fromVC.view else {
            return
        }
        guard let toView = toVC.view else {
            return
        }
        
        let contentView = transitionContext.containerView
        if toVC.isBeingPresented {
            contentView.insertSubview(toView, aboveSubview: fromView)
            toView.height = customFrame.size.height
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            /*
            toView.height = 0
            UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
                toView.height = customFrame.size.height
            } completion: { (finish) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
             */
        } else {
            if fromVC.isBeingDismissed {
                fromView.height = 0
                fromView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                /*
                UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
                    fromView.height = 0
                } completion: { (finish) in
                    fromView.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
                 */
            }
        }
    }
}
