//
//  EditScanViewController.swift
//  WeScan
//
//  Created by Boris Emorine on 2/12/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import AVFoundation
import UIKit

/// The `EditScanViewController` offers an interface for the user to edit the detected quadrilateral.
final class EditScanViewController: UIViewController {

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.isOpaque = true
        imageView.image = currentImage
        imageView.backgroundColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var quadView: QuadrilateralView = {
        let quadView = QuadrilateralView()
        quadView.editable = true
        quadView.translatesAutoresizingMaskIntoConstraints = false
        return quadView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        return UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout).delegate(self).dataSource(self).showsHV(false).registerCells(ImageCollecionViewCell.self).backgroundColor(.systemBrown)
    }()

    private lazy var nextButton: UIBarButtonItem = {
        let title = NSLocalizedString("wescan.edit.button.next",
                                      tableName: nil,
                                      bundle: Bundle(for: EditScanViewController.self),
                                      value: "Next",
                                      comment: "A generic next button"
        )
        let button = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(pushReviewController))
        button.tintColor = navigationController?.navigationBar.tintColor
        return button
    }()

    private lazy var cancelButton: UIBarButtonItem = {
        let title = NSLocalizedString("wescan.scanning.cancel",
                                      tableName: nil,
                                      bundle: Bundle(for: EditScanViewController.self),
                                      value: "Cancel",
                                      comment: "A generic cancel button"
        )
        let button = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(cancelButtonTapped))
        button.tintColor = navigationController?.navigationBar.tintColor
        return button
    }()
    private var currentIndex = 0
    /// The image the quadrilateral was detected on.
    private let images:[UIImage]
    private var currentImage:UIImage

    /// The detected quadrilateral that can be edited by the user. Uses the image's coordinates.
    private var quad: Quadrilateral

    private var zoomGestureController: ZoomGestureController!

    private var quadViewWidthConstraint = NSLayoutConstraint()
    private var quadViewHeightConstraint = NSLayoutConstraint()

    // MARK: - Life Cycle

    init(images: [UIImage], quad: Quadrilateral?, rotateImage: Bool = true) {
        let img:UIImage = images[currentIndex]
        self.images = images
        self.currentImage = img.fixOrientation()
        self.quad = EditScanViewController.defaultQuad(forImage: currentImage)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
        title = NSLocalizedString("wescan.edit.title",
                                  tableName: nil,
                                  bundle: Bundle(for: EditScanViewController.self),
                                  value: "Edit Scan",
                                  comment: "The title of the EditScanViewController"
        )
        navigationItem.rightBarButtonItem = nextButton
        if let firstVC = self.navigationController?.viewControllers.first, firstVC == self {
            navigationItem.leftBarButtonItem = cancelButton
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem()
        }
        imageView.enable(true)
        quadView.enable(false)
        zoomGestureController = ZoomGestureController(image: currentImage, quadView: quadView)
        let touchDown = UILongPressGestureRecognizer(target: zoomGestureController, action: #selector(zoomGestureController.handle(pan:)))
        touchDown.minimumPressDuration = 0
        imageView.addGestureRecognizer(touchDown)
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustQuadViewConstraints()
        displayQuad()
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Work around for an iOS 11.2 bug where UIBarButtonItems don't get back to their normal state after being pressed.
        navigationController?.navigationBar.tintAdjustmentMode = .normal
        navigationController?.navigationBar.tintAdjustmentMode = .automatic
    }

    // MARK: - Setups

    private func setupViews() {
        view.addSubview(imageView)
        view.addSubview(quadView)
        view.addSubview(collectionView)
    }

    private func setupConstraints() {
//        let imageViewConstraints = [
//            imageView.topAnchor.constraint(equalTo: view.topAnchor),
//            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            view.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
//            view.leadingAnchor.constraint(equalTo: imageView.leadingAnchor)
//        ]
//
//        quadViewWidthConstraint = quadView.widthAnchor.constraint(equalToConstant: 0.0)
//        quadViewHeightConstraint = quadView.heightAnchor.constraint(equalToConstant: 0.0)
////
//        let quadViewConstraints = [
//            quadView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            quadView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            quadViewWidthConstraint,
//            quadViewHeightConstraint
//        ]
        
        imageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-120.h)
        }
        
        
        quadView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(imageView)
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom)
        }
        

//        NSLayoutConstraint.activate(quadViewConstraints)
    }

    // MARK: - Actions
    @objc func cancelButtonTapped() {
        if let imageScannerController = navigationController as? ImageScannerController {
            imageScannerController.imageScannerDelegate?.imageScannerControllerDidCancel(imageScannerController)
        }
    }
    
//    @objc func pushReviewController() {
//        let currentImage = images[currentIndex]
//        guard let quad = quadView.quad,
//            let ciImage = CIImage(image: currentImage) else {
//                if let imageScannerController = navigationController as? ImageScannerController {
//                    let error = ImageScannerControllerError.ciImageCreation
//                    imageScannerController.imageScannerDelegate?.imageScannerController(imageScannerController, didFailWithError: error)
//                }
//                return
//        }
//        let cgOrientation = CGImagePropertyOrientation(currentImage.imageOrientation)
//        let orientedImage = ciImage.oriented(forExifOrientation: Int32(cgOrientation.rawValue))
//        let scaledQuad = quad.scale(quadView.bounds.size, currentImage.size)
//        self.quad = scaledQuad
//
//        // Cropped Image
//        var cartesianScaledQuad = scaledQuad.toCartesian(withHeight: currentImage.size.height)
//        cartesianScaledQuad.reorganize()
//
//        let filteredImage = orientedImage.applyingFilter("CIPerspectiveCorrection", parameters: [
//            "inputTopLeft": CIVector(cgPoint: cartesianScaledQuad.bottomLeft),
//            "inputTopRight": CIVector(cgPoint: cartesianScaledQuad.bottomRight),
//            "inputBottomLeft": CIVector(cgPoint: cartesianScaledQuad.topLeft),
//            "inputBottomRight": CIVector(cgPoint: cartesianScaledQuad.topRight)
//        ])
//
//        let croppedImage = UIImage.from(ciImage: filteredImage)
//        // Enhanced Image
//        let enhancedImage = filteredImage.applyingAdaptiveThreshold()?.withFixedOrientation()
//        let enhancedScan = enhancedImage.flatMap { ImageScannerScan(image: $0) }
//
//        let results = ImageScannerResults(
//            detectedRectangle: scaledQuad,
//            originalScan: ImageScannerScan(image: currentImage),
//            croppedScan: ImageScannerScan(image: croppedImage),
//            enhancedScan: enhancedScan
//        )
//
//        let reviewViewController = ReviewViewController(results: results)
//        navigationController?.pushViewController(reviewViewController, animated: true)
//    }

    
    @objc func pushReviewController() {
        let currentImage = images[currentIndex]
        guard let quad = quadView.quad else {
            if let imageScannerController = navigationController as? ImageScannerController {
                let error = ImageScannerControllerError.ciImageCreation
                imageScannerController.imageScannerDelegate?.imageScannerController(imageScannerController, didFailWithError: error)
            }
            return
        }

        // 修正原图方向
        let fixedImage = currentImage.fixOrientation()
        guard let ciImage = CIImage(image: fixedImage) else { return }

        // 获取原图尺寸
        let imageSize = fixedImage.size
        
        // 计算 imageView 中图片实际显示的区域（scaleAspectFit）
        let displayFrame = AVMakeRect(aspectRatio: imageSize, insideRect: imageView.bounds)
        
        // 缩放比例
        let scaleX = imageSize.width / displayFrame.width
        let scaleY = imageSize.height / displayFrame.height
        
        // 偏移
        let offsetX = displayFrame.origin.x
        let offsetY = displayFrame.origin.y
        
        // 映射选中区域到原图
        let mappedQuad = Quadrilateral(
            topLeft: CGPoint(x: (quad.topLeft.x - offsetX) * scaleX,
                             y: (quad.topLeft.y - offsetY) * scaleY),
            topRight: CGPoint(x: (quad.topRight.x - offsetX) * scaleX,
                              y: (quad.topRight.y - offsetY) * scaleY),
            bottomRight: CGPoint(x: (quad.bottomRight.x - offsetX) * scaleX,
                                 y: (quad.bottomRight.y - offsetY) * scaleY),
            bottomLeft: CGPoint(x: (quad.bottomLeft.x - offsetX) * scaleX,
                                y: (quad.bottomLeft.y - offsetY) * scaleY)
        )
        self.quad = mappedQuad

        // 转成 Cartesian 坐标
        var cartesianQuad = mappedQuad.toCartesian(withHeight: imageSize.height)
        cartesianQuad.reorganize()

        // 裁剪
        let filteredImage = ciImage.applyingFilter("CIPerspectiveCorrection", parameters: [
            "inputTopLeft": CIVector(cgPoint: cartesianQuad.bottomLeft),
            "inputTopRight": CIVector(cgPoint: cartesianQuad.bottomRight),
            "inputBottomLeft": CIVector(cgPoint: cartesianQuad.topLeft),
            "inputBottomRight": CIVector(cgPoint: cartesianQuad.topRight)
        ])

        let croppedImage = UIImage.from(ciImage: filteredImage)
        // 增强
        let enhancedImage = filteredImage.applyingAdaptiveThreshold()?.withFixedOrientation()
        let enhancedScan = enhancedImage.flatMap { ImageScannerScan(image: $0) }

        let results = ImageScannerResults(
            detectedRectangle: mappedQuad,
            originalScan: ImageScannerScan(image: currentImage),
            croppedScan: ImageScannerScan(image: croppedImage),
            enhancedScan: enhancedScan
        )

        let reviewViewController = ReviewViewController(results: results)
        navigationController?.pushViewController(reviewViewController, animated: true)
    }


    private func displayQuad() {
        let imageSize = currentImage.size
        let imageFrame = CGRect(
            origin: quadView.frame.origin,
            size: CGSize(width: quadViewWidthConstraint.constant, height: quadViewHeightConstraint.constant)
        )

        let scaleTransform = CGAffineTransform.scaleTransform(forSize: imageSize, aspectFillInSize: imageFrame.size)
        let transforms = [scaleTransform]
        let transformedQuad = quad.applyTransforms(transforms)

        quadView.drawQuadrilateral(quad: transformedQuad, animated: false)
    }

    /// The quadView should be lined up on top of the actual image displayed by the imageView.
    /// Since there is no way to know the size of that image before run time, we adjust the constraints
    /// to make sure that the quadView is on top of the displayed image.
    private func adjustQuadViewConstraints() {
        let frame = AVMakeRect(aspectRatio: currentImage.size, insideRect: imageView.bounds)
        quadViewWidthConstraint.constant = frame.size.width
        quadViewHeightConstraint.constant = frame.size.height
    }

    /// Generates a `Quadrilateral` object that's centered and 90% of the size of the passed in image.
    private static func defaultQuad(forImage image: UIImage) -> Quadrilateral {
        let topLeft = CGPoint(x: image.size.width * 0.05, y: image.size.height * 0.05)
        let topRight = CGPoint(x: image.size.width * 0.95, y: image.size.height * 0.05)
        let bottomRight = CGPoint(x: image.size.width * 0.95, y: image.size.height * 0.95)
        let bottomLeft = CGPoint(x: image.size.width * 0.05, y: image.size.height * 0.95)

        let quad = Quadrilateral(topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft)

        return quad
    }

}

// MARK: - UICollectionViewDataSource
extension EditScanViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ImageCollecionViewCell.self, for: indexPath)
        cell.configure(with: images[indexPath.row])
        return cell
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension EditScanViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50.w, height: 100.w)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentIndex = indexPath.row
        currentImage = images[currentIndex].fixOrientation()
        imageView.image(currentImage)
        self.quad = EditScanViewController.defaultQuad(forImage: currentImage)
        
        imageView.removeTap()
        imageView.enable(true)
        quadView.enable(false)
        zoomGestureController = ZoomGestureController(image: currentImage, quadView: quadView)
        let touchDown = UILongPressGestureRecognizer(target: zoomGestureController, action: #selector(zoomGestureController.handle(pan:)))
        touchDown.minimumPressDuration = 0
        imageView.addGestureRecognizer(touchDown)
    }
}

class ImageCollecionViewCell: SuperCollectionViewCell {
    private var containerView = UIView().backgroundColor(.colorWithHexString("D6B6F5").withAlphaComponent(0.4)).cornerRadius(28.w)
    private let imgView = UIImageView()
    
    override func setUpUI() {
        contentView.addSubView(containerView)
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(7.5.w)
            make.right.equalToSuperview().offset(-7.5.w)
        }
        
        containerView.addChildView([imgView])
        imgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.w)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 40.w, height: 40.w))
        }
    }
    
    func configure(with item: UIImage) {
        imgView.image(item)
    }
}
