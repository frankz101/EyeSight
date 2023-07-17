//
//  LoginView.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/16/23.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthService
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                SecureField("Password", text: $password)

                Button {
                    Task {
                        try await viewModel.login(withEmail: email, password: password)
                    }
                } label: {
                    HStack {
                        Text("Sign In")
                            .fontWeight(.semibold)
                    }
                }

                NavigationLink {
                    SignupView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack {
                        Text("Don't have an account?")
                        Text("Sign Up")
                            .fontWeight(.bold)
                    }
                }
            }
            .textFieldStyle(.roundedBorder)
        }

    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

