//
//  UserListView.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/16/23.
//

import SwiftUI
import Firebase
import Kingfisher

struct UserListView: View {
    @State private var isShowingSearchFriends = true
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Add Friends")
                    .fontWeight(.bold)
                    .font(.system(size: 36))
                    .padding(.horizontal, 20)
            }

            if isShowingSearchFriends {
                SearchFriendsView()
            } else {
                FriendRequestsView()
            }

            Spacer()

            HStack(spacing: 10) {
                Button(action: {
                    self.isShowingSearchFriends = true
                }) {
                    Text("Search")
                        .font(.system(size: 15))
                        .padding(7)
                        .background(isShowingSearchFriends ? Color.gray: Color(UIColor.lightGray))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }

                Button(action: {
                    self.isShowingSearchFriends = false
                }) {
                    Text("Requests")
                        .font(.system(size: 15))
                        .padding(7)
                        .background(isShowingSearchFriends ? Color(UIColor.lightGray) : Color.gray)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
            .padding(7)
            .background(Color(UIColor.lightGray))
            .cornerRadius(20)
            .frame(maxWidth: .infinity)
            
            Spacer()
                .frame(height: 20)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SearchFriendsView: View {
    @State private var query = ""
    @StateObject var viewModel = UserListViewModel()
    
    var body: some View {
        TextField("Search Friends", text: $query)
            .padding(.leading, 30)
            .overlay(
                    Image(systemName: "magnifyingglass")
                        .padding(.leading, 5),
                    alignment: .leading
                )
            .autocapitalization(.none)
            .padding(10)
            .cornerRadius(20)
            .background(Color(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .onChange(of: query, perform: { value in
                query = value
                viewModel.searchUsers(text: query)
            }
        )
        ForEach(viewModel.users, id: \.id) { user in
            VStack(alignment: .leading) {
                HStack {
                    if let url = URL(string: user.profileImageURL ?? "") {
                        KFImage(url)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                    VStack(alignment: .leading) {
                        Text(user.fullName)
                            .font(.headline)
                        HStack {
                            Text("\(user.town ?? "Unknown state")")
                                .fontWeight(.light)
                            Text("\(user.state ?? "Unknown state")")
                                .fontWeight(.light)
                        }
                    }
                    Spacer()
                    if viewModel.isUserFriend(userId: user.id) {
                                Button(action: {
                                    // Call function to remove friend
                                    if let currentUserID = Auth.auth().currentUser?.uid {
                                        Task {
                                            do {
                                                try await viewModel.removeFriend(userID: currentUserID, friendID: user.id)
                                            } catch {
                                                print("Error adding friend: \(error)")
                                            }
                                        }
                                    }
                                }) {
                                    Text("Remove Friend")
                                }
                            } else {
                                Button(action: {
                                    // Call function to add friend
                                    if let currentUserID = Auth.auth().currentUser?.uid {
                                        viewModel.sendFriendRequest(userId: currentUserID, to: user.id)
                                    }
                                    
                                }) {
                                    Text("Add Friend")
                                }
                            }
                }
                
            }
            .padding(5)
        }
    }
}

struct FriendRequestsView: View {
    @StateObject var viewModel = UserListViewModel()
    var body: some View {
        Text("Friend Requests (\(viewModel.friendRequestsViewData.count))")
            .padding([.top, .bottom], 10)
            .frame(maxWidth: .infinity, alignment: .leading)
        ForEach(viewModel.friendRequestsViewData) { user in
            HStack {
                if let url = URL(string: user.user.profileImageURL ?? "") {
                    KFImage(url)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                }
                VStack(alignment: .leading) {
                    Text(user.user.fullName)
                        .font(.headline)
                    HStack {
                        Text("\(user.user.town ?? "Unknown state")")
                            .fontWeight(.light)
                        Text("\(user.user.state ?? "Unknown state")")
                            .fontWeight(.light)
                    }
                }
                Spacer()
                Button(action: {
                    if let requestId = user.friendRequest.id {
                        viewModel.rejectFriendRequest(requestId: requestId, from: user.friendRequest.senderId)
                    } else {
                        print("Request invalid")
                    }
                }) {
                    Text("Reject")
                }
                Button(action: {
                    if let requestId = user.friendRequest.id {
                        viewModel.acceptFriendRequest(requestId: requestId, from: user.friendRequest.senderId)
                    } else {
                        print("Request invalid")
                    }
                }) {
                    Text("Accept")
                }
            }
        }
    }
}


