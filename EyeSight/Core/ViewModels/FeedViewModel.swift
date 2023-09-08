//
//  FeedViewModel.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/18/23.
//
import Foundation
import SwiftUI
import Combine
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class FeedViewModel: ObservableObject {
    
    @Published var post: Post?
    @Published var user: User?
    
    var userProfileListener: ListenerRegistration?
    
    
    @Published var posts = [Post]()
    @Published var hasPostedToday = false
    @Published var refreshFeed: Bool = false {
        didSet {
            if refreshFeed {
                generateFeedForUser()
            }
        }
    }

    private var postIDs = Set<String>()
    
    private var db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    
    private var userListener: ListenerRegistration?
    private var friendPostsListeners = [ListenerRegistration]()
    
    init() {
        generateFeedForUser()
    }
    
    
    
    func fetchUser() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No user is logged in.")
            return
        }
        
        let docRef = Firestore.firestore().collection("users").document(userID)
        
        userProfileListener = docRef.addSnapshotListener { (documentSnapshot, error) in
            if let document = documentSnapshot, document.exists {
                let user = try? document.data(as: User.self)
                DispatchQueue.main.async {
                    self.user = user
                    self.hasPostedToday = user?.hasPostedToday ?? false
                }
            } else if let error = error {
                print("Error fetching user: \(error)")
            }
        }
    }
    
    func fetchPost(postId: String) {
        let docRef = Firestore.firestore().collection("posts").document(postId)

        docRef.getDocument { [weak self] (documentSnapshot, error) in
            if let document = documentSnapshot, document.exists {
                do {
                    let post = try document.data(as: Post.self)
                    DispatchQueue.main.async {
                        self?.post = post
                    }
                } catch {
                    print("Error decoding post: \(error)")
                }
            } else {
                print("Document does not exist")
            }
        }
    }

    
    deinit {
        userListener?.remove()
    }
    private func generateFeedForUser() {
        // get the current user
        guard let user = Auth.auth().currentUser else {
            print("User is not authenticated")
            return
        }
        
        // Clear existing listeners
        userListener?.remove()
        friendPostsListeners.forEach { $0.remove() }
        friendPostsListeners.removeAll()
        
        // Clear existing posts and post IDs
        posts.removeAll()
        postIDs.removeAll()
        
        // Listen for changes in the user's document
        userListener = db.collection("users").document(user.uid).addSnapshotListener { [weak self] documentSnapshot, error in
            guard let self = self else { return }
            
            if let document = documentSnapshot, document.exists {
                do {
                    // Decode the user
                    let userData = try document.data(as: User.self)
                    
                    // Set hasPostedToday
                    self.hasPostedToday = userData.hasPostedToday
                    
                    // If the user has friends
                    if let friends = userData.friends {
                        // Listen for changes in the friend list
                        for friendID in friends {
                            let listener = self.db.collection("posts")
                                .whereField("userID", isEqualTo: friendID)
                                .whereField("timestamp", isGreaterThan: Date().addingTimeInterval(-60 * 60 * 24)) // last 24 hours
                                .order(by: "timestamp", descending: true)
                                .addSnapshotListener { [weak self] querySnapshot, error in
                                    guard let self = self else { return }
                                    
                                    if let querySnapshot = querySnapshot {
                                        do {
                                            // Decode the posts
                                            let friendPosts = try querySnapshot.documents.compactMap { try $0.data(as: Post.self) }
                                            
                                            // Append the fetched posts to the existing array
                                            DispatchQueue.main.async {
                                                for post in friendPosts {
                                                    if !self.postIDs.contains(post.id) {
                                                        self.posts.append(post)
                                                        self.postIDs.insert(post.id)
                                                    }
                                                }
                                            }
                                        } catch {
                                            print("Error decoding posts: \(error)")
                                        }
                                    }
                                }
                            
                            self.friendPostsListeners.append(listener)
                        }
                    }
                } catch {
                    print("Error decoding user: \(error)")
                }
            }
        }
        self.refreshFeed = false
    }

    func forceRefresh() {
        generateFeedForUser()
    }
}
