//  SignInView.swift
//  Created by Aum Chauhan on 21/07/23.

import SwiftUI
import AlertToast

struct SignInView: View {
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State private var showResetPasswordView: Bool = false
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.theme.background.ignoresSafeArea()
            
            StaticNavBarView("Welcome Back,\nSignIn Now!") {
                // Toolbar
                DismissButtonView(imageName: "arrowLeft", frameSize: iconHeight)
                
            } content: {
                // Textfields
                TextFieldView(imageName: "wallet", placeHolder: "E-Mail", text: $viewModel.emailId, showPassword: .constant(true))
                
                TextFieldView(imageName: "lock", placeHolder: "Password", text: $viewModel.password, showPassword: .constant(false))
                
                signInButton
                
                resetPasswordButton
                
                Spacer()
                
                // Divider
                AuthMethodsView().customDivider
                
                continueWithGoogle
                
            }
            .padding(20)
            
            
            // MARK: Progress View
            if viewModel.showProgressView {
                FullScreenCoverProgressView("Verifying")
                    .onAppearDismissKeyboard()
            }
        }
        .adaptsToKeyboard()
        
        // MARK: Reset Passworf Flow
        .sheet(isPresented: $showResetPasswordView) {
            ResetPasswordView()
                .interactiveDismissDisabled()
        }
        
        // MARK: Alert
        .toast(isPresenting: $viewModel.errorOccured) {
            AlertToast(
                displayMode: .banner(.slide),
                type: .systemImage("exclamationmark.triangle.fill", .white),
                title: "Exception Occured!",
                subTitle: viewModel.errorDescription,
                style: .style(backgroundColor: .red, titleColor: .white, subTitleColor: .white)
            )
        }
    }
}

extension SignInView {
    
    // MARK: Sign In Button
    private var signInButton: some View {
        Button {
            // MARK: Sign In Action
            Task {
                await viewModel.signInUser()
            }
        } label: {
            Text("SIGN IN")
                .foregroundColor(.theme.inverseTitle)
                .font(.poppins(.medium, 16))
                .bgFillToInfinity(height: 50, bgColor: .theme.inverseBackground)
                .padding(.top, 5)
        }
    }
    
    // MARK: Reset Password Button
    private var resetPasswordButton: some View {
        HStack {
            Spacer()
            // MARK: Reset Sheet Toogle
            Button {
                showResetPasswordView.toggle()
                HapticManager.light()
            } label: {
                Text("Reset Password ?")
                    .gradientForeground(gradient: Color.theme.gradient)
                    .font(.poppins(.medium, 14))
                    .frame(alignment: .trailing)
            }
        }
    }
    
    private var continueWithGoogle: some View {
        Button {
            // MARK: Continue With Google Action
            Task {
                await viewModel.continueWithGoogle()
            }
        } label: {
            AuthMethodsView().continueWithGoogleLabel
        }
    }
    
    
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .environmentObject(AuthenticationViewModel())
    }
}
