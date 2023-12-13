//  SideMenuView.swift
//  Created by Aum Chauhan on 13/08/23.

import SwiftUI

struct SideMenuView: View {
    
    private let sideMenuOptions: [(tabNum: Int, image: String, name: String)] = [
        (1,"home", "Home"),
        (2,"explore", "Explore"),
        (3,"person2", "Chat Rooms"),
        (4,"person", "Profile"),
        (5,"setting", "Settings")
    ]
    
    @EnvironmentObject var authVM: AuthenticationViewModel
    
    @Binding var showSideMenu: Bool
    @Binding var switchTab: Int
    
    @State private var showUnderLine: Bool = false
    
    var body: some View {
        ZStack {
            Image("bgGradient")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(alignment: .leading) {
                Button {
                    withAnimation(.spring()) {
                        showSideMenu.toggle()
                    }
                } label: {
                    // User Profile Photo
                    if let user = authVM.userDetails {
                        ProfilePhotoView(userDetails: user)
                            .cornerRadius(100).frame(width: 55, height: 55)
                            .shadow(color: .black.opacity(0.2), radius: 10)
                    } else {
                        Image("person").foregroundColor(.gray)
                            .circularButton(frameSize: 40)
                    }
                }
                
                // Greeting Message
                Text("Welcome Back, \n\(authVM.userDetails?.fullName ?? "...")")
                    .font(.poppins(.bold, 24))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.4), radius: 10)
                    .padding(.top, 15)
                
                // Side Menu Options
                Group {
                    ForEach(sideMenuOptions, id: \.tabNum) { option in
                        Button {
                            withAnimation(.spring()) {
                                switchTab = option.tabNum
                                showSideMenu.toggle()
                            }
                        } label: {
                            options(option.image, option.name)
                        }
                    }
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(.top, 50)
            .padding(20)
        }
    }
    
    // Image + Option Name
    private func options(_ image: String, _ title: String, _ color: Color? = nil) -> some View {
        HStack {
            Image(image)
            Text(title)
        }
        .font(.poppins(.semiBold, 18))
        .foregroundColor(color ?? .white)
        .shadow(color: .black.opacity(0.4), radius: 10)
        .padding(.top, 15)
        .padding(.bottom, 10)
    }
    
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(showSideMenu: .constant(false), switchTab: .constant(1))
            .environmentObject(AuthenticationViewModel())
    }
}
