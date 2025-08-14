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

class WeScanViewController111: SuperViewController {
    
    let scannerManager = ScannerManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let cameraButton = makeButton(title: NSLocalizedString("Camera Scan", comment: ""), action: #selector(startCameraScan))
        let albumButton = makeButton(title: NSLocalizedString("Album Scan", comment: ""), action: #selector(startAlbumScan))

        let stack = UIStackView(arrangedSubviews: [cameraButton, albumButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func makeButton(title: String, action: Selector) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.addTarget(self, action: action, for: .touchUpInside)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return btn
    }

    @objc func startCameraScan() {
        scannerManager.startCameraScan(from: self)
    }

    @objc func startAlbumScan() {
        scannerManager.startAlbumScan(from: self)
    }
}


