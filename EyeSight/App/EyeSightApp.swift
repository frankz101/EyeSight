//
//  EyeSightApp.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/15/23.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct EyeSightApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var viewModel = AuthService()
    var body: some Scene {
        WindowGroup {
                    HomeView()
                        .environmentObject(viewModel)
                }
    }
}
