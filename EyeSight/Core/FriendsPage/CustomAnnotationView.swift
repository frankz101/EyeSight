//
//  CustomAnnotationView.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/19/23.
//

import Foundation
import Kingfisher
import UIKit
import MapKit

class CustomAnnotation: MKPointAnnotation {
    let imageURL: String
    let postId: String
    init(imageURL: String, postId: String) {
        self.imageURL = imageURL
        self.postId = postId
    }
}

class CustomAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let customAnnotation = newValue as? CustomAnnotation else { return }
            
            if let url = URL(string: customAnnotation.imageURL) {
                KingfisherManager.shared.retrieveImage(with: url) { result in
                    switch result {
                    case .success(let value):
                        let rectangleImage = self.makeRectangleImage(image: value.image, width: 50, borderWidth: 2, borderColor: .white)
                        self.image = rectangleImage
                    case .failure(let error):
                        print("Error: \(error)") // handle the error appropriately
                    }
                }
            }
        }
    }


    private func makeRectangleImage(image: UIImage, width: CGFloat, borderWidth: CGFloat, borderColor: UIColor) -> UIImage {

        let aspectRatio: CGFloat = 3/4
        let size = CGSize(width: width, height: width / aspectRatio)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!

        // Draw the image in a rectangle
        let imageRect = CGRect(x: borderWidth, y: borderWidth, width: size.width - 2 * borderWidth, height: size.height - 2 * borderWidth)
        image.draw(in: imageRect)

        // Draw the border
        context.setStrokeColor(borderColor.cgColor)
        context.setLineWidth(borderWidth)
        let borderRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.stroke(borderRect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

}



