//
//  UserLocationViewModel.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/16/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth
import CoreLocation

class UserLocationViewModel: ObservableObject {
    @Published var userLocation: CLLocation?
    
    private var locationManager: LocationManager
    private let db = Firestore.firestore()
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
    }
    
    func updateUserLocation() {
        self.userLocation = locationManager.currentLocation
        if let userLocation = self.userLocation, let user = Auth.auth().currentUser {
            // Retrieve the user document from Firestore.
            db.collection("users").document(user.uid).getDocument { (document, error) in
                if let error = error {
                    print("Error fetching user: \(error)")
                } else if let document = document, document.exists, let data = document.data() {
                    if let locationId = data["locationId"] as? String {
                        // We have the locationId. Update the corresponding location document.
                        let geoPoint = GeoPoint(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
                        self.db.collection("locations").document(locationId).setData(["lastLocation": geoPoint], merge: true) { err in
                            if let err = err {
                                print("Error updating location: \(err)")
                            } else {
                                print("Location successfully updated!")
                            }
                        }
                    }
                }
            }
        }
    }
    
}
