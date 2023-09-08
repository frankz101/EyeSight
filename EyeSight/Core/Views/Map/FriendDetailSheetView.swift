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
                List(friendsViewModel.friends, id: \.id) { friend in
                    VStack(alignment: .leading) {
                        HStack {
                            if let url = URL(string: friend.profileImageURL ?? "") {
                                KFImage(url)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            }
                            VStack(alignment: .leading) {
                                Text(friend.fullName)
                                    .font(.headline)
                                HStack {
                                    Text("\(friend.town ?? "Unknown state")")
                                        .fontWeight(.light)
                                    Text("\(friend.state ?? "Unknown state")")
                                        .fontWeight(.light)
                                }
                            }
                        }
                    }
                    .padding(5)
                }
                .scrollContentBackground(.hidden)
                .background(Color.white.edgesIgnoringSafeArea(.all))

            }
        }
    }
}






//struct FriendDetailSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendDetailSheetView()
//    }
//}
