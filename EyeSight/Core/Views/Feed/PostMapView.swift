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
    
    let postId: String
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Image(systemName: "person")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .cornerRadius(50)
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
                    .padding(.bottom, 16)
                } else {
                    VStack {
                        Rectangle()
                            .foregroundColor(.gray)
                            .frame(width: geometry.size.width, height: 200)
                            .cornerRadius(10)
                            .padding(.bottom, 16)
                        
                        Text("Loading image...")
                            .foregroundColor(.secondary)
                    }
                }
                
            }
            .onAppear {
                viewModel.fetchPost(postId: postId)
            }
        }
    }
}



//struct PostMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostMapView()
//    }
//}
