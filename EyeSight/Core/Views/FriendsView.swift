//
//  FriendsView.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/16/23.
//

import SwiftUI

struct FriendsView: View {
    @EnvironmentObject var viewModel: AuthService
      var body: some View {
          UserListView()
//        Button {
//              viewModel.signout()
//          } label: {
//              Text("Sign Out")
//          }
      }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
