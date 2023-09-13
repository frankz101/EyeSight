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

    func friendTapped(name: String) {
        print(name)
        self.selectedFriendName = name
        print(self.selectedFriendName)
    }

}


