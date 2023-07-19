//
//  PostView.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/17/23.
//

import SwiftUI
import Kingfisher
import FirebaseFirestore


struct PostView: View {
    
    let post: Post
    var hasUserPostedToday: Bool
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .cornerRadius(50)
                VStack (alignment: .leading){
                    Text(post.username)
                        .font(.caption)
                        .fontWeight(.bold)
                    Text("New York City")
                        .font(.caption2)
                        .fontWeight(.light)
                }
                Spacer()
                Image(systemName: "person.3.sequence")
            }
            .padding(.top, 10)
            .padding(.horizontal, 8)
            
            KFImage(URL(string: post.imageURL))
                .resizable()
                .placeholder {
                    Rectangle().foregroundColor(.gray)
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: .infinity)
                .clipped()
                .cornerRadius(10)
                .padding(.bottom, 16)
                .blur(radius: hasUserPostedToday ? 0 : 5)
            
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        let samplePost = Post(id: "1", userID: "franklinzhu", username: "franklinzhu", imageURL: "https://firebasestorage.googleapis.com:443/v0/b/eyesight-61f1e.appspot.com/o/images%2F5A7CE166-DDEC-4A7D-B3FD-29C76C87FF1D.jpg?alt=media&token=40591ab1-8173-41ac-a692-b784d1b4c1d7", timestamp: Timestamp(date: Date()))
        return PostView(post: samplePost, hasUserPostedToday: true)
    }
}

