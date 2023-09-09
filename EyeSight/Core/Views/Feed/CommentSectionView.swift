//
//  CommentSectionView.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/26/23.
//

import SwiftUI
import FirebaseAuth
import Kingfisher

struct CommentSectionView: View {
    @ObservedObject var viewModel: CommentViewModel
    var commentSectionID: String
    @State private var commentText = ""

    var body: some View {
        VStack (spacing: 0) {
            Text("comments")
                .padding(.vertical, 24)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
            Divider()
            List {
                ForEach(viewModel.comments, id: \.id) { comment in
                    HStack {
                        if let url = URL(string: comment.profileUrlImage) {
                            KFImage(url)
                                .resizable()
                                .frame(width: 36, height: 36)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width:30, height: 30)
                        }
                        VStack (alignment: .leading){
                            Text(comment.senderName)
                                .font(.caption)
                                .fontWeight(.bold)

                            Text(comment.text)
                                .font(.system(size: 16))  //ADD REPLY

                        }
                        Spacer()
                    }
                    .padding(.vertical, 2)
                }
                .listRowSeparator(.hidden)
            }
            .scrollContentBackground(.hidden)
            .background(Color.white.edgesIgnoringSafeArea(.all))
            .listStyle(PlainListStyle())
            HStack {
                TextField("Add a comment", text: $commentText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                Button(action: {
                    Task {
                        await sendComment()
                    }
                }) {
                    Text("Post")
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(commentText.trimmingCharacters(in: .whitespaces).isEmpty ? Color.gray : Color.black)
                        .cornerRadius(8)
                }
                .disabled(commentText.trimmingCharacters(in: .whitespaces).isEmpty)

            }
            .padding()


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
            commentText = ""
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
