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
    
    func getUserLocation() -> CLLocation? {
        if let location = locationManager.currentLocation {
            return location
        } else {
            // Handle the case where the location is not available
            return nil
        }
    }

    
    func updateUserLocation() {
        guard let userLocation = locationManager.currentLocation else {
            print("User location not available")
            return
        }
        
        guard let user = Auth.auth().currentUser else {
            print("No user is logged in.")
            return
        }

        // Retrieve the user document from Firestore.
        let docRef = db.collection("users").document(user.uid)

        docRef.getDocument { (document, error) in
            guard let document = document, document.exists, let data = document.data() else {
                print("Error fetching user: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Get the current town and state for the user.
            let currentTown = data["town"] as? String
            let currentState = data["state"] as? String
            
            // Get the town and state for the new coordinates.
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
                if let error = error {
                    // Handle the error
                    print("Error while reverse geocoding: \(error.localizedDescription)")
                    return
                }
                
                guard let firstLocation = placemarks?[0],
                      let newTown = firstLocation.locality,
                      let newState = firstLocation.administrativeArea else {
                    print("Unable to get location data")
                    return
                }

                // Check if the town or state have changed and are not unknown.
                if newTown != currentTown || newState != currentState {
                    // The town or state have changed. Update the user document.
                    docRef.updateData([
                        "town": newTown,
                        "state": newState
                    ]) { error in
                        if let error = error {
                            print("Error updating user: \(error)")
                        } else {
                            print("User successfully updated!")
                        }
                    }
                }
            }
            
            // Update the location.
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
