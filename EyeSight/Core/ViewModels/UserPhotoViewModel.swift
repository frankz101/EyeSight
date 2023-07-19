//
//  UserPhotoViewModel.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/17/23.
//

import Foundation
import UIKit
import FirebaseStorage
import Firebase

class UserPhotoViewModel: ObservableObject {
    @Published var imageURL: String?
    var feedViewModel: FeedViewModel?

    func uploadPhoto(_ image: UIImage, completion: @escaping (Bool) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(false)
            return
        }

        let storageRef = Storage.storage().reference().child("user-photos").child(UUID().uuidString)

        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Failed to upload photo: \(error.localizedDescription)")
                completion(false)
                return
            }

            storageRef.downloadURL { (url, error) in
                if let error = error {
                    print("Failed to get download URL: \(error.localizedDescription)")
                    completion(false)
                    return
                }

                if let downloadURL = url?.absoluteString {
                    self.imageURL = downloadURL

                    // Update hasPostedToday for the current user
                    let db = Firestore.firestore()
                    let userRef = db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
                    userRef.updateData(["hasPostedToday": true]) { (error) in
                        if let error = error {
                            print("Failed to update hasPostedToday: \(error.localizedDescription)")
                            completion(false)
                        } else {
                            self.feedViewModel?.refreshFeed.toggle()
                            completion(true)
                        }
                    }
                } else {
                    completion(false)
                }
            }
        }
    }
}

