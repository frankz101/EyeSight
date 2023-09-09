//
//  FriendsListView.swift
//  EyeSight
//
//  Created by Andy Ren on 9/8/23.
//

import Foundation
import SwiftUI
import Kingfisher

struct FriendsListView: View {
    @ObservedObject var friendsViewModel: FriendsViewModel
    var body: some View {
        if friendsViewModel.friends.count == 0 {
            VStack{
                Spacer()
                Text("No friends yet.")
                    .foregroundColor(Color(UIColor.lightGray))
                    .multilineTextAlignment(.center)
                Spacer()
            }
            
        } else {
            List(friendsViewModel.friends, id: \.id) { friend in
                VStack(alignment: .leading) {
                    HStack {
                        if let url = URL(string: friend.profileImageURL ?? "") {
                            KFImage(url)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width:50, height: 50)
                        }
                        Text(friend.fullName)
                            .font(.headline)
                            .padding(.leading, 5)
                        Spacer()
                        HStack {
                            Text("\(friend.town ?? ""), \(friend.state ?? "")")
                                .fontWeight(.light)
                        }
                    }
                }
                .listRowSeparator(.hidden)
            }
            .padding(.horizontal, -15)
            .scrollContentBackground(.hidden)
            .background(Color.white.edgesIgnoringSafeArea(.all))
            .listStyle(PlainListStyle())
        }
    }
}
