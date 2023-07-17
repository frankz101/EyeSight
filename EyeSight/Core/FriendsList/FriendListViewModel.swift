//
//  FriendListViewModel.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/16/23.
//

import Foundation
import Firebase
import MapKit

class FriendListViewModel: ObservableObject {
    @Published var mapView: MKMapView?
    var friendAnnotations: [String: MKPointAnnotation] = [:]
    
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
}

