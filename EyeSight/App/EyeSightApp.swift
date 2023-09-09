//
//  EyeSightApp.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/15/23.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    
    private var listener: ListenerRegistration?
    
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    preloadData()

    return true
  }
    
    func preloadData() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let userDocument = Firestore.firestore().collection("users").document(currentUserID)
        
        listener = userDocument.addSnapshotListener { (document, error) in
            if let document = document, document.exists {
                do {
                    let user = try document.data(as: User.self)
                    let friendsIDs = user.friends ?? []
                    
                    var fetchedFriends: [Friend] = []
                    let group = DispatchGroup()
                    
                    for id in friendsIDs {
                        group.enter()
                        
                        let docRef = Firestore.firestore().collection("users").document(id)
                        
                        docRef.getDocument { (document, error) in
                            if let document = document, document.exists {
                                if let data = document.data() {
                                    let friend = Friend(
                                        id: data["id"] as? String ?? "",
                                        name: data["fullName"] as? String ?? "",
                                        locationId: data["locationId"] as? String ?? "",
                                        profileImageURL: data["profileImageURL"] as? String ?? "",
                                        town: data["town"] as? String ?? "",
                                        state: data["state"] as? String ?? ""
                                    )
                                    fetchedFriends.append(friend)
                                    print(friend)
                                }
                            } else {
                                print("Document does not exist or there was an error fetching document")
                            }
                            group.leave()
                        }
                    }
                    
                    group.notify(queue: .main) {
                        DataManager.shared.friends = fetchedFriends
                    }
                    
                } catch let error {
                    print("Error decoding user: \(error)")
                }
            }
        }
    }
}

@main
struct EyeSightApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authViewModel = AuthService()
    var body: some Scene {
        WindowGroup {
                    HomeView()
                        .environmentObject(authViewModel)
                }
    }
}
