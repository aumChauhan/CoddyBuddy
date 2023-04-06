import SwiftUI

struct ForgotPassword: View {
    
    @State private var email = ""
    @EnvironmentObject var AuthenticationObject: UserAuthnticateViewModel
    @State var toggleShow_Hide_Password: Bool = true
    @State var toogleProgressView: Bool = false
    @AppStorage("selectedColor") var selectedColor: String = "Theme_Blue"
    @AppStorage("toggleHaptics") var toggleHaptics: Bool = true
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .center) {
                VStack {
                    VStack {
                        HStack {
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: 30, height: 5)
                                .foregroundColor(.white.opacity(0.4))
                        }
                        .padding(.vertical, 9)
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Forgot Password")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                
                            }.foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.horizontal, 25)
                    }
                    
                    VStack {
                        VStack {
                            VStack(spacing: 15) {
                                HStack(spacing: 0){
                                    Image(systemName: "envelope")
                                        .foregroundColor(Color.gray.opacity(0.7))
                                    
                                    TextField("E-mail", text: $email)
                                        .padding(.horizontal, 10)
                                        .background(Color.init(uiColor: .secondarySystemBackground))
                                        .cornerRadius(10)
                                        .textContentType(.username)
                                        .tint(Color(selectedColor))
                                        .submitLabel(.next)
                                    Spacer()
                                    
                                    Button(action: {
                                        withAnimation {
                                            toogleProgressView = true
                                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                        }
                                        AuthenticationObject.resetPassword(email: email)
                                        if toggleHaptics {
                                            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                        }
                                    }, label: {
                                        HStack {
                                            Image(systemName: "paperplane.fill")
                                                .font(.callout)
                                                .foregroundColor(.white)
                                        }
                                        .padding(6)
                                        .background(Color(selectedColor))
                                        .cornerRadius(100)
                                    })
                                    
                                }
                            }
                        }
                        .padding(16)
                        .background(Color.init(uiColor: .secondarySystemBackground))
                        .cornerRadius(18)
                        .padding(.horizontal,20)
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
                    if AuthenticationObject.NOerrorResetBool {
                        withAnimation {
                            customProgressBarSuccess()
                        }
                    }
                }
            }
            .background(Color(selectedColor).opacity(0.8))
        }
        .tint(.white)
        
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $AuthenticationObject.errorResetBool) {
            Alert(title: Text("ERROR"), message: Text("\(AuthenticationObject.errorResetString)"), dismissButton: .default(Text("Cancel"), action: {
                withAnimation {
                    toogleProgressView = false
                }
                AuthenticationObject.errorResetBool = false
            }))
        }
    }
}
