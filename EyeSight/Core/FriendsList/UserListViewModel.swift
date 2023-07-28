//
//  UserListViewModel.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/16/23.
//

import Foundation
import Firebase

class UserListViewModel: ObservableObject {
    @Published var users = [User]()
    @Published var friends = [[String: Any]]()
    
    init() {
        Task { try await fetchAllUsers() }
        Task {
            do {
                let fetchedFriends = try await fetchFriends()
                DispatchQueue.main.async {
                    self.friends = fetchedFriends
                }
            } catch {
                // Handle error here.
                print("Error fetching friends: \(error)")
            }
        }

    }
    @MainActor
    func fetchAllUsers() async throws {
        let fetchedUsers = try await UserService.fetchAllUsers()
        users = fetchedUsers
    }
    
    func fetchFriends() async throws -> [[String: Any]] {
        guard let userID = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Unable to retrieve user ID"])
        }
        
        let firestore = Firestore.firestore()
        let snapshot = try await firestore.collection("users").whereField("id", isEqualTo: userID).getDocuments()
        
        guard let document = snapshot.documents.first,
              let friends = document.data()["friends"] as? [String] else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Unable to retrieve friends list"])
        }
        
        var friendsInfo = [[String: Any]]()
        
        for friendID in friends {
            let friendSnapshot = try await firestore.collection("users").whereField("id", isEqualTo: friendID).getDocuments()
            
            for document in friendSnapshot.documents {
                friendsInfo.append(document.data())
            }
        }
        
        return friendsInfo
    }

    
    func addFriend(userID: String, friendID: String) async throws {
        let userDocument = Firestore.firestore().collection("users").document(userID)
        try await userDocument.updateData(["friends": FieldValue.arrayUnion([friendID])])
    }
}
