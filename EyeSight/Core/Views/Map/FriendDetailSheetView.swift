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
                    NavigationLink(destination: ProfileView(viewModel: viewModel)) {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(.black)
                            .padding([.trailing], 12)
                    }
                    
                }
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
            }
        }
        .interactiveDismissDisabled()
    }
}






//struct FriendDetailSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendDetailSheetView()
//    }
//}