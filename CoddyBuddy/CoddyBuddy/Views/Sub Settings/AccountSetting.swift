import SwiftUI

struct AccountSetting: View {
    @AppStorage("selectedColor") var selectedColor: String = "Theme_Blue"
    @AppStorage("toggleHaptics") var toggleHaptics: Bool = true
    @State var anonymousProfilePhoto: Bool = true
    @State var anonymousName: Bool = false
    @State var anonymousUserName: Bool = false
    @EnvironmentObject var AuthenticationObject: UserAuthnticateViewModel
    @Environment(\.colorScheme) var colorScheme
    @State var dummyCode = """
function adipiscing(elit) {
  if (!elit.sit) {
    return [];
  }
  const sed = elit[0];
  return eiusmod;
}
"""
    var body: some View {
        List {
            Section("Anonymous Profile Settings") {
                Button {
                    AuthenticationObject.updateStatus(status: AuthenticationObject.currentUserData?.showProfilePic ?? true)
                    AuthenticationObject.currentUserData?.showProfilePic.toggle()
                    if toggleHaptics {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                } label: {
                    HStack {
                        Text("Profile Photo")
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: AuthenticationObject.currentUserData?.showProfilePic ?? true ? "" : "checkmark" )
                            .foregroundColor(Color(selectedColor))
                    }
                }
                
                Button {
                    AuthenticationObject.updateStatusName(status: AuthenticationObject.currentUserData?.anonymousName ?? true)
                    AuthenticationObject.currentUserData?.anonymousName.toggle()
                    if toggleHaptics {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                } label: {
                    HStack {
                        Text("Name")
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: AuthenticationObject.currentUserData?.anonymousName ?? true ? "checkmark" : "" )
                            .foregroundColor(Color(selectedColor))
                    }
                }
                
                Button {
                    AuthenticationObject.updateStatusUserName(status: AuthenticationObject.currentUserData?.anonymousUserName ?? true)
                    AuthenticationObject.currentUserData?.anonymousUserName.toggle()
                    if toggleHaptics {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                } label: {
                    HStack {
                        Text("User Name")
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: AuthenticationObject.currentUserData?.anonymousUserName ?? true ? "checkmark" : "" )
                            .foregroundColor(Color(selectedColor))
                    }
                }
                
            }
            
            Section("Preview") {
                VStack(alignment: .leading) {
                    HStack(alignment: .top, spacing: 12) {
                        if AuthenticationObject.currentUserData?.showProfilePic ?? false {
                            AsyncImage(url: URL(string: AuthenticationObject.currentUserData?.profilePicURL ?? ""), content: { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 45, height:45)
                                    .clipShape(RoundedRectangle(cornerRadius: 11))
                            }, placeholder: {
                                RoundedRectangle(cornerRadius: 11)
                                    .frame(width: 45, height:45)
                                    .foregroundColor(.gray.opacity(0.3))
                                    .overlay {
                                        LottieAnimationViews(fileName: "loadingImage")
                                            .frame(width: 50, height: 50)
                                    }
                            })
                        } else {
                            RoundedRectangle(cornerRadius: 11)
                                .fill((LinearGradient(colors: [Color(AuthenticationObject.currentUserData?.randomColorProfile ?? ""), Color(AuthenticationObject.currentUserData?.randomColorProfile ?? "").opacity(0.7)], startPoint: .top, endPoint: .bottom)))
                                .frame(width: 45, height:45)
                                .cornerRadius(11)
                                .overlay {
                                    Image("anonymousicon2")
                                        .resizable()
                                        .frame(width: 26, height: 26)
                                        .foregroundColor(.white.opacity(0.7))
                                        .scaledToFill()
                                }
                        }
                        
                        VStack(alignment: .leading, spacing: 0) {
                            
                            HStack(alignment: .center, spacing: 3) {
                                Text(AuthenticationObject.currentUserData?.anonymousName ?? false ? "Anonymous": AuthenticationObject.currentUserData?.fullName ?? "")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                
                                Image(systemName: AuthenticationObject.currentUserData?.isVerfied ?? false ? "checkmark.seal.fill" : "")
                                    .foregroundColor(.teal)
                                    .font(.caption)
                                
                                Spacer()
                                HStack {
                                    Image(systemName: "ellipsis")
                                        .padding(4)
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                        .padding(.leading, 10)
                                        .padding(.trailing, 3)
                                }
                            }
                            
                            HStack(alignment: .center,spacing: 5){
                                Text("@\(AuthenticationObject.currentUserData?.anonymousUserName ?? false ? String("anonymous_"+(AuthenticationObject.currentUserData?.id?.prefix(5) ?? "")): AuthenticationObject.currentUserData?.userName ?? "")")
                                    .font(.caption)
                                    .fontWeight(.thin)
                                    .foregroundColor(.primary)
                                
                                Image(systemName: "circle.fill")
                                    .font(.system(size: 3))
                                    .foregroundColor(.gray)
                                    .opacity(0.8)
                                
                                Text(Date().formatted(date: .numeric, time: .omitted))
                                    .font(.caption)
                                    .fontWeight(.thin)
                                    .opacity(0.7)
                            }
                            
                            VStack(alignment: .leading, spacing: 0){
                                Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry.")
                                    .textSelection(.enabled)
                                    .font(.system(size: 13.5))
                                    .padding(.bottom,4)
                                    .padding(.top, 2)
                                
                                if colorScheme == .light {
                                    if #available(iOS 16.1, *) {
                                        Text(dummyCode)
                                            .textSelection(.enabled)
                                            .fontDesign(.monospaced)
                                            .font(.system(size: 12))
                                            .padding(7)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color(uiColor: .secondarySystemBackground))
                                            .cornerRadius(8)
                                    } else {
                                        Text(dummyCode)
                                            .font(.system(size: 12))
                                            .textSelection(.enabled)
                                            .fontWeight(.medium)
                                            .padding(7)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color(uiColor: .secondarySystemBackground))
                                            .cornerRadius(8)
                                    }
                                } else {
                                    if #available(iOS 16.1, *) {
                                        Text(dummyCode)
                                            .textSelection(.enabled)
                                            .fontDesign(.monospaced)
                                            .font(.system(size: 12))
                                            .padding(7)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color(uiColor: .tertiarySystemBackground))
                                            .cornerRadius(8)
                                            .padding(.bottom, 10)
                                    } else {
                                        Text(dummyCode)
                                            .font(.system(size: 12))
                                            .textSelection(.enabled)
                                            .fontWeight(.medium)
                                            .padding(7)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color(uiColor: .tertiarySystemBackground))
                                            .cornerRadius(8)
                                            .padding(.bottom, 10)
                                    }
                                }
                                
                                HStack(spacing: 5){
                                    HStack(spacing: 3) {
                                        Image(systemName: "hand.thumbsup")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 13))
                                        Text("9")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 13))
                                    }
                                    .padding(.leading, 5)
                                    
                                    Spacer()
                                    HStack(spacing: 3) {
                                        Image(systemName: "message")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 13))
                                        Text("0")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 13))
                                    }
                                    
                                    Spacer()
                                    HStack {
                                        Image(systemName: "square.and.arrow.up")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 13))
                                    }
                                    
                                    Spacer()
                                    HStack {
                                        Image(systemName: "doc.on.doc")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 13))
                                        
                                    }
                                    .padding(.trailing, 5)
                                }
                            }
                            .padding(.top, 2)
                        }
                    }
                }
                .padding(15)
                .listRowInsets(EdgeInsets())
                
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Account Preferences")
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct AccountSetting_Previews: PreviewProvider {
    static var previews: some View {
        AccountSetting()
    }
}
