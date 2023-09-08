//
//  ProfileViewModel.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/27/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var recentPostId: String?
    @Published var hasPostedToday: Bool = false

    func fetchRecentPost() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No user is logged in.")
            return
        }

        let startOfToday = Calendar.current.startOfDay(for: Date())
        let endTime = Date()
        let postsRef = db.collection("posts")
                         .whereField("userID", isEqualTo: userID)
                         .whereField("timestamp", isGreaterThanOrEqualTo: startOfToday)
                         .whereField("timestamp", isLessThanOrEqualTo: endTime)
                         .order(by: "timestamp", descending: true)
                         .limit(to: 1)
        
        postsRef.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching post: \(error)")
                return
            }

            guard let documents = snapshot?.documents, !documents.isEmpty else {
                print("No recent posts found.")
                return
            }

            // Save the documentID (which is the postId) to the recentPostId property
            self.recentPostId = documents[0].documentID
        }
    }


    
    let db = Firestore.firestore()
    
    func fetchUser() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No user is logged in.")
            return
        }

        let docRef = db.collection("users").document(userID)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let user = try? document.data(as: User.self)
                self.user = user
                self.hasPostedToday = user?.hasPostedToday ?? false
            } else if let error = error {
                print("Error fetching user: \(error)")
            }
        }
    }


    
    func uploadProfileImage(selectedImage: UIImage) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No user is logged in.")
            return
        }
        
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.75) else {
            print("Could not convert image to data.")
            return
        }
        
        let storage = Storage.storage().reference().child("profileImages/\(userId).jpg")
        
        storage.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("Error uploading image: \(error)")
                return
            }
            
            storage.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error)")
                    return
                }
                
                if let url = url {
                    let docRef = Firestore.firestore().collection("users").document(userId)
                    docRef.updateData([
                        "profileImageURL": url.absoluteString
                    ]) { error in
                        if let error = error {
                            print("Error updating document: \(error)")
                        } else {
                            print("Document successfully updated")
                            self.fetchUser() // Fetch user data again after updating the profile image URL
                        }
                    }
                }
            }
        }
    }
    
    func deleteProfileImage() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No user is logged in.")
            return
        }

        // Deleting image from Firebase Storage
        let storageRef = Storage.storage().reference().child("profileImages/\(userID).jpg")
        storageRef.delete { error in
            if let error = error {
                print("Error occurred while deleting profile image from storage: \(error.localizedDescription)")
            } else {
                print("Profile image deleted successfully from storage.")
            }
        }

        // Updating user's document in Firestore
        let docRef = db.collection("users").document(userID)
        docRef.updateData([
            "profileImageURL": FieldValue.delete()
        ]) { error in
            if let error = error {
                print("Error occurred while deleting profileImageURL field: \(error.localizedDescription)")
            } else {
                print("profileImageURL field deleted successfully.")
                // Fetch user again to reflect changes
                self.fetchUser()
            }
        }
    }

}
