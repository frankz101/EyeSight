//
//  FriendDetailSheetView.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/27/23.
//

import SwiftUI
import Kingfisher

struct FriendDetailSheetView: View {
    @ObservedObject var friendsViewModel: FriendsViewModel
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack (alignment: .center) {
                    Text("Friends")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    
                    Spacer()
                    
                }
                Divider()
                FriendsListView(friendsViewModel: friendsViewModel)
            }
        }
    }
}
