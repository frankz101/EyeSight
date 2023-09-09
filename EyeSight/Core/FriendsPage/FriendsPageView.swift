//
//  UserListView.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/16/23.
//

import SwiftUI
import Firebase
import Kingfisher

struct FriendsPageView: View {
    enum Section: String, CaseIterable {
        case search
        case friends
        case requests
    }
    
    @State private var currentView: Section = .friends
    @State private var bubblePosition: CGFloat = 0
    
    @StateObject var viewModel = FriendsPageViewModel()
    @StateObject var friendsViewModel = FriendsViewModel()

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("eyesight")
                    .fontWeight(.bold)
                    .font(.system(size: 24))
                    .padding(.horizontal, 20)
            }

            switch currentView {
            case .search:
                SearchFriendsView()
            case .friends:
                FriendsListView(friendsViewModel: friendsViewModel)
            case .requests:
                FriendRequestsView()
            }
            
            Spacer()

            HStack(spacing: 10) {
                    ForEach(Section.allCases, id: \.self) { section in
                        Button(action: {
                            withAnimation {
                                currentView = section
                                bubblePosition = calculateBubblePosition(section: section)
                            }
                        }) {
                            Text(section.rawValue)
                                .font(.system(size: 16))
                                .foregroundColor(currentView == section ? Color.black: Color(UIColor.lightGray))
                        }
                        .padding()
                        .background(
                            Color.clear
                                .onAppear {
                                    if section == currentView {
                                        bubblePosition = calculateBubblePosition(section: section)
                                    }
                                }
                        )
                    }
                }
                .padding(7)

                RoundedRectangle(cornerRadius: 20)
                    .opacity(0.1)
                    .frame(width: 80, height: 40)
                    .offset(x: bubblePosition, y: -60)
                    .animation(Animation.spring(), value: bubblePosition)
        }
        .padding()
        .padding(.bottom, 0)
        .frame(maxWidth: .infinity, maxHeight: .infinity)


    }
    func calculateBubblePosition(section: Section) -> CGFloat {
        switch section {
        case .search:
            return -100
        case .friends:
            return -8
        case .requests:
            return 91
        }
    }
}

struct SearchFriendsView: View {
    @State private var query = ""
    @StateObject var viewModel = FriendsPageViewModel()
    
    @State private var searchTimer: Timer?
    
    var body: some View {
        TextField("search friends", text: $query)
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
                            searchTimer?.invalidate()
                            searchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { _ in
                                viewModel.searchUsers(text: value)
                            })
                        })
        ScrollView (showsIndicators: false) {
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
                                .padding(.leading, 5)
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
                                        Text("Remove")
                                    }
                                } else {
                                    Button(action: {
                                        // Call function to add friend
                                        if let currentUserID = Auth.auth().currentUser?.uid {
                                            viewModel.sendFriendRequest(userId: currentUserID, to: user.id)
                                        }
                                        
                                    }) {
                                        Text("Add")
                                    }
                                }
                    }
                    
                }
                .padding(5)
            }
        }
    }
}

struct FriendRequestsView: View {
    @StateObject var viewModel = FriendsPageViewModel()
    var body: some View {
        if viewModel.friendRequestsViewData.count == 0 {
            VStack {
                Spacer()
                Text("No friend requests yet")
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(UIColor.lightGray))
                Spacer()
            }
        } else {
            ScrollView (showsIndicators: false) {
                ForEach(viewModel.friendRequestsViewData) { user in
                    HStack {
                        if let url = URL(string: user.user.profileImageURL ?? "") {
                            KFImage(url)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width:50, height: 50)
                        }
                        VStack(alignment: .leading) {
                            Text(user.user.fullName)
                                .font(.headline)
                                .padding(.leading, 5)
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
            .padding(5)
            .padding(.top, 6)
        }
        }
}


