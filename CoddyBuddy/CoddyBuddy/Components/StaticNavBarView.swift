//  StaticNavBarView.swift
//  Created by Aum Chauhan on 21/07/23.

import SwiftUI

struct StaticNavBarView<Toolbar: View, Content : View>: View {
    
    let title: String
    let toolbar: Toolbar
    let content: Content
    
    init(_ title: String, @ViewBuilder toolbar: () -> Toolbar ,
         @ViewBuilder content: () -> Content) {
        self.title = title
        self.toolbar = toolbar()
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 28) {
            HStack {
                toolbar
                Spacer()
            }
            HStack {
                Text(title)
                    .font(.poppins(.bold, 28))
                    .foregroundColor(.theme.primaryTitle)
                    .padding(.horizontal, 4)
                
                Spacer()
            }
            
            VStack(spacing: 16) {
                content
            }
            Spacer()
        }
    }
}
