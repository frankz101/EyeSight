//
//  PostMapView.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/26/23.
//

import SwiftUI
import Kingfisher
import FirebaseFirestore

struct PostMapView: View {
    @StateObject var viewModel = FeedViewModel()
    @StateObject var commentViewModel = CommentViewModel()
    
    let postId: String
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    if let urlString = viewModel.user?.profileImageURL, let url = URL(string: urlString) {
                        KFImage(url)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .cornerRadius(50)
                    } else {
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .cornerRadius(50)
                    }
                    VStack (alignment: .leading){
                        Text(viewModel.post?.username ?? "Loading")
                            .font(.caption)
                            .fontWeight(.bold)
                        Text("\(viewModel.post?.town ?? "Loading"), \(viewModel.post?.state ?? "Loading") ")
                            .font(.caption2)
                            .fontWeight(.light)
                    }
                    Spacer()
                    Image(systemName: "person.3.sequence")
                }
                .padding(.top, 10)
                .padding(.horizontal, 8)
                
                if let urlString = viewModel.post?.imageURL, let url = URL(string: urlString) {
                    KFImage(url)
                    .resizable()
                    .placeholder {
                        Rectangle().foregroundColor(.gray)
                    }
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width)
                    .clipped()
                    .cornerRadius(10)
                    .padding(.bottom, 14)
                } else {
                    VStack {
                        Rectangle()
                            .foregroundColor(.gray)
                            .frame(width: geometry.size.width, height: 200)
                            .cornerRadius(10)
                            .padding(.bottom, 14)
                        
                        Text("Loading image...")
                            .foregroundColor(.secondary)
                    }
                }
                
                // Comment Section Button
                if let commentSectionID = viewModel.post?.commentSectionID {
                    Button(action: {
                        // Navigate to the comment section
                        commentViewModel.isShowingCommentSection = true
                    }) {
                        Text("View Comments")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                            .padding(.bottom, 12)
                    }
                    .sheet(isPresented: $commentViewModel.isShowingCommentSection) {
                        CommentSectionView(viewModel: commentViewModel, commentSectionID: commentSectionID)
                            .presentationDetents([.medium,.large])
                    }
                }
            }
            .onAppear {
                viewModel.fetchPost(postId: postId)
                if let userId = viewModel.post?.userID {
                    viewModel.fetchUser(userId: userId)
                }
                if let commentSectionID = viewModel.post?.commentSectionID {
                    commentViewModel.startListening(commentSectionID: commentSectionID)
                }
            }

            .onDisappear {
                commentViewModel.stopListening()
            }
        }
    }
}




//struct PostMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostMapView()
//    }
//}
