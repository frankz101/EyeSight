//
//  SignupView.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/16/23.
//

import SwiftUI

struct SignupView: View {
    @State private var email = ""
    @State private var fullName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthService
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .autocapitalization(.none)
            TextField("Full Name", text: $fullName)
                .autocapitalization(.none)
            SecureField("Password", text: $password)
            SecureField("Confirm Password", text: $confirmPassword)

            Button {
                Task {
                    try await viewModel.createUser(email: email, password:password, fullName:fullName)
                }
            } label: {
                HStack {
                    Text("Sign Up")
                        .fontWeight(.semibold)
                }
            }

            Button {
                dismiss()
            } label: {
                HStack {
                    Text("Already have an account?")
                    Text("Sign In")
                        .fontWeight(.bold)
                }
            }
        }
        .textFieldStyle(.roundedBorder)
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
