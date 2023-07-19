//
//  FriendListViewModel.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/16/23.
//

import Foundation
import Firebase
import MapKit
import Kingfisher

class FriendListViewModel: ObservableObject {
    @Published var mapView: MKMapView?
    var friendAnnotations: [String: MKPointAnnotation] = [:]
    var postAnnotations: [String: MKPointAnnotation] = [:]
    
    init(mapView: MKMapView) {
        self.mapView = mapView
    }
    
    func fetchFriendLocations() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let userDocument = Firestore.firestore().collection("users").document(currentUserID)
        userDocument.getDocument { (document, error) in
            if let document = document, document.exists {
                if let friends = document.data()?["friends"] as? [String] {
                    for friendID in friends {
                        self.fetchLocationForFriend(friendID: friendID)
                    }
                }
            }
        }
    }
    
    // Fetch the location for a specific friend
    func fetchLocationForFriend(friendID: String) {
        let locationDocument = Firestore.firestore().collection("locations").document(friendID)
        
        // Listen for real-time changes
        locationDocument.addSnapshotListener { [weak self] (document, error) in
            guard let document = document, document.exists else {
                // Handle the error
                return
            }
            
            if let locationData = document.data()?["lastLocation"] as? GeoPoint {
                let latitude = locationData.latitude
                let longitude = locationData.longitude
                // Add the friend's location to the map
                self?.addFriendLocationToMap(friendID: friendID, latitude: latitude, longitude: longitude)
            }
        }
    }
    
    
    func addFriendLocationToMap(friendID: String, latitude: Double, longitude: Double) {
        // Remove old annotation if it exists
        if let oldAnnotation = friendAnnotations[friendID] {
            mapView?.removeAnnotation(oldAnnotation)
        }
        
        // Add the friend's location to the map
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        // Create a map annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        // Save the annotation in the dictionary
        friendAnnotations[friendID] = annotation
        
        // Add the new annotation to the map
        mapView?.addAnnotation(annotation)
    }
    
    //FETCH ANNOTATIONS OF POSTS
    
    // Fetch annotations for posts
    func fetchFriendPosts() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let userDocument = Firestore.firestore().collection("users").document(currentUserID)
        userDocument.getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                if let friends = document.data()?["friends"] as? [String] {
                    for friendID in friends {
                        self?.fetchPostsForFriend(friendID: friendID)
                    }
                }
            }
        }
    }
    
    // Fetch the posts for a specific friend
    func fetchPostsForFriend(friendID: String) {
        let postsCollection = Firestore.firestore().collection("posts")
        let query = postsCollection.whereField("userID", isEqualTo: friendID)
        
        query.addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                // Handle the error
                return
            }
            
            for document in documents {
                
                if let post = try? document.data(as: Post.self) {
                    let latitude = post.location.latitude
                    let longitude = post.location.longitude
                    // Add the post's location to the map
                    self?.addPostLocationToMap(postID: post.id, latitude: latitude, longitude: longitude, imageUrl: post.imageURL)
                }
            }
        }
    }
    
    
    
    
    
    // MARK: - MKMapViewDelegate
    
    func addPostLocationToMap(postID: String, latitude: Double, longitude: Double, imageUrl: String?) {
        // Remove old annotation if it exists
        
        if let oldAnnotation = postAnnotations[postID] {
            mapView?.removeAnnotation(oldAnnotation)
        }
        
        
        // Create a new annotation
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let customAnnotation = CustomAnnotation(imageURL: imageUrl!)
        
        customAnnotation.coordinate = coordinate
        
        print(customAnnotation)

        
        // Save the annotation in the dictionary
        postAnnotations[postID] = customAnnotation
        
        // Add the new annotation to the map
        mapView?.addAnnotation(customAnnotation)
    }
    
}

