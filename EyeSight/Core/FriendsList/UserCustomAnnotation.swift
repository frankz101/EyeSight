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
    let userName: String

    init(avatarURL: String, userName: String) {
        self.avatarURL = avatarURL
        self.userName = userName
    }
}


class UserCustomAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let customAnnotation = newValue as? UserCustomAnnotation else { return }
            
            if let url = URL(string: customAnnotation.avatarURL), !customAnnotation.avatarURL.isEmpty {
                KingfisherManager.shared.retrieveImage(with: url) { result in
                    switch result {
                    case .success(let value):
                        let circleImage = self.makeCircularImage(image: value.image, diameter: 50, borderWidth: 2, borderColor: .white)
                        self.image = circleImage
                        self.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                    case .failure(let error):
                        print("Error: \(error)") // handle the error appropriately
                    }
                }
            } else {
                
                let placeholderImage = generatePlaceholderImage(userName: customAnnotation.userName)
                let circleImage = self.makeCircularImage(image: placeholderImage, diameter: 50, borderWidth: 2, borderColor: .white)
                self.image = circleImage
                self.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            }
        }
    }

    private func generatePlaceholderImage(userName: String) -> UIImage {
        let firstLetter = String(userName.prefix(1)).uppercased()
        let label = UILabel()
        label.text = firstLetter
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .gray
        label.layer.cornerRadius = 50 / 2
        label.layer.masksToBounds = true
        label.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        UIGraphicsBeginImageContext(label.bounds.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            label.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return nameImage ?? UIImage()
        }
        return UIImage()
    }
    
    private func makeCircularImage(image: UIImage, diameter: CGFloat, borderWidth: CGFloat, borderColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0)
        let context = UIGraphicsGetCurrentContext()!

        // Draw the image in a circle
        let imageRect = CGRect(x: borderWidth, y: borderWidth, width: diameter - 2 * borderWidth, height: diameter - 2 * borderWidth)
        let clipPath = UIBezierPath(ovalIn: imageRect).cgPath
        context.addPath(clipPath)
        context.clip()
        image.draw(in: imageRect)

        // Draw the border
        context.setStrokeColor(borderColor.cgColor)
        context.setLineWidth(borderWidth)
        context.addPath(clipPath)
        context.strokePath()

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
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
