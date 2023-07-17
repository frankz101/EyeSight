//
//  TabBarView.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/16/23.
//

import SwiftUI

struct TabBarView: View {
    @ObservedObject var userLocationViewModel: UserLocationViewModel
    @State private var selectedTab = 1 // Set the index of MapViewRepresentable tab
    
    var body: some View {
        
            TabView(selection: $selectedTab) {
                FeedView()
                    .tabItem{
                        Label("Feed", systemImage: "house.fill")
                    }
                    .tag(0) // Set the tag for the FeedView tab
                MapViewRepresentable(userLocationViewModel: userLocationViewModel)
                    .ignoresSafeArea()
                    .tabItem{
                        Label("Home",  systemImage:"location.fill")
                    }
                    .tag(1) // Set the tag for the MapViewRepresentable tab
                FriendsView()
                    .tabItem{
                        Label("Friends", systemImage:"person.fill")
                    }
                    .tag(2) // Set the tag for the FriendsView tab
            }
        
        
    }
}


struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
            let userLocationViewModel = UserLocationViewModel(locationManager: MapViewRepresentable.locationManager)
            TabBarView(userLocationViewModel: userLocationViewModel)
        }}
