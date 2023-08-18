//  CreateNewCommunityView.swift
//  Created by Aum Chauhan on 24/07/23.

import SwiftUI
import PhotosUI
import AlertToast

struct CreateNewChatRoomView: View {
    
    private let sortingOptions = [
        ("Name", 1),
        ("Description", 2)
    ]
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @StateObject private var photoPickerNativeViewModel = PhotoPickerViewModel()
    @StateObject private var viewModel = ChatRoomViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedFilter: Int = 1
    
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                HeaderWithDismissButton(title: "Create Chat Room")
                
                SegmentedControlView(tabs: sortingOptions, selectedTab: $selectedFilter, height: 50)
                
                if selectedFilter == 1 {
                    chatRoomName
                } else {
                    description
                }
                                
                Spacer()
                
                createButton
            }
        }
        .padding(20)
        .background(Color.theme.background.ignoresSafeArea())
        // Dismiss Sheet On Publishing Post
        .onReceive(viewModel.$chatRoomCreated.dropFirst()) { isCreated in
            dismiss()
        }
        
        // MARK: Alert
        .toast(isPresenting: $viewModel.errorOccured) {
            AlertToast(
                displayMode: .banner(.slide),
                type: .systemImage("exclamationmark.triangle.fill", .white),
                title: "Exception Occured!", subTitle: viewModel.errorDescription,
                style: .style(backgroundColor: .red, titleColor: .white, subTitleColor: .white))
        }
    }
}

extension CreateNewChatRoomView {
    
    // MARK: ChatRoom Name
    private var chatRoomName: some View {
        VStack(spacing: 20) {
            TextFieldView(imageName: "person2" ,placeHolder: "Chat Room Name", text: $viewModel.chatRoomName, showPassword: .constant(true))
            
            Text(viewModel.chatRoomNote)
                .font(.poppins(.regular, 13))
                .foregroundColor(.gray)
        }
    }
    
    // MARK: Description
    private var description: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("note")
                    .scaleEffect(0.8)
                    .foregroundColor(.theme.icon)
                
                Text("Description")
                
                Spacer()
                Text("\(viewModel.chatRoomDescription.count)/100")
            }
            .font(.poppins(.regular, 16))
            .foregroundColor(.gray.opacity(0.8))
            
            CustomDivider()
            TextEditor(text: $viewModel.chatRoomDescription)
        }
        .padding(8)
        .textEditorStyle()
    }
    
    // MARK: Photo Picker
    private var photoPicker: some View {
        PhotosPicker(selection: $photoPickerNativeViewModel.imageSelection, matching: .images) {
            
            if photoPickerNativeViewModel.imageSelection != nil {
                if let image = photoPickerNativeViewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .cornerRadius(200)
                }
            } else {
                placeholder
                    .tint(.primary)
            }
        }
    }
    
    // MARK: Create ChatRoom Button
    private var createButton: some View {
        Button {
            // MARK: Create Action
            Task {
                await viewModel.createChatRoom(image: photoPickerNativeViewModel.selectedImage)
            }
        } label: {
            Text("Create")
                .font(.poppins(.semiBold, 16))
                .foregroundColor(.white)
                .gradientFillToInfinity(height: 50)
        }
    }
    // MARK: PhotoPicker Placeholder
    private var placeholder: some View {
        Circle()
            .frame(width: 100)
            .foregroundColor(.theme.secondaryBackground)
            .overlay {
                Image("addImg")
                    .foregroundColor(.theme.icon)
            }
    }
}

struct CreateNewCommunityView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Background")
            .sheet(isPresented: .constant(true)) {
                CreateNewChatRoomView()
                    .environmentObject(AuthenticationViewModel())
                    .interactiveDismissDisabled()
                    .preferredColorScheme(.dark)
            }
    }
}
