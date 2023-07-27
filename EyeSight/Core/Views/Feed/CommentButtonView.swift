//
//  CommentButtonView.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/26/23.
//

import SwiftUI

struct CommentButtonView: View {
    @StateObject var viewModel = CommentViewModel()
    @State private var showCommentSection = false
    let commentSectionID: String // pass this in from where you instantiate this view

    var body: some View {
        Button(action: {
            showCommentSection = true
        }) {
            Text("Add A Comment")
        }
        .sheet(isPresented: $showCommentSection) {
            CommentSectionView(viewModel: viewModel, commentSectionID: commentSectionID)
        }
    }
}


//struct CommentButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentButtonView()
//    }
//}
