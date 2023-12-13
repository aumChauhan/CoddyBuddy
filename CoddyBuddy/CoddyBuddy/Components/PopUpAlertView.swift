//  PopUpAlertView.swift
//  Created by Aum Chauhan on 22/07/23.

import SwiftUI

struct PopUpAlertView: View {
    
    let title, alertMessage, buttonTittle: String
    let perform: (() -> Void)?
    let dismiss: (() -> Void)?
    
    var body: some View {
        
        VStack(spacing: 8) {
            // ALert Title
            Text(title)
                .font(.poppins(.semiBold, 16))
                .foregroundColor(.theme.primaryTitle)
            
            // Alert Message
            Text(alertMessage)
                .font(.poppins(.regular, 13))
                .foregroundColor(.theme.secondaryTitle)
            
            HStack {
                // Dismiss Button
                Button {
                    withAnimation {
                        // Dismiss Action
                        dismiss?()
                    }
                } label: {
                    Text("Cancel")
                        .foregroundColor(.theme.primaryTitle)
                        .bgFillToInfinity(bgColor: .gray.opacity(0.15))
                }
                
                // Primary Action
                Button {
                    perform?()
                } label: {
                    Text(buttonTittle)
                        .foregroundColor(.white)
                        .bgFillToInfinity(bgColor: .red.opacity(0.8))
                }
            }
            .padding(10)
            .padding(.top, 7)
            .font(.poppins(.medium, 14))
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .padding(13)
        .background(Color.theme.secondaryBackground)
        .cornerRadius(24)
    }
}
