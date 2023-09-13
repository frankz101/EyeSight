//
//  MapViewRepresentable.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/15/23.
//

import Foundation
import SwiftUI
import MapKit
import FirebaseFirestore


// Singleton to hold shared resources
final class SharedMapService {
    static let shared = SharedMapService()

    let mapView: MKMapView
    let userLocationViewModel: UserLocationViewModel
    let friendListViewModel: FriendListViewModel
    let sharedMapViewModel: SharedMapViewModel
    static let locationManager = LocationManager()

    private init() {
        mapView = MKMapView()
        userLocationViewModel = UserLocationViewModel(locationManager: SharedMapService.locationManager)
        friendListViewModel = FriendListViewModel(mapView: mapView)
        sharedMapViewModel = SharedMapViewModel()
    }
}



struct MapViewRepresentable: UIViewRepresentable {
    let onAnnotationTapped: (String) -> Void  // Changed this to take a String
//    static let locationManager = LocationManager()
//    let mapView = MKMapView()
//    let userLocationViewModel: UserLocationViewModel
//    let friendListViewModel: FriendListViewModel
//    let sharedMapViewModel: SharedMapViewModel
    
//    init(userLocationViewModel: UserLocationViewModel, sharedMapViewModel: SharedMapViewModel, onAnnotationTapped: @escaping (String) -> Void) {  // Changed this to take a String
//
//        self.userLocationViewModel = userLocationViewModel
//        self.onAnnotationTapped = onAnnotationTapped
//        self.friendListViewModel = FriendListViewModel(mapView: self.mapView)
//        self.sharedMapViewModel = sharedMapViewModel
//
//        print("init")
//    }
    
    
    init(onAnnotationTapped: @escaping (String) -> Void) {
        self.onAnnotationTapped = onAnnotationTapped
    }

    
    func makeUIView(context: Context) -> some UIView {
        let mapView = SharedMapService.shared.mapView
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        
        
//        mapView.register(UserCustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
//        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: "CustomAnnotationView")
        mapView.register(UserCustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: "UserCustomAnnotationView")
        
        
//        friendListViewModel.fetchFriendLocations()
//        friendListViewModel.fetchFriendPosts()
        
        print("makeuiview")

        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // Existing code ...

        print(SharedMapService.shared.sharedMapViewModel.selectedFriendName)
        
        if let friendName = SharedMapService.shared.sharedMapViewModel.selectedFriendName {
            print("friendname")
            self.zoomToAnnotation(withName: friendName)
        }
    }


    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
    
    
    func zoomToAnnotation(withName name: String) {
        print("zoomto")
        let mapView = SharedMapService.shared.mapView
        print(name)
        print(mapView.annotations)
        if let annotation = mapView.annotations.first(where: { ($0 as? UserCustomAnnotation)?.userName == name }) {
            print("in function")
            let coordinate = annotation.coordinate
            let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            mapView.setRegion(region, animated: true)
        }
    }
    
}

extension MapViewRepresentable {
    class MapCoordinator: NSObject, MKMapViewDelegate {
        let parent: MapViewRepresentable
        var lastLocation: CLLocation?
        
        init(parent: MapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            let currentLocation = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            if let lastLocation = lastLocation, lastLocation.distance(from: currentLocation) > 7.62 {
                SharedMapService.shared.userLocationViewModel.updateUserLocation()
            }
            lastLocation = currentLocation
        }

        
//        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//            let currentLocation = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
//            if let lastLocation = lastLocation, lastLocation.distance(from: currentLocation) > 7.62 {
//                parent.userLocationViewModel.updateUserLocation()
//            }
//            
//            lastLocation = currentLocation
//        }
        
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if let userCustomAnnotation = annotation as? UserCustomAnnotation {
                let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "UserCustomAnnotationView") as? UserCustomAnnotationView
                // Configure and return the UserCustomAnnotationView
                return annotationView
            } else if let customAnnotation = annotation as? CustomAnnotation {
                let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "CustomAnnotationView") as? CustomAnnotationView
                // Configure and return the CustomAnnotationView
                return annotationView
            }
            // Handle other annotation types if needed
            return nil
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation as? CustomAnnotation {
                parent.onAnnotationTapped(annotation.postId)

                let latitudeDelta: CLLocationDegrees = 0.05
                let longitudeDelta: CLLocationDegrees = 0.05

                let adjustedLatitude = annotation.coordinate.latitude - latitudeDelta / 2
                let adjustedCoordinate = CLLocationCoordinate2D(latitude: adjustedLatitude, longitude: annotation.coordinate.longitude)

                let region = MKCoordinateRegion(
                    center: adjustedCoordinate,
                    span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
                )
                print(mapView.annotations)
                mapView.setRegion(region, animated: true)
            }
        }
        
    }
}
