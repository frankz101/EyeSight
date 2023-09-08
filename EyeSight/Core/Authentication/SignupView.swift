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
            Spacer()
            Image(systemName: "eye")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80)
            Spacer()
            
            Text("Welcome to EyeSight")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            
            VStack {
                Text("Email Address")
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .padding(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(UIColor.lightGray), lineWidth: 1)
                            .padding(.horizontal, -10)
                    )
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.horizontal, 10)
                Text("Full Name")
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("Full Name", text: $fullName)
                    .autocapitalization(.none)
                    .padding(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(UIColor.lightGray), lineWidth: 1)
                            .padding(.horizontal, -10)
                    )
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.horizontal, 10)
                Text("Password")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                SecureField("Password", text: $password)
                    .padding(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(UIColor.lightGray), lineWidth: 1)
                            .padding(.horizontal, -10)
                    )
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.horizontal, 10)
                Text("Confirm Password")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .padding(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(UIColor.lightGray), lineWidth: 1)
                            .padding(.horizontal, -10)
                    )
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.horizontal, 10)
            }
            .padding()
            .padding(.bottom, 15)

            Button {
                Task {
                    try await viewModel.createUser(email: email, password:password, fullName:fullName)
                }
            } label: {
                HStack {
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .padding()
                }
            }
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black))
            .padding()

            Button {
                dismiss()
            } label: {
                HStack {
                    Text("Already have an account?")
                        .font(.system(size: 15))
                        .foregroundColor(Color(UIColor.lightGray))
                    Text("Sign In")
                        .font(.system(size: 15))
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                }
            }.padding(.bottom, 20)
        }
        .textFieldStyle(.roundedBorder)
    }
}

//struct SignupView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignupView()
//    }
//}
