import SwiftUI

struct LogIn_SignUpView: View {
    
    @State var sheetToggleForLogin: Bool = false
    @State var sheetToggleForSignup: Bool = false
    @AppStorage("selectedColor") var selectedColor: String = "Theme_Blue"
    @AppStorage("toggleHaptics") var toggleHaptics: Bool = true
    @StateObject var Debugging_Object = DebuggingCoddyBuddy()
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if Debugging_Object.CoddyBuddy_In_Development {
            UnderDevelopmentView()
        }
        NavigationView {
            ZStack {
                Image("BG_Welcome")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(alignment:.center) {
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    Button {
                        withAnimation {
                            sheetToggleForLogin.toggle()
                            if toggleHaptics {
                                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                            }
                        }
                    } label: {
                        Text("LOG IN")
                            .foregroundColor(.white)
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(10)
                            .frame(width: UIScreen.main.bounds.width/1.2)
                            .background(Color("ButtonColor"))
                            .cornerRadius(18)
                    }.padding(.bottom, 6).padding(.top, 20)
                    
                    Button {
                        withAnimation {
                            sheetToggleForSignup.toggle()
                            if toggleHaptics {
                                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                            }
                        }
                    } label: {
                        Text("SIGN UP")
                            .foregroundColor(.white)
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(10)
                            .frame(width: UIScreen.main.bounds.width/1.2)
                            .background(Color("ButtonColor"))
                            .cornerRadius(18)
                    }.padding(.top, 6)
                    
                    Spacer()
                }
            }
        }
        .navigationViewStyle(.stack)
        .accentColor(.white)
        
        .sheet(isPresented: $sheetToggleForLogin) {
            LoginView(DismissButton: $sheetToggleForLogin)
                .interactiveDismissDisabled(true)
        }
        .interactiveDismissDisabled(true)
        
        .sheet(isPresented: $sheetToggleForSignup) {
            SignUpView(DismissButton: $sheetToggleForSignup)
                .interactiveDismissDisabled(true)
        }
        .interactiveDismissDisabled(true)
    }
}

struct SignUpView: View {
    
    enum casesForAlert_SignUP {
        case fullName
        case email
        case password
        case signupError
    }
    
    @State var signUpAlertInfo_toggle: Bool = false
    @State var popAlert: casesForAlert_SignUP? = nil
    @State private var email = ""
    @State private var fullName = ""
    @State private var password = ""
    @EnvironmentObject var AuthenticationObject: UserAuthnticateViewModel
    @State var toggleShow_Hide_Password: Bool = true
    @State var toogleProgressView: Bool = false
    @Binding var DismissButton: Bool
    @AppStorage("selectedColor") var selectedColor: String = "Theme_Blue"
    @AppStorage("toggleHaptics") var toggleHaptics: Bool = true
    
    @FocusState var passwordTF: Bool
    @FocusState var emailTextField: Bool
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .center) {
                VStack {
                    NavigationLink(destination: AddProfilePhotoView(), isActive: $AuthenticationObject.registeredUserProfileView) {
                        Text("")
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Get Started,")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .shadow(radius: 20)
                            
                            Text("Register Now")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                                .shadow(radius: 20)
                            
                        }.foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.horizontal, 25)
                    
                    VStack {
                        ScrollView {
                            VStack(spacing: 15) {
                                HStack(spacing: 0){
                                    Image(systemName: "person")
                                        .foregroundColor(Color.gray.opacity(0.7))
                                    
                                    TextField("Name", text: $fullName)
                                        .foregroundColor(.primary)
                                        .padding(.horizontal ,10)
                                        .keyboardType(.default)
                                        .background(Color.init(uiColor: .secondarySystemBackground))
                                        .cornerRadius(10)
                                        .tint(Color(selectedColor))
                                        .submitLabel(.next)
                                        .onSubmit {
                                            emailTextField.toggle()
                                        }
                                }
                                
                                Divider()
                                HStack(spacing: 0) {
                                    Image(systemName: "envelope")
                                        .foregroundColor(Color.gray.opacity(0.7))
                                    TextField("E-mail", text: $email)
                                        .foregroundColor(.primary)
                                        .focused($emailTextField)
                                        .keyboardType(.emailAddress)
                                        .padding(.horizontal ,10)
                                        .background(Color.init(uiColor: .secondarySystemBackground))
                                        .cornerRadius(10)
                                        .textContentType(.emailAddress)
                                        .tint(Color(selectedColor))
                                        .submitLabel(.next)
                                        .onSubmit {
                                            passwordTF.toggle()
                                        }
                                    
                                }
                                
                                Divider()
                                HStack(alignment: .center, spacing: 0){
                                    Image(systemName: "key")
                                        .foregroundColor(Color.gray.opacity(0.7))
                                    
                                    if toggleShow_Hide_Password {
                                        SecureField("Password", text: $password)
                                            .focused($passwordTF)
                                            .padding(.horizontal ,10)
                                            .background(Color.init(uiColor: .secondarySystemBackground))
                                            .cornerRadius(10)
                                            .tint(Color(selectedColor))
                                    } else {
                                        TextField("Password", text: $password)
                                            .padding(.horizontal ,10)
                                            .focused($passwordTF)
                                            .background(Color.init(uiColor: .secondarySystemBackground))
                                            .cornerRadius(10)
                                            .tint(Color(selectedColor))
                                            .submitLabel(.next)
                                    }
                                    
                                    Button {
                                        withAnimation {
                                            toggleShow_Hide_Password.toggle()
                                            if toggleHaptics {
                                                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                            }
                                        }
                                    } label: {
                                        Image(systemName: toggleShow_Hide_Password ? "eye.slash.fill": "eye.fill")
                                            .foregroundColor(Color.gray.opacity(0.7))
                                    }
                                }
                            }
                            .padding(16)
                            .background(Color.init(uiColor: .secondarySystemBackground))
                            .cornerRadius(18)
                            .padding(.horizontal,20)
                            
                            HStack(alignment: .center) {
                                Spacer()
                                Button {
                                    withAnimation {
                                        AuthenticationObject.SignUpUser(fullName: fullName.capitalized.trimmingCharacters(in: .whitespacesAndNewlines), userName: extractUsername(from: email)?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) ?? "", email: email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines), password: password.trimmingCharacters(in: .whitespacesAndNewlines))
                                        toogleProgressView.toggle()
                                        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    }
                                } label: {
                                    Text("SIGN UP")
                                        .foregroundColor(.white)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .padding(12)
                                        .frame(width: UIScreen.main.bounds.width/1.12)
                                        .background(Color(selectedColor).opacity(0.8))
                                        .cornerRadius(15)
                                }.padding(.top, 10)
                                Spacer()
                            }
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
            .background(Color(selectedColor).opacity(0.8))
            
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing:
                    Button {
                        DismissButton.toggle()
                        if AuthenticationObject.logINDismissSheet == false {
                            DismissButton.toggle()
                        }
                    } label: {
                        Text("Cancel")
                            .foregroundColor(.white)
                    }
                    .padding(.trailing, 5)
            )
        }
        .navigationViewStyle(.stack)
        .accentColor(.white)
        
        .alert(isPresented: $AuthenticationObject.errorSignINBool) {
            Alert(title: Text("ERROR"), message: Text(AuthenticationObject.signInAlertString), dismissButton: .cancel(Text("Cancel"), action: {
                withAnimation {
                    self.toogleProgressView.toggle()
                    self.AuthenticationObject.errorSignINBool = false
                }
                
            }))
        }
    }
    
    func extractUsername(from email: String) -> String? {
        let random_two_digit_Number = Int.random(in: 0..<99)
        guard let range = email.range(of: "@") else {
            return nil
        }
        return String(email[..<range.lowerBound]+String(random_two_digit_Number))
    }
}

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var AuthenticationObject: UserAuthnticateViewModel
    @State var toggleShow_Hide_Password: Bool = true
    @State var toogleProgressView: Bool = false
    @Binding var DismissButton: Bool
    @AppStorage("selectedColor") var selectedColor: String = "Theme_Blue"
    @AppStorage("toggleHaptics") var toggleHaptics: Bool = true
    @State var forgotPasswordSheetToogle: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .center) {
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Welcome Back,")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .shadow(radius: 20)
                            
                            Text("Login Now")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                                .shadow(radius: 20)
                        }.foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.horizontal, 25)
                    
                    VStack {
                        VStack(spacing: 15) {
                            HStack(spacing: 0){
                                Image(systemName: "envelope")
                                    .foregroundColor(Color.gray.opacity(0.7))
                                
                                TextField("E-mail", text: $email)
                                    .padding(.horizontal, 10)
                                    .keyboardType(.emailAddress)
                                    .background(Color.init(uiColor: .secondarySystemBackground))
                                    .cornerRadius(10)
                                    .textContentType(.emailAddress)
                                    .tint(Color(selectedColor))
                                    .submitLabel(.next)
                            }
                            
                            Divider()
                            HStack(alignment: .center, spacing: 0){
                                Image(systemName: "key")
                                    .foregroundColor(Color.gray.opacity(0.7))
                                
                                if toggleShow_Hide_Password {
                                    SecureField("Password", text: $password)
                                        .padding(.horizontal, 10)
                                        .background(Color.init(uiColor: .secondarySystemBackground))
                                        .cornerRadius(10)
                                        .tint(Color(selectedColor))
                                } else {
                                    TextField("Password", text: $password)
                                        .padding(.horizontal, 10)
                                        .background(Color.init(uiColor: .secondarySystemBackground))
                                        .cornerRadius(10)
                                        .tint(Color(selectedColor))
                                }
                                
                                Button {
                                    withAnimation {
                                        toggleShow_Hide_Password.toggle()
                                        if toggleHaptics {
                                            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                        }
                                    }
                                } label: {
                                    Image(systemName: toggleShow_Hide_Password ? "eye.slash.fill": "eye.fill")
                                        .foregroundColor(Color.gray.opacity(0.7))
                                }
                                
                            }
                        }
                        .padding(20)
                        .background(Color.init(uiColor: .secondarySystemBackground))
                        .cornerRadius(18)
                        .padding(.horizontal,20)
                        
                        HStack {
                            Spacer()
                            Button {
                                forgotPasswordSheetToogle.toggle()
                            } label: {
                                Text("Forgot Password?")
                                    .font(.caption)
                                    .foregroundColor(Color(selectedColor).opacity(0.8))
                                    .padding(5)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding(.horizontal, 19)
                        
                        HStack(alignment: .center) {
                            Spacer()
                            Button {
                                withAnimation {
                                    toogleProgressView = true
                                    AuthenticationObject.logInUser(email: email, password: password)
                                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                }
                            } label: {
                                Text("LOG IN")
                                    .foregroundColor(.white)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .padding(12)
                                    .frame(width: UIScreen.main.bounds.width/1.12)
                                    .background(Color(selectedColor).opacity(0.8))
                                    .cornerRadius(15)
                            }.padding(.top, 10)
                            Spacer()
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
            .background(Color(selectedColor).opacity(0.8))
            
            .sheet(isPresented: $forgotPasswordSheetToogle, content: {
                ForgotPassword()
            })
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing:
                    Button {
                        withAnimation {
                            DismissButton.toggle()
                            if AuthenticationObject.logINDismissSheet == false {
                                DismissButton.toggle()
                            }
                        }
                    }  label: {
                        Text("Cancel")
                            .foregroundColor(.white)
                    }
                    .padding(.trailing, 5)
                
            )
        }.tint(.white)
            .navigationViewStyle(.stack)
        
            .alert(isPresented: $AuthenticationObject.errorLogINBool) {
                Alert(title: Text("ERROR"), message: Text("\(AuthenticationObject.logInAlertString)"), dismissButton: .default(Text("Cancel"), action: {
                    withAnimation {
                        toogleProgressView = false
                        AuthenticationObject.errorLogINBool = false
                    }
                }))
            }
    }
    
    func email_pwd_Validation(email: String, password: String) -> Bool {
        if email.contains("@") && email.contains(".com") {
            return true
        }
        return false
    }
}

struct customProgressBar: View {
    var body: some View {
        VStack {
            Spacer()
            LottieAnimationViews(fileName: "90610-sandloader")
                .frame(width: 100, height: 100)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .background(.ultraThinMaterial)
    }
}

struct customProgressBarSuccess: View {
    var body: some View {
        VStack {
            Spacer()
            LottieAnimationViews(fileName: "123492-success-send")
                .frame(width: 120, height: 120)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .background(.ultraThinMaterial)
    }
}

