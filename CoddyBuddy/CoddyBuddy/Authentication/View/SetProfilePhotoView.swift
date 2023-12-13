//  SetProfilePhotoView.swift
//  Created by Aum Chauhan on 22/07/23.

import SwiftUI
import PhotosUI
import AlertToast

struct SetProfilePhotoView: View {
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @StateObject private var viewModel = PhotoPickerViewModel()
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.theme.background.ignoresSafeArea()
            
            StaticNavBarView("One More Step Left\nSet Profile Photo") {
                // NONE
            } content: {
                photoPicker
                
                Spacer()
                
                uploadActionButton
                
                skipButton
            }
            .padding(20)
            
            if authenticationViewModel.showProgressView {
                FullScreenCoverProgressView("Uploading Image")
                    .onAppearDismissKeyboard()
            }
        }
        
        // MARK: Alert
        .toast(isPresenting: $authenticationViewModel.errorOccured) {
            AlertToast(
                displayMode: .banner(.slide),
                type: .systemImage("exclamationmark.triangle.fill", .white),
                title: "Exception Occured!",
                subTitle: authenticationViewModel.errorDescription,
                style: .style(backgroundColor: .red, titleColor: .white, subTitleColor: .white)
            )
        }
    }
}

extension SetProfilePhotoView {
    
    // MARK: Skip Button
    private var skipButton: some View {
        Button {
            // MARK: Set User Session Action
            authenticationViewModel.setUserSessionAfterProfileSetup()
            HapticManager.soft()
        } label: {
            Text("Skip For Now")
                .font(.poppins(.medium, 16))
                .foregroundColor(.theme.primaryTitle)
                .bgFillToInfinity(height: 50, bgColor: .theme.secondaryBackground)
        }
        .tint(.primary)
    }
    
    // MARK: Photo Picker
    private var photoPicker: some View {
        PhotosPicker(selection: $viewModel.imageSelection, matching: .images) {
            
            if viewModel.imageSelection != nil {
                if let image = viewModel.selectedImage {
                    // MARK: Selected Image
                    VStack {
                        HStack(spacing: 15) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(
                                    width: UIScreen.main.bounds.width / 2.5,
                                    height:  UIScreen.main.bounds.width / 2.5)
                                .cornerRadius(200)
                            
                            Spacer()
                        }
                    }
                }
            } else {
                placeholder
                    .tint(.primary)
            }
        }
    }
    
    // MARK: Placeholder
    private var placeholder: some View {
        HStack {
            ZStack {
                Circle()
                    .frame(width: UIScreen.main.bounds.width / 2.5)
                    .foregroundColor(.theme.secondaryBackground)
                
                Image("addImg")
                    .foregroundColor(.theme.icon)
            }
            Spacer()
        }
    }
    
    // MARK: Upload Button
    private var uploadActionButton: some View {
        Button {
            // MARK: Uploading Image Action
            Task {
                if let selectedImage = viewModel.selectedImage {
                    await authenticationViewModel.uploadImage(image: selectedImage)
                }
            }
        } label: {
            Text("Set Profile Photo")
                .font(.poppins(.medium, 16))
                .foregroundColor(.theme.inverseTitle)
                .bgFillToInfinity(height: 50, bgColor: .theme.inverseBackground)
                .padding(.top, 10)
        }
    }
    
}

struct SetProfilePhotoView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Background")
            .sheet(isPresented: .constant(true)) {
                SetProfilePhotoView()
                    .environmentObject(AuthenticationViewModel())
            }
    }
}
