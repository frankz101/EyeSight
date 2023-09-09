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
                            } else {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .frame(width:50, height: 50)
                            }
                            Text(friend.fullName)
                                .font(.headline)
                            Spacer()
                            HStack {
                                Text("\(friend.town ?? "Unknown Town")")
                                    .fontWeight(.light)
                                Text("\(friend.state ?? "Unknown State")")
                                    .fontWeight(.light)
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                .scrollContentBackground(.hidden)
                .background(Color.white.edgesIgnoringSafeArea(.all))
                .listStyle(PlainListStyle())

            }
        }
    }
}






//struct FriendDetailSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendDetailSheetView()
//    }
//}
