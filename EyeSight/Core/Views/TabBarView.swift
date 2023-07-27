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
    
    var body: some View {
        TabView(selection: $selectedTab) {
            FeedView()
                .tabItem{
                    Label("Feed", systemImage: "house.fill")
                }
                .tag(0)

            MapWithCameraButtonView(userLocationViewModel: userLocationViewModel)
                .ignoresSafeArea()
                .tabItem{
                    Label("Home",  systemImage:"location.fill")
                }
                .tag(1)
                    
            CameraTestView {
                self.selectedTab = 0
            }
            .tabItem {
                Label("Camera", systemImage:"camera.fill")
            }
            .tag(2)

            FriendsView()
                .tabItem {
                    Label("Friends", systemImage:"person.fill")
                }
                .tag(3)

            ProfileView(viewModel: profileViewModel)
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
                .tag(4)
        }

    }
}



//struct TabBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        let userLocationViewModel = UserLocationViewModel(locationManager: MapViewRepresentable.locationManager)
//        return TabBarView(userLocationViewModel: userLocationViewModel, profileViewModel: <#ProfileViewModel#>)
//            .environmentObject(UserPhotoViewModel())
//    }
//}
