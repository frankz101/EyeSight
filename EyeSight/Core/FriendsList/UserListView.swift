//
//  UserListView.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/16/23.
//

import SwiftUI
import Firebase

struct UserListView: View {
    @StateObject var viewModel = UserListViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(Array(viewModel.friends.enumerated()), id: \.offset) { index, friend in
                    if let fullName = friend["fullName"] as? String {
                        Text(fullName)
                    }
                }
                Spacer()
                ForEach(viewModel.users) { user in
                    Text(user.fullName)
                    Button(action: {
                        if let currentUserID = Auth.auth().currentUser?.uid {
                            Task {
                                do {
                                    try await viewModel.addFriend(userID: currentUserID, friendID: user.id)
                                } catch {
                                    print("Error adding friend: \(error)")
                                }
                            }
                        }
                    }) {
                        Label("Add Friend", systemImage: "person.badge.plus")
                    }
                }
            }
        }
    }
}


