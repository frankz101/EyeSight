//
//  FeedView.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/16/23.
//

import SwiftUI

struct FeedView: View {
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
                PostView()
                PostView()
                PostView()
            }
            
            
            
            Spacer()
        }
        
    }
}


struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
