//
//  WeScanViewController.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/8/13.
//

import UIKit
//import WeScan
import Photos
import PhotosUI
import Vision

class WeScanViewController: SuperViewController {
    
    private let imageView = UIImageView()
    private let scanButton = UIButton(type: .system)
    private let picButton = UIButton(type: .system)
      private let saveButton = UIButton(type: .system)

    private lazy var startScan1 = UILabel().text("StartScan").hnFont(size: 14.h, weight: .bold).backgroundColor(.systemCyan).color(.red).centerAligned().onTap {
        [weak self] in
        guard let self = self else {return}
        startScanning()
    }

    private var lastCroppedImage: UIImage? {
            didSet {
                imageView.image = lastCroppedImage
                saveButton.isEnabled = (lastCroppedImage != nil)
            }
        }


    override func setUpUI() {
        view.addChildView([startScan1])
        startScan1.snp.makeConstraints { make in
            make.height.width.equalTo(80.h)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100.h)
        }

        imageView.contentMode = .scaleAspectFit
                imageView.backgroundColor = .secondarySystemBackground
                imageView.layer.cornerRadius = 12
                imageView.layer.masksToBounds = true

                scanButton.setTitle("开始扫描（拍照）", for: .normal)
                scanButton.addTarget(self, action: #selector(startScan), for: .touchUpInside)

                picButton.setTitle("开始选择照片", for: .normal)
                picButton.addTarget(self, action: #selector(openPhotoLibrary), for: .touchUpInside)

                saveButton.setTitle("保存到相册", for: .normal)
                saveButton.isEnabled = false
                saveButton.addTarget(self, action: #selector(saveToPhotos), for: .touchUpInside)

                imageView.translatesAutoresizingMaskIntoConstraints = false
                scanButton.translatesAutoresizingMaskIntoConstraints = false
                picButton.translatesAutoresizingMaskIntoConstraints = false
                saveButton.translatesAutoresizingMaskIntoConstraints = false

                view.addSubview(imageView)
                view.addSubview(scanButton)
                view.addSubview(picButton)
                view.addSubview(saveButton)

                NSLayoutConstraint.activate([
                    imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                    imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),

                    scanButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
                    scanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

                    picButton.topAnchor.constraint(equalTo: scanButton.bottomAnchor, constant: 20),
                    picButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

                    saveButton.topAnchor.constraint(equalTo: picButton.bottomAnchor, constant: 16),
                    saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
                ])
    }

    @objc private func startScan() {
        let scannerVC = ImageScannerController()
        scannerVC.view.backgroundColor = .systemCyan
        scannerVC.imageScannerDelegate = self
        scannerVC.modalPresentationStyle = .overFullScreen
        present(scannerVC, animated: true) {
            scannerVC.interactivePopGestureRecognizer?.isEnabled = false
        }
    }

    @objc func openPhotoLibrary() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 2
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }

    // 启动 WeScan 裁剪流程
   func startWeScan(with image: UIImage) {
       let scannerVC = ImageScannerController(image: image)
       scannerVC.view.backgroundColor = .systemCyan
       scannerVC.imageScannerDelegate = self
       scannerVC.modalPresentationStyle = .overFullScreen
       present(scannerVC, animated: true) {
           scannerVC.interactivePopGestureRecognizer?.isEnabled = false
       }
   }



    @objc private func saveToPhotos() {
           guard let image = lastCroppedImage else { return }

           PHPhotoLibrary.requestAuthorization { status in
               guard status == .authorized || status == .limited else {
                   print("无相册写入权限")
                   return
               }
               UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.saveCompleted(_:didFinishSavingWithError:contextInfo:)), nil)
           }
       }

       @objc private func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
           DispatchQueue.main.async {
               let alert = UIAlertController(title: error == nil ? "已保存" : "保存失败",
                                             message: error?.localizedDescription,
                                             preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "好的", style: .default))
               self.present(alert, animated: true)
           }
       }

    func startScanning() {
        let scannerVC = ImageScannerController()
        scannerVC.view.backgroundColor = .systemCyan
        scannerVC.imageScannerDelegate = self
        scannerVC.modalPresentationStyle = .overFullScreen
        present(scannerVC, animated: true) {
            scannerVC.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
}

extension WeScanViewController: ImageScannerControllerDelegate {
    func imageScannerController(_ scanner: ImageScannerController,
                                    didFinishScanningWithResults results: ImageScannerResults) {

            // results.originalScan.image   原图
            // results.scannedImage         自动校正后的正射图（常用）
            // results.croppedScan.image    手动拖拽四角后的裁剪结果（最常用）

            // 这里选用 croppedScan（用户手动微调后的）
            lastCroppedImage = results.croppedScan.image

            scanner.dismiss(animated: true)
        }

        func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
            scanner.dismiss(animated: true)
        }

        func imageScannerController(_ scanner: ImageScannerController,
                                    didFailWithError error: Error) {
            scanner.dismiss(animated: true) {
                let alert = UIAlertController(title: "扫描失败",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "好的", style: .default))
                self.present(alert, animated: true)
            }
        }
}

extension WeScanViewController: PHPickerViewControllerDelegate {
    // 选择完照片
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)

        guard let itemProvider = results.first?.itemProvider,
              itemProvider.canLoadObject(ofClass: UIImage.self) else { return }

        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            guard let self = self else { return }
            if let image = object as? UIImage {
                DispatchQueue.main.async {
                    self.startWeScan(with: image)
                }
            }
        }
    }
}
