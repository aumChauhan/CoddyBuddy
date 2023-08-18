//  DismissButtonView.swift
//  Created by Aum Chauhan on 20/07/23.

import SwiftUI

struct DismissButtonView: View {
    let imageName: String
    let frameSize: CGFloat
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Button {
                dismiss()
                HapticManager.soft()
            } label: {
                Image(imageName)
                    .foregroundColor(.theme.icon)
                    .circularButton(frameSize: frameSize)
            }
            .tint(.primary)
        }
    }
}

struct HeaderWithDismissButton: View {
    
    let title: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack {
            Image(systemName: "xmark.circle.fill").opacity(0.0)
            
            Spacer()
            
            Text(title)
                .font(.poppins(.semiBold, 18))
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }
        }
    }
}

struct DismissButtonView_Previews: PreviewProvider {
    static var previews: some View {
        DismissButtonView(imageName: "arrowDown", frameSize: 40)
    }
}
