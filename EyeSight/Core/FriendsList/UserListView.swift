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
    @StateObject var viewModel = UserListViewModel()
    @State private var query = ""
    
    var body: some View {
        
        ScrollView {
            LazyVStack (alignment: .leading) {
                Text("Add Friends")
                    .frame(alignment: .leading)
                    .fontWeight(.bold)
                    .font(.system(size: 36))
                TextField("Search", text: $query)
                    .autocapitalization(.none)
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
                                                Task {
                                                    do {
                                                        try await viewModel.addFriend(userID: currentUserID, friendID: user.id)
                                                    } catch {
                                                        print("Error removing friend: \(error)")
                                                    }
                                                }
                                            }
                                            
                                        }) {
                                            Text("Add Friend")
                                        }
                                    }
//                            Button(action: {
//                                viewModel.currentUser.uid {
//                                    Task {
//                                        do {
//                                            try await viewModel.addFriend(userID: currentUserID, friendID: user.id)
//                                        } catch {
//                                            print("Error adding friend: \(error)")
//                                        }
//                                    }
//                                }
//                            }) {
//                                Label("Add Friend", systemImage: "person.badge.plus")
//                            }
                        }
                    }
                    .padding(5)
                }
//                ForEach(viewModel.users) { user in
//                    Text(user.fullName)
//                    Button(action: {
//                        if let currentUserID = Auth.auth().currentUser?.uid {
//                            Task {
//                                do {
//                                    try await viewModel.addFriend(userID: currentUserID, friendID: user.id)
//                                } catch {
//                                    print("Error adding friend: \(error)")
//                                }
//                            }
//                        }
//                    }) {
//                        Label("Add Friend", systemImage: "person.badge.plus")
//                    }
//                }
            }
        }
        .padding(.horizontal, 20)
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}


