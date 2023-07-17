//
//  CameraViewRepresentable.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/17/23.
//

import Foundation
import SwiftUI

struct CameraViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = ViewController

    var onImageCaptured: ((UIImage) -> Void)?

    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraViewController>) -> ViewController {
        let viewController = ViewController()
        viewController.onImageCaptured = onImageCaptured
        return viewController
    }

    func updateUIViewController(_ uiViewController: ViewController, context: UIViewControllerRepresentableContext<CameraViewController>) {
        // Update the view controller
    }
    
}
