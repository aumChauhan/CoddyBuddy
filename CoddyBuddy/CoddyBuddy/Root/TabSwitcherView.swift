//  TabSwitcherView.swift
//  Created by Aum Chauhan on 18/07/23..

import SwiftUI

struct TabSwitcherView: View {
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @State private var selectedTab: Int = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeTabView(showSideMenu: .constant(false))
                .tag(1)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            ExploreTabView()
                .tag(2)
                .tabItem {
                    Image(systemName: "safari")
                    Text("Home")
                }
            
            ChatRoomTabView()
                .tag(3)
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Home")
                }
            
            UserProfileTabView(user: authenticationViewModel.userDetails, isProfileTab: true)
                .tag(4)
                .tabItem {
                    Image(systemName: "person")
                    Text("Home")
                }
            
            UserProfileTabView(user: authenticationViewModel.userDetails, isProfileTab: true)
                .tag(5)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Home")
                }
        }
    }
}

struct TabSwitcherView_Previews: PreviewProvider {
    static var previews: some View {
        TabSwitcherView()
            .environmentObject(AuthenticationViewModel())
    }
}
