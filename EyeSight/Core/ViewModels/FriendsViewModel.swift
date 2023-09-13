//
//  FriendsViewModel.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/27/23.
//

import Foundation
import FirebaseFirestore
import Firebase

class FriendsViewModel: ObservableObject {
    @Published var friends: [User] = []
    private var listener: ListenerRegistration?
    
    init() {
        fetchFriends()
    }
    
    func fetchFriends() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let userDocument = Firestore.firestore().collection("users").document(currentUserID)
        
        listener = userDocument.addSnapshotListener { (document, error) in
            if let document = document, document.exists {
                do {
                    let user = try document.data(as: User.self)
                    let friendsIDs = user.friends ?? []
                    
                    var fetchedFriends: [User] = []
                    let group = DispatchGroup()
                    
                    for id in friendsIDs {
                        group.enter()
                        self.fetchUser(withId: id) { (friendUser) in
                            if let friendUser = friendUser {
                                fetchedFriends.append(friendUser)
                            }
                            group.leave()
                        }
                    }
                    
                    group.notify(queue: .main) {
                        self.friends = fetchedFriends
                    }
                    
                } catch let error {
                    print("Error decoding user: \(error)")
                }
            }
        }
    }

    func fetchUser(withId id: String, completion: @escaping (User?) -> Void) {
        let userDocument = Firestore.firestore().collection("users").document(id)
        
        userDocument.getDocument { (document, error) in
            if let document = document, document.exists {
                do {
                    let user = try document.data(as: User.self)
                    completion(user)
                } catch let error {
                    print("Error decoding user: \(error)")
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    func fetchLocation(by locationId: String, completion: @escaping (Double?, Double?) -> Void) {
        let locationDocument = Firestore.firestore().collection("locations").document(locationId)
        
        locationDocument.getDocument { (document, error) in
            if let document = document, document.exists {
                if let locationData = document.data()?["lastLocation"] as? GeoPoint {
                    let latitude = locationData.latitude
                    let longitude = locationData.longitude
                    completion(latitude, longitude)
                } else {
                    print("Error decoding location: GeoPoint not found")
                    completion(nil, nil)
                }
            } else {
                completion(nil, nil)
            }
        }
    }



    // It's a good idea to stop listening when the object is deinitialized
    deinit {
        listener?.remove()
    }
}
