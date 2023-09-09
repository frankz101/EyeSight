//
//  TabBarView.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/16/23.
//

import SwiftUI

struct TabBarView: View {
    @ObservedObject var userLocationViewModel: UserLocationViewModel
    @EnvironmentObject var userPhotoViewModel: UserPhotoViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    @State private var selectedTab = 1 // Set the index of MapViewRepresentable tab
    @State private var isActiveTab: Bool = false
    
    let gradient = LinearGradient(colors: [.orange, .green],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
    var body: some View {
        ZStack {
            TabView (selection: $selectedTab) {
                ZStack {
                    
                    FriendsPageView()
                }
                .tabItem{
                    Label("home", systemImage: "house.fill")
                }
                .tag(0)
                
                ZStack {
                    
                    MapWithCameraButtonView(userLocationViewModel: userLocationViewModel, viewModel: profileViewModel)
                }
                .tabItem{
                    Label("map",  systemImage:"location.fill")
                }
                .tag(1)
                
                ZStack {
                    
                    ProfileView(viewModel: profileViewModel)
                }
                .tabItem {
                    Label("profile", systemImage: "person.crop.circle.fill")
                }
                .tag(2)
            }
            .overlay(
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 1)
                    .offset(y: -49), // This offset may need to be adjusted
                alignment: .bottom
            )
            .accentColor(.black)
        }

        
            
            
                                
    
//    let gradient = LinearGradient(colors: [.blue.opacity(0.3), .green.opacity(0.5)],
//                                  startPoint: .topLeading,
//                                  endPoint: .bottomTrailing)
//
//    var body: some View {
//        ZStack {
//            gradient.ignoresSafeArea()
//            TabView(selection: $selectedTab) {
//                FeedView()
//                    .tabItem{
//                        Label("Feed", systemImage: "house.fill")
//                    }
//                    .tag(0)
//
//                MapWithCameraButtonView(userLocationViewModel: userLocationViewModel, friendsViewModel: friendsViewModel, viewModel: profileViewModel)
//                    .tabItem{
//                        Label("Home",  systemImage:"location.fill")
//                    }
//                    .tag(1)
//
//                CameraTestView {
//                    self.selectedTab = 0
//                }
//                .tabItem {
//                    Label("Camera", systemImage:"camera.fill")
//                }
//                .tag(2)
//
//                FriendsView()
//                    .tabItem {
//                        Label("Friends", systemImage:"person.fill")
//                    }
//                    .tag(3)
//
//                ProfileView(viewModel: profileViewModel)
//                    .tabItem {
//                        Label("Profile", systemImage: "person.crop.circle.fill")
//                    }
//                    .tag(4)
//            }
//            .background(Color.clear)

        
    }
}




//struct TabBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        let userLocationViewModel = UserLocationViewModel(locationManager: MapViewRepresentable.locationManager)
//        return TabBarView(userLocationViewModel: userLocationViewModel, profileViewModel: <#ProfileViewModel#>)
//            .environmentObject(UserPhotoViewModel())
//    }
//}
