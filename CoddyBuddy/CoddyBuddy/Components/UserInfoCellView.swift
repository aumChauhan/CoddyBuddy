//  UserInfoCellView.swift
//  Created by Aum Chauhan on 20/07/23.

import SwiftUI

struct UserInfoCardView: View {
    
    let user: UserProfileModel
    let showProfilePhoto: Bool?
    let isAnonymous: Bool?
    let showNavigator: Bool?
    
    init(_ user: UserProfileModel, showProfilePhoto: Bool? = nil, isAnonymous: Bool? = nil, showNavigator: Bool? = nil) {
        self.user = user
        self.showProfilePhoto = showProfilePhoto
        self.isAnonymous = isAnonymous
        self.showNavigator = showNavigator
    }
    
    var body: some View {
        HStack(alignment: .top) {
            if showProfilePhoto ?? true {
                if isAnonymous ?? false {
                    Image("person")
                        .foregroundColor(.theme.icon)
                        .circularButton(frameSize: 48, bgColor: .gray.opacity(0.55))
                } else {
                    ProfilePhotoView(userDetails: user)
                        .clipShape(Circle())
                        .frame(width: 48, height: 48)
                }
            }
            
            VStack(alignment: .leading, spacing: 0){
                // Name
                HStack(alignment: .center, spacing: 2) {
                    Text(isAnonymous ?? false ? "Anonymous" : user.fullName)
                        .font(.poppins(.medium, 16))
                        .foregroundColor(.theme.primaryTitle)
                    
                    // Verify Badge
                    if user.isVerified ?? false {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.teal)
                            .font(.system(size: 12))
                    }
                }
                // Username
                Text("@\(isAnonymous ?? false ? "anonymous" : user.userName)")
                    .font(.poppins(.regular, 12))
                    .foregroundColor(.theme.secondaryTitle)
            }
            Spacer()
            
            if showNavigator ?? false {
                VStack {
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.footnote)
                        .foregroundColor(.gray.opacity(0.7))
                        .padding(.trailing, 5)
                    Spacer()
                }
            }
           
        }
    }
}

struct UserInfoPlaceHolder: View {
    var body: some View {
        Group {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 170, height: 10)
            
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 120, height: 8)
                .padding(.vertical, 5)
        }
        .foregroundColor(.gray.opacity(0.5))
    }
}
