//
//  HomeView.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/15/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: AuthService
    @ObservedObject var userLocationViewModel: UserLocationViewModel

        init() {
            self.userLocationViewModel = UserLocationViewModel(locationManager: LocationManager())
        }
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                TabBarView(userLocationViewModel: userLocationViewModel)
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
