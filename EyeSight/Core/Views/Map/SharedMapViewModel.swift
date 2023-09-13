//
//  SharedMapViewModel.swift
//  EyeSight
//
//  Created by Franklin Zhu on 9/9/23.
//

import Foundation
import CoreLocation
import MapKit

class SharedMapViewModel: ObservableObject {
    @Published var selectedFriendName: String? = nil
    @Published var showUserCustomAnnotations: Bool = true
    @Published var showCustomAnnotations: Bool = true
    
    func friendTapped(name: String) {
        print(name)
        self.selectedFriendName = name
        print(self.selectedFriendName)
    }
    
    // Additional methods to toggle annotation visibility if required
    func toggleUserCustomAnnotations() {
        print("money")
        self.showUserCustomAnnotations.toggle()
    }
    
    func toggleCustomAnnotations() {
        print("love")
        self.showCustomAnnotations.toggle()
    }
}



