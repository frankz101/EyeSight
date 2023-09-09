//
//  CommentViewModel.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/26/23.
//

import Foundation
import FirebaseFirestore
import Firebase

class CommentViewModel: ObservableObject {
    @Published var comments = [Comment]()
    @Published var isShowingCommentSection = false

    private var listener: ListenerRegistration?  // Hold reference to the listener

    func addComment(commentSectionID: String, senderID: String, text: String) async {
        do {
            // Fetch user information first
            let userDoc = try await Firestore.firestore().collection("users").document(senderID).getDocument()
            guard let userData = userDoc.data(),
                  let user = try? Firestore.Decoder().decode(User.self, from: userData) else {
                print("Failed to fetch user info")
                return
            }
            
            // Create the new comment with user information
            let newComment = Comment(id: UUID().uuidString,
                                     commentSectionID: commentSectionID,
                                     senderID: senderID,
                                     senderName: user.fullName,
                                     profileUrlImage: user.profileImageURL ?? "",
                                     timestamp: Timestamp(),
                                     text: text)
            
            // Encode and add the new comment to Firestore
            let encodedComment = try Firestore.Encoder().encode(newComment)
            try await Firestore.firestore().collection("commentSections").document(commentSectionID).collection("comments").document(newComment.id).setData(encodedComment)
            
            // Refresh the comments
            await fetchComments(inCommentSection: commentSectionID)
            
        } catch {
            print("Failed to add comment with error \(error.localizedDescription)")
        }
    }


    func fetchComments(inCommentSection commentSectionID: String) async {
        do {
            let snapshot = try await Firestore.firestore().collection("commentSections")
                .document(commentSectionID)
                .collection("comments")
                .order(by: "timestamp", descending: false) // Ordered by timestamp
                .getDocuments()
            
            DispatchQueue.main.async {
                self.comments = snapshot.documents.compactMap { doc in
                    try? Firestore.Decoder().decode(Comment.self, from: doc.data())
                }
                print("Fetched \(self.comments.count) comments")
            }
        } catch {
            print("Failed to fetch comments with error \(error.localizedDescription)")
        }
    }


    func startListening(commentSectionID: String) {
        let query = Firestore.firestore().collection("commentSections")
            .document(commentSectionID)
            .collection("comments")
            .order(by: "timestamp", descending: true)  // Order by timestamp
        
        listener = query.addSnapshotListener { [weak self] querySnapshot, error in
            DispatchQueue.main.async {  // Make sure to update UI on the main thread
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    self?.comments = querySnapshot?.documents.compactMap { doc in
                        try? Firestore.Decoder().decode(Comment.self, from: doc.data())
                    } ?? []
                    print("Fetched \(self?.comments.count ?? 0) comments")
                }
            }
        }
    }



    func stopListening() {
        listener?.remove() // Don't forget to detach the listener when you're done
    }
}

