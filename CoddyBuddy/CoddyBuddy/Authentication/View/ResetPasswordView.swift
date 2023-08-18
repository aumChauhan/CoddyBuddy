//  ResetPasswordView.swift
//  Created by Aum Chauhan on 21/07/23.

import SwiftUI
import AlertToast

struct ResetPasswordView: View {
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            
            StaticNavBarView("Forgot Password?\nReset It Now!") {
                
                // Toolbar
                DismissButtonView(imageName: "arrowLeft", frameSize: iconHeight)

            } content: {
                // TextField
                TextFieldView(imageName: "wallet", placeHolder: "E-Mail", text: $viewModel.emailId, showPassword: .constant(true))
                
                resetPasswordButton

                Spacer()
            }
            .padding(20)
            .adaptsToKeyboard()
            
            // Progress View
            progressBar
        }
        
        // MARK: Reset Password Button
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

extension ResetPasswordView {
    
    // MARK: Reset Password Button
    private var resetPasswordButton: some View {
        Button {
            // MARK: Reset Password Action
            Task {
                await viewModel.getResetPaswwordURL()
            }
        } label: {
            Text("Send Reset Link")
                .foregroundColor(.theme.inverseTitle)
                .font(.poppins(.medium, 16))
                .bgFillToInfinity(height: 50, bgColor: .theme.inverseBackground)
                .padding(.top, 10)
        }
    }
    
    // MARK: Progress View
    private var progressBar: some View {
        Group {
            if viewModel.showProgressView {
                FullScreenCoverProgressView("Sending Reset Link")
                    .onAppearDismissKeyboard()
                
                // Completion Feedback (Alert)
                    .toast(isPresenting: $viewModel.emailSentSuccessfully) {
                        AlertToast(
                            displayMode: .banner(.slide), type: .systemImage("envelope.badge.fill", .white),
                            title: "Email Sent Successfully",
                            style: .style(backgroundColor: .green, titleColor: .white, subTitleColor: .white)
                        )
                    }
                
                // Dismissing Sheet After Mail Sent
                    .onAppear {
                        if viewModel.emailSentSuccessfully {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                dismiss()
                            }
                        }
                    }
            }
        }
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        Text("BG")
            .sheet(isPresented: .constant(true)) {
                ResetPasswordView()
                    .environmentObject(AuthenticationViewModel())
            }
    }
}
