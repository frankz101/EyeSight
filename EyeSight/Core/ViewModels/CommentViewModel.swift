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
            let newComment = Comment(id: UUID().uuidString, commentSectionID: commentSectionID, senderID: senderID, timestamp: Timestamp(), text: text)
            let encodedComment = try Firestore.Encoder().encode(newComment)
            try await Firestore.firestore().collection("commentSections").document(commentSectionID).collection("comments").document(newComment.id).setData(encodedComment)
            await fetchComments(inCommentSection: commentSectionID)
        } catch {
            print("Failed to add comment with error \(error.localizedDescription)")
        }
    }

    func fetchComments(inCommentSection commentSectionID: String) async {
        do {
            let snapshot = try await Firestore.firestore().collection("commentSections").document(commentSectionID).collection("comments").getDocuments()
            self.comments = snapshot.documents.compactMap { doc in
                try? Firestore.Decoder().decode(Comment.self, from: doc.data())
            }
            print("Fetched \(self.comments.count) comments")
        } catch {
            print("Failed to fetch comments with error \(error.localizedDescription)")
        }
    }

    func startListening(commentSectionID: String) {
        let query = Firestore.firestore().collection("commentSections").document(commentSectionID).collection("comments")
        listener = query.addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.comments = querySnapshot?.documents.compactMap { doc in
                    try? Firestore.Decoder().decode(Comment.self, from: doc.data())
                } ?? []
                print("Fetched \(self.comments.count) comments")
            }
        }
    }

    func stopListening() {
        listener?.remove() // Don't forget to detach the listener when you're done
    }
}

