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
                let processor = DownsamplingImageProcessor(size: CGSize(width: 50, height: 50))
                KingfisherManager.shared.retrieveImage(with: url, options: [.processor(processor)]) { result in
                    switch result {
                    case .success(let value):
                        self.image = value.image
                    case .failure(let error):
                        print("Error: \(error)") // handle the error appropriately
                    }
                }
            }
        }
    }
}


