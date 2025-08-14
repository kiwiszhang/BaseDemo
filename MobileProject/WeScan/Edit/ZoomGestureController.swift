//
//  ZoomGestureController.swift
//  WeScan
//
//  Created by Bobo on 5/31/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import AVFoundation
import Foundation
import UIKit

final class ZoomGestureController {

    private let image: UIImage
    private let quadView: QuadrilateralView
    private var previousPanPosition: CGPoint?
    private var closestCorner: CornerPosition?

    init(image: UIImage, quadView: QuadrilateralView) {
        self.image = image
        self.quadView = quadView
    }

    @objc func handle(pan: UIGestureRecognizer) {
        
        guard let drawnQuad = quadView.quad else {
            return
        }

        guard pan.state != .ended else {
            self.previousPanPosition = nil
            self.closestCorner = nil
            quadView.resetHighlightedCornerViews()
            return
        }

        let position = pan.location(in: quadView)
        let previousPanPosition = self.previousPanPosition ?? position
        let closestCorner = self.closestCorner ?? position.closestCornerFrom(quad: drawnQuad)

        let offset = CGAffineTransform(translationX: position.x - previousPanPosition.x,
                                       y: position.y - previousPanPosition.y)
        let cornerView = quadView.cornerViewForCornerPosition(position: closestCorner)
        let proposedCenter = cornerView.center.applying(offset)

        // 关键：基于 AspectFit 后的内容区域进行限制与取样
        let imageFrame = imageFrameInView(imageSize: image.size, viewSize: quadView.bounds.size)

        // 选一：硬限制角点不可越界（推荐，体验最好）
        let clampedCenter = CGPoint(x: min(max(proposedCenter.x, imageFrame.minX), imageFrame.maxX),
                                    y: min(max(proposedCenter.y, imageFrame.minY), imageFrame.maxY))

        quadView.moveCorner(cornerView: cornerView, atPoint: clampedCenter)

        self.previousPanPosition = position
        self.closestCorner = closestCorner

        // —— 放大镜取样：只在图片内容区域内才显示 ——
        guard imageFrame.contains(proposedCenter) else {
//            quadView.hideCornerMagnifier()  // 没有就加一个隐藏方法；或传 nil/不更新
            return
        }

        // 将视图坐标映射到“原图像素坐标”
        let pointInImage = CGPoint(
            x: (clampedCenter.x - imageFrame.origin.x) * (image.size.width  / imageFrame.width),
            y: (clampedCenter.y - imageFrame.origin.y) * (image.size.height / imageFrame.height)
        )

        guard let zoomedImage = image.safeZoomedImage(
            atPixelPoint: pointInImage,
            zoom: 2.5,
            targetSize: quadView.bounds.size
        ) else {
//            quadView.hideCornerMagnifier()
            return
        }

        quadView.highlightCornerAtPosition(position: closestCorner, with: zoomedImage)
    }

    private func imageFrameInView(imageSize: CGSize, viewSize: CGSize) -> CGRect {
        let imageRatio = imageSize.width / imageSize.height
        let viewRatio  = viewSize.width / viewSize.height

        let scale: CGFloat = (imageRatio > viewRatio)
            ? (viewSize.width / imageSize.width)      // 宽度贴满，上下留白
            : (viewSize.height / imageSize.height)    // 高度贴满，左右留白

        let drawSize = CGSize(width: imageSize.width * scale,
                              height: imageSize.height * scale)
        let origin = CGPoint(x: (viewSize.width  - drawSize.width)  / 2.0,
                             y: (viewSize.height - drawSize.height) / 2.0)
        return CGRect(origin: origin, size: drawSize)
    }
}

extension UIImage {

    /// 仅在原图范围内取样。超出则返回 nil（由调用方决定隐藏放大镜）。
    func safeZoomedImage(atPixelPoint p: CGPoint, zoom: CGFloat, targetSize: CGSize) -> UIImage? {
        let imgRect = CGRect(origin: .zero, size: self.size)
        guard imgRect.contains(p), zoom > 0, targetSize.width > 0, targetSize.height > 0 else {
            return nil
        }

        // 以放大镜的目标尺寸反推需要在原图裁多大区域（像素坐标）
        let cropW = targetSize.width  / zoom
        let cropH = targetSize.height / zoom
        var crop = CGRect(x: p.x - cropW / 2, y: p.y - cropH / 2, width: cropW, height: cropH)

        // 与原图相交，防止越界
        crop = crop.intersection(imgRect)
        guard !crop.isNull, crop.width > 1, crop.height > 1 else { return nil }

        // 裁出这块区域
        guard let cg = self.cgImage?.cropping(to: CGRect(x: crop.origin.x * self.scale,
                                                         y: crop.origin.y * self.scale,
                                                         width:  crop.size.width * self.scale,
                                                         height: crop.size.height * self.scale))
        else { return nil }

        let cropped = UIImage(cgImage: cg, scale: self.scale, orientation: .up)

        // 画到放大镜目标尺寸：用 AspectFit，避免被强行等比外的拉伸
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0)
        let fitRect = AVMakeRect(aspectRatio: cropped.size, insideRect: CGRect(origin: .zero, size: targetSize))
        cropped.draw(in: fitRect)
        let out = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return out
    }
}
