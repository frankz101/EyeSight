//
//  HomeView.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/15/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: AuthService
    @ObservedObject var profileViewModel: ProfileViewModel
    @ObservedObject var userLocationViewModel: UserLocationViewModel
    @ObservedObject var friendsViewModel: FriendsViewModel
    @ObservedObject var sharedMapViewModel: SharedMapViewModel = SharedMapService.shared.sharedMapViewModel

        init() {
            self.userLocationViewModel = UserLocationViewModel(locationManager: LocationManager())
            self.profileViewModel = ProfileViewModel()
            self.friendsViewModel = FriendsViewModel()
            self.sharedMapViewModel = sharedMapViewModel
        }
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                TabBarView(userLocationViewModel: userLocationViewModel, profileViewModel: profileViewModel, sharedMapViewModel: sharedMapViewModel, friendsViewModel: friendsViewModel)
            } else {
                LoginView()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
