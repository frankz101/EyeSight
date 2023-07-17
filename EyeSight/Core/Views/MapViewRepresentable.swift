//
//  MapViewRepresentable.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/15/23.
//

import Foundation
import SwiftUI
import MapKit

struct MapViewRepresentable: UIViewRepresentable {
    static let locationManager = LocationManager()
    let mapView = MKMapView()
    let userLocationViewModel: UserLocationViewModel
    let friendListViewModel: FriendListViewModel
    
    init(userLocationViewModel: UserLocationViewModel) {
        self.userLocationViewModel = userLocationViewModel
        self.friendListViewModel = FriendListViewModel(mapView: self.mapView)
    }
    
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        friendListViewModel.fetchFriendLocations()
        return mapView
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
    func fetchFriendLocations() {
        friendListViewModel.fetchFriendLocations()
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
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            parent.mapView.setRegion(region, animated: true)
            // Calculate distance from last location
            let currentLocation = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            if let lastLocation = lastLocation, lastLocation.distance(from: currentLocation) > 7.62 {
                // Update the user location in the database
                parent.userLocationViewModel.updateUserLocation()
            }
            
            // Store the current location as the last updated location
            lastLocation = currentLocation
        }
    }
}
