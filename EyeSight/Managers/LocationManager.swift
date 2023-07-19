import Foundation
import CoreLocation
import Firebase
import FirebaseFirestore

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private let db = Firestore.firestore()
    @Published var currentLocation: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            // User has granted permission. Attempt to get the location document.
            guard let user = Auth.auth().currentUser else { return }
            
            let userLocationDocument = db.collection("locations").document(user.uid)
            userLocationDocument.getDocument { (document, error) in
                if let document = document, document.exists {
                    print("User location document already exists, no need to create a new one.")
                } else {
                    // The document does not exist, create a new one.
                    userLocationDocument.setData(["id": user.uid, "lastLocation": GeoPoint(latitude: 0, longitude: 0)]) { err in
                        if let err = err {
                            print("Error creating document: \(err)")
                        } else {
                            print("Document successfully created!")
                            // Update the user's locationId with the new document's ID.
                            let userDocument = self.db.collection("users").document(user.uid)
                            userDocument.updateData(["locationId": userLocationDocument.documentID])
                        }
                    }
                }
            }
        case .denied, .restricted, .notDetermined:
            // Handle these cases as needed in your app.
            print("Location permissions were not granted.")
        @unknown default:
            // Handle any future cases.
            print("Unknown location authorization status.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
    }
}
