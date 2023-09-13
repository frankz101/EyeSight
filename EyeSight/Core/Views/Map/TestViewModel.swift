//
//  TestViewModel.swift
//  EyeSight
//
//  Created by Franklin Zhu on 9/10/23.
//

import Foundation
import MapKit

class TestViewModel: ObservableObject {
    
    @Published var userNameToFocus: String? = nil
    @Published var mapView: MKMapView?
    
    init(mapView: MKMapView) {
        self.mapView = mapView
    }
    
    func focusOnFriend(withUserName userName: String) {
        self.userNameToFocus = userName
    }
}
