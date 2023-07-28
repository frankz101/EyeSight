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
    @State private var search = ""
    
    var body: some View {
        ScrollView {
            LazyVStack (alignment: .leading) {
                Text("Friends")
                    .frame(alignment: .leading)
                    .fontWeight(.bold)
                    .font(.system(size: 36))
                TextField("Search", text: $search)
                    .autocapitalization(.none)
                    .onSubmit {
                        print(search)
                    }
                ForEach(Array(viewModel.friends.enumerated()), id: \.offset) { index, friend in
                    HStack (spacing: 10) {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                        if let fullName = friend["fullName"] as? String, let email = friend["email"] as? String {
                            VStack (alignment: .leading) {
                                Text(fullName)
                                Text(email)
                                    .font(.system(size: 12))
                            }
                        }
                        Spacer()
                        Button (action: {
                            print("Removed")
                        }) {
                            Text("Remove Friend")
                        }
                    }
                    .padding(.bottom, 20)
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
        .padding(.horizontal, 20)
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}


