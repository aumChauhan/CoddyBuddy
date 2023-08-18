//  AuthMethodsView.swift
//  Created by Aum Chauhan on 21/07/23.

import SwiftUI
import AlertToast

struct AuthMethodsView: View {
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = true
    
    @State private var isAnimating: Bool = false
    @State private var showSignInView: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .center) {
                Color.theme.background.ignoresSafeArea()
                
                StaticNavBarView("Get Started By\nCreating Account") {
                    
                    // toolbarContent
                    
                } content: {
                    textFields
                    
                    singUpButton
                    
                    Spacer()
                    
                    customDivider
                    
                    continueWithGoogle
                    
                    signInNavigator
                }
                .padding(20)
                .ignoresSafeArea(.keyboard)
                
                // MARK: Progress View
                if viewModel.showProgressView {
                    FullScreenCoverProgressView("Creating Account")
                        .onAppearDismissKeyboard()
                }
            }
            .adaptsToKeyboard()
        }
        .opacity(isAnimating ? 1 : 0)
        .animation(.easeIn, value: isAnimating)
        .onAppear {
            isAnimating = true
        }
        
        // MARK: Sign In Flow
        .sheet(isPresented: $showSignInView) {
            SignInView()
                .interactiveDismissDisabled()
        }
        
        // MARK: Profile Photo Flow
        .sheet(isPresented: $viewModel.userCompletedSignUp, onDismiss: {
            viewModel.setUserSessionAfterProfileSetup()
        }, content: {
            SetProfilePhotoView()
                .interactiveDismissDisabled()
        })
        
        // MARK: Alert
        .toast(isPresenting: $viewModel.errorOccured) {
            AlertToast(
                displayMode: .banner(.slide), type: .systemImage("exclamationmark.triangle.fill", .white),
                title: "Exception Occured!",
                subTitle: viewModel.errorDescription,
                style: .style(backgroundColor: .red, titleColor: .white, subTitleColor: .white)
            )
        }
    }
}

extension AuthMethodsView {
    
    // MARK: TextFields
    private var textFields: some View {
        Group {
            // Name
            TextFieldView(
                imageName: "person", placeHolder: "Full Name",
                text: $viewModel.fullName,
                description: "❥ Name should have a character count of less than 16 & should not contain any numerical digits.",
                showPassword: .constant(true))
            
            // UserName
            TextFieldView(
                imageName: "user-tick", placeHolder: "Username",
                text: $viewModel.userName,
                description: "❥ Username character count should be less than 14 & should consist only of lowercase letters, numbers, (.), and (_).",
                showPassword: .constant(true))
            
            // Email
            TextFieldView(imageName: "wallet", placeHolder: "E-Mail", text: $viewModel.emailId, showPassword: .constant(true))
            
            // Password
            TextFieldView(
                imageName: "lock", placeHolder: "Password",
                text: $viewModel.password,
                description: "❥ The password must be 6 characters long or more.",
                showPassword: .constant(false))
        }
    }
    
    // MARK: ToolBar
    private var toolbarContent: some View {
        Button {
            // MARK: Dismiss AuthMethods View Action
            withAnimation {
                isOnboardingViewActive = true
            }
        } label: {
            Image("arrowLeft")
                .foregroundColor(.theme.icon)
                .circularButton(frameSize: iconHeight)
        }
        .tint(.primary)
    }
    
    // MARK: Divider
    var customDivider: some View {
        HStack {
            RoundedRectangle(cornerRadius: 12)
            
            Text("OR")
                .foregroundColor(.theme.primaryTitle)
                .font(.poppins(.regular, 14))
            
            RoundedRectangle(cornerRadius: 12)
        }
        .frame(height: 1)
        .foregroundColor(.gray.opacity(0.3))
    }
    
    // MARK: Sign In Label
    private var signInNavigator: some View {
        HStack {
            Text("Already Have Account?")
            
            Button {
                // MARK: Toogle SignIn View
                showSignInView.toggle()
                HapticManager.light()
            } label: {
                Text("Sign In Instead")
                    .gradientForeground(gradient: Color.theme.gradient)
            }
        }
        .font(.poppins(.medium, 14))
    }
    
    // MARK: Continue With Google Button
    private var continueWithGoogle: some View {
        Button {
            // MARK: Continue With Google Action
            Task {
                await viewModel.continueWithGoogle()
            }
        } label: {
            continueWithGoogleLabel
        }
    }
    
    var continueWithGoogleLabel: some View {
        HStack {
            Image("googleLogo")
                .resizable()
                .frame(width: 15, height: 15)
                .padding(.horizontal, 5)
            Text("Continue With Google")
        }
        .font(.poppins(.medium, 16))
        .foregroundColor(.theme.inverseTitle)
        .bgFillToInfinity(height: 50, bgColor: .theme.inverseBackground)
        .padding(.top, 10)
    }
    
    // MARK: Sign Up Button
    private var singUpButton: some View {
        Button {
            // MARK: Sign Up Action
            Task {
                await viewModel.createUser()
            }
        } label: {
            Text("SIGN UP")
                .foregroundColor(.theme.inverseTitle)
                .font(.poppins(.medium, 16))
                .bgFillToInfinity(height: 50, bgColor: .theme.inverseBackground)
                .padding(.top, 10)
        }
    }
    
}
struct AuthMethodsView_Previews: PreviewProvider {
    static var previews: some View {
        AuthMethodsView()
            .environmentObject(AuthenticationViewModel())
    }
}
