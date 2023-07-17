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
    
    init() {
        Task { try await fetchAllUsers() }
    }
    @MainActor
    func fetchAllUsers() async throws {
        let fetchedUsers = try await UserService.fetchAllUsers()
        users = fetchedUsers
    }
    func addFriend(userID: String, friendID: String) async throws {
        let userDocument = Firestore.firestore().collection("users").document(userID)
        try await userDocument.updateData(["friends": FieldValue.arrayUnion([friendID])])
    }
}
