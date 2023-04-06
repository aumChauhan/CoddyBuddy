import SwiftUI

struct AddProfilePhotoView: View {
    
    @EnvironmentObject var AuthenticationObject: UserAuthnticateViewModel
    @State var toggleForAddPhotoSheet: Bool = false
    @State var selectedImage: UIImage?
    @State var profileImage: Image?
    @State var toogleProgressView: Bool = false
    @AppStorage("selectedColor") var selectedColor: String = "Theme_Blue"
    @AppStorage("toggleHaptics") var toggleHaptics: Bool = true
    
    var body: some View {
        ZStack(alignment: .center) {
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Setup Account ")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .shadow(radius: 20)
                        
                        Text("Add Profile Photo")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                            .shadow(radius: 20)
                    }.foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal, 25)
                .padding(.vertical, 15)
                .padding(.bottom, 20)
                
                VStack {
                    VStack(spacing: 20) {
                        Button {
                            withAnimation {
                                toggleForAddPhotoSheet.toggle()
                                if toggleHaptics {
                                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                }
                            }
                        } label: {
                            if let profileImage = profileImage {
                                profileImage
                                    .resizable()
                                    .scaledToFill()
                                    .cornerRadius(20)
                                    .frame(width: UIScreen.main.bounds.width/1.8, height: UIScreen.main.bounds.width/1.8)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .tint(.blue)
                            } else {
                                Text("Add Photo")
                                    .foregroundColor(.gray.opacity(0.4))
                                    .frame(width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.width/4)
                                    .padding(40)
                                    .background(Color.init(uiColor: .secondarySystemBackground))
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .tint(.blue)
                            }
                        }
                    }
                    .padding(20)
                    .padding(.horizontal,20)
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    if !imageValid() {
                        Button {
                            withAnimation {
                                if let selectedImage = selectedImage {
                                    AuthenticationObject.uploadProfileImage(selectedImage)
                                    toogleProgressView.toggle()
                                    if toggleHaptics {
                                        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                    }
                                }
                            }
                        } label: {
                            Text("UPLOAD")
                                .foregroundColor(.white)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(12)
                                .frame(width: UIScreen.main.bounds.width/1.13)
                                .background(.blue.opacity(0.8))
                                .cornerRadius(15)
                        }
                        .padding(.top, 20)
                    }
                    Spacer()
                }
                .padding(.top, 30)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.init(uiColor: .systemBackground))
                .cornerRadius(11)
                .edgesIgnoringSafeArea(.bottom)
            }
            
            if toogleProgressView {
                withAnimation {
                    customProgressBar()
                }
            }
        }
        .background(.blue.opacity(0.8))
        .navigationBarTitleDisplayMode(.inline)
        .accentColor(.white)        
        .sheet(isPresented: $toggleForAddPhotoSheet, onDismiss: loadSelectedImage) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $selectedImage)
        }
    }
    
    func loadSelectedImage() {
        guard let selectedImage = selectedImage else { return }
        profileImage = Image(uiImage: selectedImage)
    }
    
    func imageValid() -> Bool {
        if selectedImage != nil {
            return false
        }
        return true
    }
}

