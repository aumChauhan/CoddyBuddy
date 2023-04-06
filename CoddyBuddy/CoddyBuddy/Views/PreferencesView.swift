import SwiftUI

enum themeCases: Int, Identifiable, CaseIterable {
    var id: Self { self }
    case system
    case light
    case dark
    
    var title: String {
        switch self {
        case .system :
            return "System Default"
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }
}

struct PreferencesView: View {
    
    @State var toggleKeyForUserInfoSheet: Bool = false
    @State var actionKeyToogle: Bool = false
    @State var sheetToogle: Bool = false
    @EnvironmentObject var AuthenticationObject: UserAuthnticateViewModel
    @State var showProfilePhoto: Bool = false
    
    @AppStorage("selectedColor") var selectedColor: String = "Theme_Blue"
    @AppStorage("systemThemMode") var systemThemMode: Int = (themeCases.allCases.first?.rawValue ?? 1)
    @AppStorage("toggleChatBot") var toggleChatBot: Bool = true
    @AppStorage("toggleHaptics") var toggleHaptics: Bool = true
    @AppStorage("chatBotIcon") var chatBotIcon: String = "bot"
    @Environment(\.colorScheme) var systemColorScheme

    var selectedTheme: ColorScheme? {
        guard let theme = themeCases(rawValue: systemThemMode) else { return nil }
        switch theme {
        case .light:
            return .light
        case .dark:
            return .dark
        default:
            return nil
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .center) {
                if let userLoggedIn = AuthenticationObject.currentUserData {
                    List {
                        Section {
                            HStack(alignment: .top, spacing:12) {
                                OnlyProfilePhotoView(url: userLoggedIn.profilePicURL, key:  userLoggedIn.id ?? "")
                                    .onTapGesture {
                                        withAnimation(Animation.spring()) {
                                            showProfilePhoto.toggle()
                                        }
                                    }
                                
                                VStack(alignment: .leading, spacing: 1){
                                    HStack(alignment: .center,spacing:3) {
                                        Text("\(userLoggedIn.fullName)")
                                            .font(.body)
                                            .fontWeight(.semibold)
                                        
                                        Image(systemName: userLoggedIn.isVerfied ? "checkmark.seal.fill" : "")
                                            .foregroundColor(.teal)
                                            .font(.caption)
                                    }
                                    Text("@\(userLoggedIn.userName)")
                                        .font(.caption)
                                        .fontWeight(.light)
                                }
                            }
                            .padding(10)
                        }
                        .listRowInsets(EdgeInsets())
                        
                        
                        Section {
                            NavigationLink {
                                Appearance_Setting()
                            } label: {
                                SettingName_SingleRow(iconName: "circle.lefthalf.filled", SettingName: "Appearance", bgColor: .indigo) }
                            
                            NavigationLink {
                                AccountSetting()
                            } label: {
                                SettingName_SingleRow(iconName: "theatermasks.fill", SettingName: "Anonymous Preferences", bgColor: .blue) }
                        }
                        
                        Section {
                            NavigationLink {
                                UserDetailsView_STACK()
                            } label: {
                                SettingName_SingleRow(iconName: "person.crop.square.filled.and.at.rectangle.fill", SettingName: "User Credentials", bgColor: .brown) }
                            
                            Button {
                                sheetToogle.toggle()
                            } label: {
                                HStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.pink)
                                        .overlay {
                                            Image(systemName:"key.fill")
                                                .font(.callout)
                                                .foregroundColor(.white)
                                                .foregroundColor(.blue)
                                        }
                                    
                                    Text("Reset Password")
                                        .font(.body)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray.opacity(0.7))
                                        .font(.subheadline)
                                }
                            }
                            
                        }
                        .padding(.horizontal,9)
                        .padding(.vertical,7)
                        .padding(.trailing, 5)
                        .listRowInsets(EdgeInsets())
                        
                        Section {
                            NavigationLink {
                                TermsOfService()
                            } label: {
                                SettingName_SingleRow(iconName: "newspaper.fill", SettingName: "Terms of Service", bgColor: .purple) }
                            
                            NavigationLink {
                                PrivacyPolicySetting()
                            } label: {
                                SettingName_SingleRow(iconName: "hand.raised.fill", SettingName: "Privacy Policy", bgColor: .green) }
                            
                            NavigationLink {
                                ReleaseNote()
                            } label: {
                                SettingName_SingleRow(iconName: "list.bullet.rectangle.portrait.fill", SettingName: "Release Note", bgColor: .orange) }
                            
                            NavigationLink {
                                ShareFeedBack()
                            } label: {
                                SettingName_SingleRow(iconName: "square.and.arrow.up", SettingName: "Share Feedback", bgColor: .gray) }
                        }
                        .padding(.horizontal,9)
                        .padding(.vertical,7)
                        .padding(.trailing, 5)
                        .listRowInsets(EdgeInsets())
                        
                        Section {
                            Button {
                                withAnimation {
                                    actionKeyToogle.toggle()
                                    if toggleHaptics {
                                        UINotificationFeedbackGenerator().notificationOccurred(.warning)
                                    }
                                }
                            } label: {
                                SettingName_SingleRow(iconName: "rectangle.portrait.and.arrow.right.fill", SettingName: "Log Out", bgColor: .red)
                                    .foregroundColor(.primary)
                            }
                            
                        }
                        .padding(.horizontal,9)
                        .padding(.vertical,7)
                        .padding(.trailing, 5)
                        .listRowInsets(EdgeInsets())
                    }
                    .listStyle(.insetGrouped)
                    
                    .navigationTitle("Preferences")
                    
                    .navigationBarItems(
                        trailing:
                            Button(action: {
                                toggleKeyForUserInfoSheet.toggle()
                            },label: {
                                Image(systemName: "info.circle")
                                    .font(.subheadline)
                                    .fontWeight(.regular)
                                    .foregroundColor(Color(selectedColor))
                            })
                    )
                }
                
                if showProfilePhoto {
                    VStack {
                        AsyncImage(url: URL(string: AuthenticationObject.currentUserData?.profilePicURL ?? ""), content: { image in
                            withAnimation {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: UIScreen.main.bounds.width/1.5, height:UIScreen.main.bounds.width/1.5)
                                    .clipShape(RoundedRectangle(cornerRadius: UIScreen.main.bounds.width/1.5))
                            }
                        }, placeholder: {
                            withAnimation {
                                RoundedRectangle(cornerRadius:UIScreen.main.bounds.width/1.5 )
                                    .frame(width: UIScreen.main.bounds.width/1.5, height:UIScreen.main.bounds.width/1.5)
                                    .foregroundColor(.gray.opacity(0.3))
                                    .overlay {
                                        LottieAnimationViews(fileName: "loadingImage")
                                            .frame(width: UIScreen.main.bounds.width/1.5, height: UIScreen.main.bounds.width/1.5)
                                    }
                            }
                        })
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.ultraThinMaterial)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showProfilePhoto.toggle()
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
        .preferredColorScheme(selectedTheme)
        
        .sheet(isPresented: $toggleKeyForUserInfoSheet) {
            UserDetailsView_Sub()
        }
        .sheet(isPresented: $sheetToogle, content: {
            ForgotPassword()
        })
        .actionSheet(isPresented: $actionKeyToogle) {
            let btn1: ActionSheet.Button = .destructive(Text("Log Out")) {
                withAnimation {
                    AuthenticationObject.logOut()
                    selectedColor = "Theme_Blue"
                    if toggleHaptics {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }
                }
            }
            let btn2: ActionSheet.Button = .cancel(Text("Cancel"))
            return ActionSheet(title: Text(""), message: Text("Log Out from this device?"), buttons: [btn1, btn2])
        }
    }
}

struct SettingName_SingleRow: View {
    var iconName: String
    var SettingName: String
    var bgColor: Color
    var body: some View{
        HStack{
            RoundedRectangle(cornerRadius: 8)
                .frame(width: 30, height: 30)
                .foregroundColor(bgColor)
                .overlay {
                    Image(systemName: iconName)
                        .font(.callout)
                        .foregroundColor(.white)
                        .foregroundColor(.blue)
                }
            
            Text("\(SettingName)")
                .font(.body)
                .foregroundColor(.primary)
        }
    }
}

struct SettingVIew_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
            .environmentObject(UserAuthnticateViewModel())
    }
}
