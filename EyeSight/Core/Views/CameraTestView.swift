//
//  CameraTestView.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/17/23.
//

import SwiftUI

struct CameraTestView: View {
    @State private var showModal = false
    var returnToMapView: () -> Void

    var body: some View {
        VStack {
            Button(action: {
                showModal.toggle()
            }) {
                Text("Open Camera")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .fullScreenCover(isPresented: $showModal) {
            CameraViewControllerRepresentable { image in
                print(image)
                // Call returnToMapView when the image is captured
                self.returnToMapView()
                // Set showModal to false to close the modal
                self.showModal = false
            }
            .ignoresSafeArea()
        }
    }
}

struct CameraViewControllerRepresentable: UIViewControllerRepresentable {
    var onImageCaptured: ((UIImage) -> Void)?

    func makeUIViewController(context: Context) -> ViewController {
        let viewController = ViewController()
        viewController.onImageCaptured = onImageCaptured
        return viewController
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
}
