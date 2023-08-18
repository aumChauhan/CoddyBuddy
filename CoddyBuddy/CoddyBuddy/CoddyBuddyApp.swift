//  CoddyBuddyApp.swift
//  Created by Aum Chauhan on 17/07/23.

import SwiftUI
import FirebaseCore

@main
struct CoddyBuddyApp: App {
    
    @StateObject var authenticationViewModel = AuthenticationViewModel()
    
    init() {
        FirebaseApp.configure()
        debugPrint("DEBUG: Firebase configured successfully")
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RootView()
                    .navigationBarHidden(true)
            }
            .environmentObject(authenticationViewModel)
        }
    }
}

