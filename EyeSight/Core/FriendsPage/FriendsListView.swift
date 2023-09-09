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
    var body: some View {
        if DataManager.shared.friends.count == 0 {
            VStack{
                Spacer()
                Text("No friends yet.")
                    .foregroundColor(Color(UIColor.lightGray))
                    .multilineTextAlignment(.center)
                Spacer()
            }
            
        } else {
            ScrollView {
                LazyVStack {
                    ForEach(DataManager.shared.friends) { friend in
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
                            Text(friend.name)
                                .font(.headline)
                                .padding(.leading, 5)
                            Spacer()
                            HStack {
                                Text("\(friend.town ?? "") \(friend.state ?? "")")
                                    .fontWeight(.light)
                            }
                        }
                    }
                }
                .listRowSeparator(.hidden)
            } .padding(.horizontal, 5)
                .scrollContentBackground(.hidden)
                .background(Color.white.edgesIgnoringSafeArea(.all))
        }
    }
}
