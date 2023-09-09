//
//  UserListViewModel.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/16/23.
//

import Foundation
import SwiftUI
import Firebase

struct FriendRequestViewData: Identifiable {
    let id = UUID()
    let friendRequest: FriendRequest
    let user: User
}

class FriendsPageViewModel: ObservableObject {
    @Published var users = [User]()
    @ObservedObject var friendsViewModel = FriendsViewModel()
    @Published var friendRequests: [FriendRequest] = []
    @Published var friendRequestsViewData = [FriendRequestViewData]()
    
    init() {
        getFriendRequests()
        setupFriendRequestsListener()
    }
    
    func searchUsers(text: String) {
            // Clear the current array
        if (text == "") {
            self.users = []
        } else {
            self.users = []
            // Fetch the users matching the text
        Firestore.firestore().collection("users").whereField("fullName", isGreaterThanOrEqualTo: text)
            .whereField("fullName", isLessThan: text + "{").getDocuments { (querySnapshot, err) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                self.users = documents.map { queryDocumentSnapshot -> User in
                    let data = queryDocumentSnapshot.data()

                    let id = data["id"] as? String ?? ""
                    let fullName = data["fullName"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    let friends = data["friends"] as? [String]
                    let hasPostedToday = data["hasPostedToday"] as? Bool ?? false
                    let locationId = data["locationId"] as? String
                    let profileImageURL = data["profileImageURL"] as? String
                    let town = data["town"] as? String
                    let state = data["state"] as? String
                    
                    return User(id: id, fullName: fullName, email: email, friends: friends, hasPostedToday: hasPostedToday, locationId: locationId, profileImageURL: profileImageURL, town: town, state: state)
                }
            }
            
            // Repeat the fetch for emails
        Firestore.firestore().collection("users").whereField("email", isGreaterThanOrEqualTo: text)
            .whereField("email", isLessThan: text + "{").getDocuments { (querySnapshot, err) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                let newUsers = documents.map { queryDocumentSnapshot -> User in
                    let data = queryDocumentSnapshot.data()

                    let id = data["id"] as? String ?? ""
                    let fullName = data["fullName"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    let friends = data["friends"] as? [String]
                    let hasPostedToday = data["hasPostedToday"] as? Bool ?? false
                    let locationId = data["locationId"] as? String
                    let profileImageURL = data["profileImageURL"] as? String
                    let town = data["town"] as? String
                    let state = data["state"] as? String
                    
                    return User(id: id, fullName: fullName, email: email, friends: friends, hasPostedToday: hasPostedToday, locationId: locationId, profileImageURL: profileImageURL, town: town, state: state)
                }
                
                // Append the new users to the existing array
                self.users.append(contentsOf: newUsers)
            }
        }
        }

    func isUserFriend(userId: String) -> Bool {
        return friendsViewModel.friends.contains(where: { $0.id == userId })
    }
    
    func updateFriendRequestsViewData() {
        // Assuming User has a property 'id' to identify them uniquely
        // Adjust the properties according to your actual data model
        let userDictionary = Dictionary(uniqueKeysWithValues: users.map { ($0.id, $0) })
        
        friendRequestsViewData = friendRequests.compactMap { friendRequest in
            guard let user = userDictionary[friendRequest.senderId] else {
                return nil
            }
            return FriendRequestViewData(friendRequest: friendRequest, user: user)
        }
    }
    
    func setupFriendRequestsListener() {
            guard let currentUserId = Auth.auth().currentUser?.uid else {
                print("No user")
                return
            }

            Firestore.firestore().collection("friendRequests").whereField("receiverId", isEqualTo: currentUserId).addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("Error listening for friend request updates: \(error)")
                    return
                }

                guard let snapshot = snapshot else {
                    print("No snapshot data")
                    return
                }

                // Assuming FriendRequest is a struct or class that can be initialized with a Firestore document
                self.friendRequests = snapshot.documents.compactMap { document in
                    return try? document.data(as: FriendRequest.self)
                }

                // Update friendRequestsViewData after updating friendRequests
                        self.updateFriendRequestsViewData()
            }
        }
    
    // MARK: - Send Friend Request
    func sendFriendRequest(userId: String, to friendId: String) {
        let friendRequest = Firestore.firestore().collection("friendRequests").document()
        let data: [String: Any] = ["senderId": userId, "receiverId": friendId]
        
        friendRequest.setData(data) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(friendRequest.documentID)")
            }
        }
    }

    // MARK: - Accept Friend Request
    func acceptFriendRequest(requestId: String, from senderId: String) {
        if let currentUserId = Auth.auth().currentUser?.uid {
            let currentUserDoc = Firestore.firestore().collection("users").document(currentUserId)
            let senderUserDoc = Firestore.firestore().collection("users").document(senderId)
            
            // Add each user to the other's friend list
            currentUserDoc.updateData([
                "friends": FieldValue.arrayUnion([senderId])
            ])
            
            senderUserDoc.updateData([
                "friends": FieldValue.arrayUnion([currentUserId])
            ])
            
            // Delete the friend request
            Firestore.firestore().collection("friendRequests").document(requestId).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
            getFriendRequests()
        } else {
            print("No user")
        }
        
        
    }
    
    func rejectFriendRequest(requestId: String, from senderId: String) {
        if let currentUserId = Auth.auth().currentUser?.uid {
            
            // Delete the friend request
            Firestore.firestore().collection("friendRequests").document(requestId).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
            getFriendRequests()
        } else {
            print("No user")
        }
        
        
    }
    
    func getFriendRequests() {
            // TODO: Replace with your current user's id
        if let currentUserId = Auth.auth().currentUser?.uid {
            Firestore.firestore().collection("friendRequests").whereField("receiverId", isEqualTo: currentUserId)
                .addSnapshotListener { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
//                        self.friendRequests = querySnapshot?.documents.compactMap { document in
//                            try? document.data(as: FriendRequest.self)
//                        } ?? []
                        querySnapshot?.documents.forEach { docSnapshot in
                            let friendRequestId = docSnapshot.documentID
                            let data = docSnapshot.data()
                            let senderId = data["senderId"] as? String ?? ""
                            
                            Firestore.firestore().collection("users").document(senderId).getDocument { (userDocSnapshot, userErr) in
                                if let userErr = userErr {
                                    print("Error getting user data: \(userErr)")
                                } else {
                                    if let userData = userDocSnapshot?.data() {
                                        let user = User(id: userData["id"] as? String ?? "",
                                                        fullName: userData["fullName"] as? String ?? "",
                                                        email: userData["email"] as? String ?? "",
                                                        friends: userData["friends"] as? [String],
                                                        hasPostedToday: userData["hasPostedToday"] as? Bool ?? false,
                                                        locationId: userData["locationId"] as? String,
                                                        profileImageURL: userData["profileImageURL"] as? String,
                                                        town: userData["town"] as? String,
                                                        state: userData["state"] as? String)
                                        
                                        let friendRequest = FriendRequest(id: friendRequestId, senderId: senderId, receiverId: currentUserId)
                                        let friendRequestViewData = FriendRequestViewData(friendRequest: friendRequest, user: user)
                                        self.friendRequestsViewData.append(friendRequestViewData)
                                    }
                                }
                            }
                        }

                    }
                }
            
        }
            
            
        }
    
    func removeFriend(userID: String, friendID: String) async throws {
        let userDocument = Firestore.firestore().collection("users").document(userID)
        try await userDocument.updateData(["friends": FieldValue.arrayRemove([friendID])])
    }
}
