//  RootView.swift
//  Created by Aum Chauhan on 17/07/23.

import SwiftUI

struct RootView: View {
    
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = true
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
        ZStack {
            if authenticationViewModel.userSession != nil {
                TabSwitcherView()
            } else if !isOnboardingViewActive {
                AuthMethodsView()
            } else {
                WelcomeView()
            }
        }
        .background(Color.theme.background.ignoresSafeArea())
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
