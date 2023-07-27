//
//  CommentSectionView.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/26/23.
//

import SwiftUI
import FirebaseAuth

struct CommentSectionView: View {
    @ObservedObject var viewModel: CommentViewModel
    var commentSectionID: String
    @State private var commentText = ""

    var body: some View {
        VStack {
            TextField("Enter your comment here", text: $commentText)
                .padding()
            Button(action: {
                Task {
                    await sendComment()
                }
            }) {
                Text("Send Comment")
            }
            List {
                ForEach(viewModel.comments, id: \.id) { comment in
                    Text(comment.text)
                }
            }
        }
        .task {
            await fetchComments()
        }
    }

    func fetchComments() async {
        do {
            try await viewModel.fetchComments(inCommentSection: commentSectionID)
        } catch {
            print("Failed to fetch comments with error \(error.localizedDescription)")
        }
    }

    func sendComment() async {
        do {
            guard let currentUserID = Auth.auth().currentUser?.uid else {
                print("User is not authenticated")
                return
            }
            try await viewModel.addComment(commentSectionID: commentSectionID, senderID: currentUserID, text: commentText)
        } catch {
            print("Failed to send comment with error \(error.localizedDescription)")
        }
    }
}



//struct CommentSectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentSectionView()
//    }
//}
