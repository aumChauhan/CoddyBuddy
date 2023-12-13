//  ProfilePhotoView.swift
//  Created by Aum Chauhan on 24/07/23.

import SwiftUI

struct ProfilePhotoView: View {
    
    let name: String
    @StateObject var viewModel : ProfilePhotoViewModel
    
    init(userDetails: UserProfileModel) {
        _viewModel = StateObject(wrappedValue: ProfilePhotoViewModel(url: userDetails.profilePicURL ?? "Nil", key: userDetails.userUID))
        name = userDetails.fullName
    }
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                // Placeholder
                RoundedRectangle(cornerRadius: 100)
                    .overlay {
                        ProgressView()
                            .frame(width: 50, height: 50)
                    }
            } else if let image = viewModel.image {
                // Image
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                // Default Profile Photo
                Circle()
                    .gradientForeground(gradient: Color.theme.gradient)
                    .overlay {
                        Text(name.prefix(1))
                            .foregroundColor(.white)
                            .font(.poppins(.semiBold, 28))
                    }
            }
        }
    }
}


