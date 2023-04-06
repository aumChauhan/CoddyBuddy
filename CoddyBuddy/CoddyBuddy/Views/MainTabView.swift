import SwiftUI
struct MainTabView: View {
    
    @EnvironmentObject var AuthenticationObject: UserAuthnticateViewModel
    @AppStorage("selectedColor") var selectedColor: String = "Theme_Blue"
    @AppStorage("chatBotIcon") var chatBotIcon: String = "bot"
    @AppStorage("toggleHaptics") var toggleHaptics: Bool = true
    @AppStorage("toggleChatBot") var toggleChatBot: Bool = true
    @State var sheetToggle: Bool = false
    
    var body: some View {
        Group {
            if AuthenticationObject.userSession == nil {
                LogIn_SignUpView()
            }
            else if AuthenticationObject.userSession?.isEmailVerified == false {
                unVerifiedView()
            }
            else {
                if let userLoggedIn = AuthenticationObject.currentUserData  {
                    TabView() {
                        HomeView()
                            .tabItem {
                                Image(systemName: "house.fill")
                                Text("Home")
                            }.tag(1)
                        
                        ExploreView()
                            .tabItem {
                                Image(systemName: "safari")
                                Text("Explore")
                            }.tag(2)
                        
                        if toggleChatBot {
                            AskBotView()
                                .tabItem {
                                    Image(chatBotIcon)
                                    Text("ChatBot")
                                }.tag(3)
                        }
                        
                        UserProfileView(userInfo: userLoggedIn)
                            .tabItem {
                                Image(systemName: "person")
                                Text("Profile")
                            }.tag(4)
                        
                        PreferencesView()
                            .tabItem {
                                Image(systemName: "gear")
                                Text("Preferences")
                            }.tag(5)
                    }
                    .tint(Color(selectedColor))
                } else {
                    LoadingScreen()
                }
            }
        }
        .onAppear{
            if toggleHaptics {
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            }
        }
        
    }
    
}

struct unVerifiedView: View {
    @EnvironmentObject var AuthenticationObject: UserAuthnticateViewModel
    @AppStorage("selectedColor") var selectedColor: String = "Theme_Blue"
    @AppStorage("toggleChatBot") var toggleChatBot: Bool = true
    @AppStorage("toggleHaptics") var toggleHaptics: Bool = true
    @State var sheetToggle: Bool = false
    var body : some View {
        VStack {
            ScrollView {
                VStack {
                    HStack {
                        withAnimation {
                            LottieAnimationViews(fileName: "95247-email")
                                .frame(width: 165, height: 165)
                        }
                    }
                    VStack {
                        Text("Verify Your Email")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Check your email \(AuthenticationObject.currentUserData?.email ?? "") click the link to activate your account.")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 1)
                            .padding(.bottom, 7)
                        
                        Button {
                            sheetToggle.toggle()
                            if toggleHaptics {
                                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                            }
                        } label: {
                            Text("LOGIN")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .padding(8)
                                .padding(.horizontal, 7)
                                .background(.blue)
                                .cornerRadius(200)
                        }
                    }
                    .padding(.top, -15)
                }
            }
            Spacer()
            
            Button {
                withAnimation {
                    AuthenticationObject.logOut()
                    selectedColor = "Theme_Blue"
                    if toggleHaptics {
                        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                    }
                }
            } label: {
                Text("Back To Home Page")
            }
        }
        .padding(15)
        
        .sheet(isPresented: $sheetToggle) {
            LoginView(AuthenticationObject: _AuthenticationObject, DismissButton: $sheetToggle)
        }
    }
}

struct LoadingScreen: View {
    @State var actionSheetToogle: Bool = false
    @AppStorage("selectedColor") var selectedColor: String = "Theme_Blue"
    @EnvironmentObject var AuthenticationObject: UserAuthnticateViewModel
    @AppStorage("toggleHaptics") var toggleHaptics: Bool = true
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(0..<4) {index in
                    VStack(alignment: .leading) {
                        HStack(alignment: .top, spacing: 10) {
                            RoundedRectangle(cornerRadius: 11)
                                .frame(width: 45, height:45)
                                .foregroundColor(.gray.opacity(0.3))
                            
                            VStack(alignment: .leading, spacing: 0) {
                                
                                HStack(spacing: 4) {
                                    RoundedRectangle(cornerRadius: 11)
                                        .frame(width: UIScreen.main.bounds.width/3, height:12)
                                        .foregroundColor(.gray.opacity(0.3))
                                        .padding(.bottom, 5)
                                }
                                
                                HStack(alignment: .center,spacing: 5){
                                    RoundedRectangle(cornerRadius: 11)
                                        .frame(width: UIScreen.main.bounds.width/6, height:12)
                                        .foregroundColor(.gray.opacity(0.3))
                                        .padding(.bottom, 5)
                                    
                                    RoundedRectangle(cornerRadius: 11)
                                        .frame(width: UIScreen.main.bounds.width/8, height:12)
                                        .foregroundColor(.gray.opacity(0.3))
                                        .padding(.bottom, 5)
                                }
                                
                                VStack(alignment: .leading, spacing: 0){
                                    RoundedRectangle(cornerRadius: 11)
                                        .frame(width: UIScreen.main.bounds.width/1.45, height:100)
                                        .foregroundColor(.gray.opacity(0.3))
                                        .padding(.bottom, 5)
                                }
                                .padding(.top, 5)
                            }
                            
                        }
                    }
                    .padding(10)
                    .frame(width: UIScreen.main.bounds.width/1.1, height:200)
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(13)
                }
            }
            
            .navigationTitle("Home")
            .navigationBarItems(
                trailing: Button(action: {
                    actionSheetToogle.toggle()
                    if toggleHaptics {
                        UINotificationFeedbackGenerator().notificationOccurred(.warning)
                    }
                }, label: {
                    Text("TroubleShoot")
                        .foregroundColor(Color(selectedColor))
                })
            )
        }
        .confirmationDialog("Troubleshoot", isPresented: $actionSheetToogle, actions: {
            Button("Log Out", role: .destructive) {
                withAnimation {
                    AuthenticationObject.logOut()
                    selectedColor = "Theme_Blue"
                    if toggleHaptics {
                        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                    }
                }
            }
        }, message: {
            Text("Having trouble while connecting?\n Checkout your Internet Connection")
        })
        
    }
}


struct LoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoadingScreen ()
    }
}
