//
//  CropViewController.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/27/23.
//

import Foundation
import SwiftUI
import TOCropViewController

struct CropViewControllerWrapper: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var completionHandler: ((UIImage) -> Void)?
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> TOCropViewController {
        let cropViewController = TOCropViewController(croppingStyle: .circular, image: image ?? UIImage())
        cropViewController.delegate = context.coordinator
        
        return cropViewController
    }
    
    func updateUIViewController(_ uiViewController: TOCropViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, TOCropViewControllerDelegate {
        let parent: CropViewControllerWrapper

        init(_ parent: CropViewControllerWrapper) {
            self.parent = parent
        }

        func cropViewController(_ cropViewController: TOCropViewController,
                                didCropToCircularImage image: UIImage,
                                with cropRect: CGRect,
                                angle: Int) {
            // Provide the cropped image to SwiftUI view
            parent.image = image
            parent.completionHandler?(image)
            // Dismiss the cropViewController
            cropViewController.dismiss(animated: true, completion: nil)
        }

        func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
            // Dismiss the cropViewController if user cancels
            cropViewController.dismiss(animated: true, completion: nil)
        }
    }

}
