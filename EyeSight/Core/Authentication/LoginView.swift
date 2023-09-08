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
    @State private var showPassword = false
    @EnvironmentObject var viewModel: AuthService
    var body: some View {
        NavigationView {
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
                    
                    Text("Password")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if showPassword {
                        TextField("Password", text: $password)
                            .padding(15)
                            .frame(height: 55)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(UIColor.lightGray), lineWidth: 1)
                                    .padding(.horizontal, -10)
                            )
                            .overlay(
                                HStack {
                                        Spacer()
                                        Button(action: {
                                            withAnimation {
                                                showPassword.toggle()
                                            }
                                        }) {
                                            Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding(.horizontal, 8),
                                    alignment: .trailing
                            )
                            .padding(.horizontal, 10)
                    } else {
                        SecureField("Password", text: $password)
                            .padding(15)
                            .frame(height: 55)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(UIColor.lightGray), lineWidth: 1)
                                    .padding(.horizontal, -10)
                            )
                            .overlay(
                                HStack {
                                        Spacer()
                                        Button(action: {
                                            withAnimation {
                                                showPassword.toggle()
                                            }
                                        }) {
                                            Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding(.horizontal, 8),
                                    alignment: .trailing
                            )
                            .padding(.horizontal, 10)
                    }
                }
                .padding()
                .padding(.bottom, 30)
                

                Button {
                    Task {
                        try await viewModel.login(withEmail: email, password: password)
                    }
                } label: {
                    Text("Log In")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .padding()
                }
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black))
                .padding()

                NavigationLink {
                    SignupView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack {
                        Text("New to EyeSight?")
                            .font(.system(size: 15))
                            .foregroundColor(Color(UIColor.lightGray))
                        Text("Sign Up")
                            .font(.system(size: 15))
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                    }
                }.padding(.bottom, 20)
            }
        }

    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}

