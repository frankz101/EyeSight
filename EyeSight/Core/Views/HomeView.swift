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

        init() {
            self.userLocationViewModel = UserLocationViewModel(locationManager: LocationManager())
            self.profileViewModel = ProfileViewModel()
            self.friendsViewModel = FriendsViewModel()
        }
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                MapWithCameraButtonView(userLocationViewModel: userLocationViewModel, friendsViewModel: friendsViewModel, viewModel: profileViewModel)
                    .ignoresSafeArea()
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
