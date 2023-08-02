//
//  LoginFirebaseApp.swift
//  LoginFirebase
//
//  Created by Luciano Nicolini on 27/07/2023.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct LoginFirebaseApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authenticationViewModel = AuthenticationViewModel()
    
    @ViewBuilder
    var contentView: some View {
            LoginView()
            .environmentObject(authenticationViewModel)

    }
    
    var body: some Scene {
        WindowGroup {
            contentView
                .environmentObject(authenticationViewModel)
        }
    }
}

