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
    let onAnnotationTapped: (String) -> Void  
    var friendAnnotations: [String: MKPointAnnotation] {
        return SharedMapService.shared.friendListViewModel.friendAnnotations
    }
    var postAnnotations: [String: MKPointAnnotation] {
        return SharedMapService.shared.friendListViewModel.postAnnotations
    }
    
    
    init(onAnnotationTapped: @escaping (String) -> Void) {
        self.onAnnotationTapped = onAnnotationTapped
    }

    
    func makeUIView(context: Context) -> some UIView {
        let mapView = SharedMapService.shared.mapView
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        
        
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: "CustomAnnotationView")
        mapView.register(UserCustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: "UserCustomAnnotationView")
        
        
        print("makeuiview")

        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // Typecast UIViewType to MKMapView
        guard let mapView = uiView as? MKMapView else { return }

        // Existing code ...

        if let friendName = SharedMapService.shared.sharedMapViewModel.selectedFriendName {
            self.zoomToAnnotation(withName: friendName)
        }

        mapView.removeAnnotations(mapView.annotations)

        let sharedMapViewModel = SharedMapService.shared.sharedMapViewModel

        if sharedMapViewModel.showUserCustomAnnotations {
            print(friendAnnotations)
            for annotation in friendAnnotations.values {
                mapView.addAnnotation(annotation)
            }
        }

        if sharedMapViewModel.showCustomAnnotations {
            for annotation in postAnnotations.values {
                mapView.addAnnotation(annotation)
            }
        }

    }



    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
    
    
    func zoomToAnnotation(withName name: String) {
        let mapView = SharedMapService.shared.mapView
        
        if let annotation = mapView.annotations.first(where: { ($0 as? UserCustomAnnotation)?.userName == name }) {
            
            let currentSpan = mapView.region.span
            let latitudeDelta: CLLocationDegrees = 0.05  // You can customize this value
            let longitudeDelta: CLLocationDegrees = 0.05  // You can customize this value
            
            let adjustedLatitude = annotation.coordinate.latitude - latitudeDelta / 3
            
            let newCenter = CLLocationCoordinate2D(latitude: adjustedLatitude, longitude: annotation.coordinate.longitude)
            
            // Create the new region
            let newRegion = MKCoordinateRegion(center: newCenter, span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta))
            
            // Set the region
            mapView.setRegion(newRegion, animated: true)
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
            let latitudeDelta: CLLocationDegrees = 0.05
            let longitudeDelta: CLLocationDegrees = 0.05
            
            var adjustedCoordinate: CLLocationCoordinate2D?
            
            if let annotation = view.annotation as? CustomAnnotation {
                parent.onAnnotationTapped(annotation.postId)

                let adjustedLatitude = annotation.coordinate.latitude
                adjustedCoordinate = CLLocationCoordinate2D(latitude: adjustedLatitude, longitude: annotation.coordinate.longitude)
            } else if let annotation = view.annotation as? UserCustomAnnotation {
                // Do something specific for UserCustomAnnotation
                // You can zoom in on the annotation just like the CustomAnnotation

                let adjustedLatitude = annotation.coordinate.latitude
                adjustedCoordinate = CLLocationCoordinate2D(latitude: adjustedLatitude, longitude: annotation.coordinate.longitude)
            }
            
            if let adjustedCoordinate = adjustedCoordinate {
                let region = MKCoordinateRegion(
                    center: adjustedCoordinate,
                    span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
                )
                
                mapView.setRegion(region, animated: true)
            }
        }

        
    }
}
