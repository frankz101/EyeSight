//
//  FeedView.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/16/23.
//

import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()

    var body: some View {
        VStack {
            //Header
            HStack {
                Text("Feed")
                    .font(.largeTitle).bold()
                Spacer()
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 48, height: 48)
            }
            .padding(.horizontal, 16)
            .padding(.vertical,4)
            
            // Posts
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(viewModel.posts, id: \.id) { post in
                    PostView(post: post, hasUserPostedToday: viewModel.hasPostedToday)
                }
            }
            
            Spacer()
        }
        .onReceive(viewModel.$refreshFeed) { refresh in
            if refresh {
                viewModel.forceRefresh()
                viewModel.refreshFeed = false
            }
        }
    }
}





struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
