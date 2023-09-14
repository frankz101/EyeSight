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
    @Published var showCustomAnnotations: Bool = false
    @Published var hasFetchedFriendData: Bool = false
    
    func friendTapped(name: String) {
        self.selectedFriendName = name
    }
    
    // Additional methods to toggle annotation visibility
    func toggleUserCustomAnnotations() {
        self.showUserCustomAnnotations.toggle()
        self.showCustomAnnotations.toggle()
        
        // Fetch data if it hasn't been fetched yet
        if !hasFetchedFriendData {
            SharedMapService.shared.friendListViewModel.fetchFriendPosts()
            hasFetchedFriendData = true
        }
    }
    
    func toggleCustomAnnotations() {
        self.showCustomAnnotations.toggle()
        self.showUserCustomAnnotations.toggle()
        
        // Fetch data if it hasn't been fetched yet
        if !hasFetchedFriendData {
            SharedMapService.shared.friendListViewModel.fetchFriendPosts()
            hasFetchedFriendData = true
        }
    }
}




