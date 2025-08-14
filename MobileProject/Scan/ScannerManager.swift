//
//  ScannerManager.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/8/13.
//

import UIKit
import PhotosUI
//import WeScan

class ScannerManager: NSObject {
    private var isCameraContinuousMode = false

    private var scannedImages: [UIImage] = []
    private var albumImages: [UIImage] = []

    // MARK: - 相机多张扫描
    func startCameraScan(from vc: UIViewController) {
        isCameraContinuousMode = true
        let scannerVC = ImageScannerController()
        scannerVC.view.backgroundColor = .systemCyan
        scannerVC.imageScannerDelegate = self
        scannerVC.modalPresentationStyle = .overFullScreen
        vc.present(scannerVC, animated: true) {
            scannerVC.interactivePopGestureRecognizer?.isEnabled = false
        }
    }

    // MARK: - 相册多选扫描
    func startAlbumScan(from vc: UIViewController) {
        isCameraContinuousMode = true
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 0
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        vc.present(picker, animated: true)
    }

    private func cropNextAlbumImage(from vc: UIViewController) {
        guard !albumImages.isEmpty else {
            print("相册多选裁剪结束")
            return
        }
        let image = albumImages.removeFirst()
        let scannerVC = ImageScannerController(image: image)
        scannerVC.view.backgroundColor = .systemCyan
        scannerVC.imageScannerDelegate = self
        scannerVC.modalPresentationStyle = .overFullScreen
        vc.present(scannerVC, animated: true) {
            scannerVC.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
}

extension ScannerManager: ImageScannerControllerDelegate {
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        print("裁剪完成: \(results.enhancedScan?.image.size)")

        // 先保存外层 VC 引用
//        guard let presentingVC = scanner.presentingViewController else {
//            scanner.dismiss(animated: true)
//            return
//        }
//        scanner.dismiss(animated: true) {
//            if !self.albumImages.isEmpty {
//                // 相册多选裁剪
//                self.cropNextAlbumImage(from: presentingVC)
//            } else if self.isCameraContinuousMode {
//                // 相机连续扫描模式
//                self.startCameraScan(from: presentingVC)
//            }
//        }
        scanner.dismiss(animated: true)
    }

    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        scanner.dismiss(animated: true)
    }

    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        print("扫描失败: \(error.localizedDescription)")
        scanner.dismiss(animated: true)
    }
}

extension ScannerManager: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        let group = DispatchGroup()
        albumImages.removeAll()

        for result in results {
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { obj, _ in
                if let img = obj as? UIImage {
                    self.albumImages.append(img)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            if let vc = picker.presentingViewController {
                self.cropNextAlbumImage(from: vc)
            }
        }
    }
}
