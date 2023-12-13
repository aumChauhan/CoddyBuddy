//  TabBarView.swift
//  Created by Aum Chauhan on 18/07/23.

import SwiftUI

struct TabBarView: View {
    
    @Namespace private var namepsace
    
    @Binding var selectedTab: Int
    @State private var showCreatePostSheet: Bool = false
    
    let tabs: [(tabName: String, tabNumber: Int)]
    let showCreatePostButton: Bool?
    
    init(selectedTab: Binding<Int>, tabs: [(tabName: String, tabNumber: Int)], showCreatePostButton: Bool? = nil) {
        self._selectedTab = selectedTab
        self.tabs = tabs
        self.showCreatePostButton = showCreatePostButton
    }
    
    var body: some View {
        HStack {
            HStack {
                ForEach(tabs, id: \.tabNumber) { tab in
                    VStack(spacing: 2) {
                        Image("\(tab.tabName)")
                            .foregroundColor(.theme.inverseBackground.opacity(0.85))
                            .gradientForeground(gradient: tab.tabNumber == selectedTab ? Color.theme.gradient : Color.theme.nilGradient)
                            .padding(.horizontal, 15)
                            .offset(y: tab.tabNumber == selectedTab ? -4 : 0)
                            .frame(maxWidth: .infinity)
                        
                        if tab.tabNumber == selectedTab {
                            Circle()
                                .fill(Color.theme.gradient)
                                .matchedGeometryEffect(id: "tab", in: namepsace)
                                .frame(width: 5, height: 5)
                        }
                    }
                    .onTapGesture {
                        withAnimation(.spring()) { selectedTab = tab.tabNumber }
                    }
                }
            }
            .bgFillToInfinity(height: 60, bgColor: .theme.tabBackground)
            .padding(.horizontal, 2)
            .bgFillToInfinity(height: 63, bgColor: .theme.secondaryBackground)
            
            if showCreatePostButton ?? true {
                Button {
                    showCreatePostSheet.toggle()
                } label: {
                    Image("edit-2")
                        .foregroundColor(.white).contrast(2.0)
                        .circularGradientButton(frameSize: 60)
                }
            }
        }
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 0)
        .background(
            LinearGradient(
                stops: [
                    Gradient.Stop(color: .theme.background.opacity(0), location: 0.00),
                    Gradient.Stop(color: .theme.background, location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 1)
            )
        )
        
        .sheet(isPresented: $showCreatePostSheet) {
            CreatePostView(postType: .newPost)
                .interactiveDismissDisabled(true)
        }
    }
}

struct CustomTabBar_Preview: PreviewProvider {
    static var previews: some View {
        TabBarView(
            selectedTab: .constant(1),
            tabs: [ ("home", 1),
                    ("explore", 2),
                    ("person2", 3),
                    ("person", 4)
                  ]
        )
    }
}
