//
//  AuthService.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/16/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

@MainActor
class AuthService: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?

    static let shared = AuthService()

    init() {
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUserData()
            }
    }
    func login(withEmail email: String, password: String) async throws {

    }

    func createUser(email: String, password: String, fullName: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullName: fullName, email: email, friends: nil, hasPostedToday: false, locationId: nil)
            let encodedUser = try Firestore.Encoder().encode(user);
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUserData()
        } catch {
            print("Failed to create user with error \(error.localizedDescription)")
        }
    }

    func fetchUserData() async {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {return}
        if let data = snapshot.data(), let user = try? Firestore.Decoder().decode(User.self, from: data) {
                self.currentUser = user
            } else {
                print("Failed to fetch user data")
            }
    }

    func signout() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
//            self.currentUser = nil
        } catch {
            print("failed")
        }
    }
}
