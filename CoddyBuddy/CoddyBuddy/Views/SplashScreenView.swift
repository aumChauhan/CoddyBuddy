import SwiftUI

struct SplashScreenView: View {
    
    @State var toogleSplashScreen: Bool = false
    @AppStorage("selectedColor") var selectedColor: String = "Theme_Blue"
    @AppStorage("toggleHaptics") var toggleHaptics: Bool = true
    @StateObject var Debugging_Object = DebuggingCoddyBuddy()
    
    var body: some View {
        if toogleSplashScreen {
            if Debugging_Object.CoddyBuddy_In_Development {
                UnderDevelopmentView()
            } else {
                MainTabView()
            }
        }
        else {
            VStack {
                if #available(iOS 16.0, *) {
                    Text("CoddyBuddy")
                        .padding()
                        .font(.system(.largeTitle, design: .rounded))
                        .foregroundColor(Color(selectedColor))
                        .fontWeight(.bold)
                } else {
                    Text("CoddyBuddy")
                        .padding()
                        .font(.system(.largeTitle, design: .rounded))
                        .foregroundColor(Color(selectedColor))
                }
                
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation() { toogleSplashScreen = true }
                }
            }
        }
    }
}

struct UnderDevelopmentView: View {
    @State var toogleAlert: Bool = false
    @State var authentication: Bool = false
    @State private var username: String = ""
    @State private var password: String = ""
    @StateObject var Debugging_Object = DebuggingCoddyBuddy()
    
    var body: some View {
        VStack {
            Spacer()
            LottieAnimationViews(fileName: "96187-gears")
                .frame(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.width/3)
            
            Text("UNDER DEVELOPMENT")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
            
            Text("To make CoddyBuddy perfect, we need some time to fixes bugs.")
                .foregroundColor(.gray)
                .font(.caption)
                .padding(.horizontal, 20)
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
            
            Spacer()
            
            // MARK: Proper Implementation Needed
            /* Button {
                toogleAlert.toggle()
            } label: {
                HStack {
                    Text("Login As Developer")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(8)
                        .padding(.horizontal, 5)
                        .background(.blue)
                        .cornerRadius(200)
                }
            } */
        }
        
        .sheet(isPresented: $authentication) {
            LoginView(DismissButton: $authentication)
        }
        
        .alert("DEVELOPER LOGIN", isPresented: $toogleAlert, actions: {
            TextField("Username", text: $username)
            SecureField("Password", text: $password)
            Button("Submit", action: {
                if Debugging_Object.developerName == username && Debugging_Object.developerPassword == password {
                    authentication = true
                }
            })
            Button("Cancel", role: .cancel, action: {})
        })
    }
}
