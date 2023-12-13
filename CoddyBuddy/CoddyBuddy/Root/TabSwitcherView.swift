//  TabSwitcherView.swift
//  Created by Aum Chauhan on 18/07/23..

import SwiftUI

struct TabSwitcherView: View {
    
    private let tabs: [(tabName: String, tabNumber: Int)] = [
        ("home", 1),
        ("explore", 2),
        ("person2", 3),
        ("person", 4)
    ]

    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @State private var selectedTab: Int = 1
    @State var showSideMenu: Bool = false

    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack {
            SideMenuView(showSideMenu: $showSideMenu, switchTab: $selectedTab)

            ZStack(alignment: .bottom) {

                TabView(selection: $selectedTab) {
                    HomeTabView(showSideMenu: $showSideMenu)
                        .tag(1)
                    
                    ExploreTabView()
                        .tag(2)
                    
                    ChatRoomTabView()
                        .tag(3)
                    
                     UserProfileTabView(user: authenticationViewModel.userDetails, isProfileTab: true)
                        .tag(4)
                }
                
                TabBarView(selectedTab: $selectedTab, tabs: tabs)
                    .padding(20)
            }
            .cornerRadius(showSideMenu ? 35 : 0)
            .ignoresSafeArea(.keyboard)
            .rotation3DEffect(
                Angle(degrees: showSideMenu ? 35 : 0),
                axis: (x: 0, y: showSideMenu ? -1 : 0, z: 0))
            .offset(x: showSideMenu ? UIScreen.main.bounds.width/1.5 : 0)
            .scaleEffect(showSideMenu ? 0.9 : 1)
            .shadow(color: .black, radius: 40)
            .ignoresSafeArea()

        }
    }
}

struct TabSwitcherView_Previews: PreviewProvider {
    static var previews: some View {
        TabSwitcherView()
            .environmentObject(AuthenticationViewModel())
    }
}
