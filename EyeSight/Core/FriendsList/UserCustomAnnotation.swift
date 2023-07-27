//
//  UserCustomAnnotation.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/26/23.
//

import Foundation
import Kingfisher
import UIKit
import MapKit

class UserCustomAnnotation: MKPointAnnotation {
    let avatarURL: String
    init(avatarURL: String) {
        self.avatarURL = avatarURL
    }
}

class UserCustomAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            // You don't need the customAnnotation here, so you can remove it.
            // You can simply use the "image" property of the annotation view to set the image.

            // Set the custom image to the annotation view
            let circleImage = createCircleImage(color: .gray, diameter: 50)
            self.image = circleImage

            // Set the image view content mode to center
            self.contentMode = .center
        }
    }

    // Function to create a circular image with the given color and diameter
    private func createCircleImage(color: UIColor, diameter: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        context.setFillColor(color.cgColor)
        context.fillEllipse(in: CGRect(x: 0, y: 0, width: diameter, height: diameter))

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}



//class UserCustomAnnotationView: MKAnnotationView {
//    override var annotation: MKAnnotation? {
//        willSet {
//            guard let customAnnotation = newValue as? UserCustomAnnotation else { return }
//
//            if let url = URL(string: customAnnotation.avatarURL) {
//                let processor = DownsamplingImageProcessor(size: CGSize(width: 50, height: 50))
//                KingfisherManager.shared.retrieveImage(with: url, options: [.processor(processor)]) { result in
//                    switch result {
//                    case .success(let value):
//                        self.image = value.image
//                    case .failure(let error):
//                        print("Error: \(error)") // handle the error appropriately
//                    }
//                }
//            }
//        }
//    }
//}




//class UserCustomAnnotationView: MKAnnotationView {
//    override var annotation: MKAnnotation? {
//        willSet {
//            guard let customAnnotation = newValue as? UserCustomAnnotation else { return }
//
//            // Set the placeholder image initially
//            self.image = UIImage(systemName: "person")
//
//            if let url = URL(string: customAnnotation.avatarURL) {
//                let processor = DownsamplingImageProcessor(size: CGSize(width: 50, height: 50))
//                KingfisherManager.shared.retrieveImage(with: url, options: [.processor(processor)]) { result in
//                    switch result {
//                    case .success(let value):
//                        self.image = value.image
//                    case .failure(let error):
//                        print("Error: \(error)") // handle the error appropriately
//                    }
//                }
//            }
//        }
//    }
//}
