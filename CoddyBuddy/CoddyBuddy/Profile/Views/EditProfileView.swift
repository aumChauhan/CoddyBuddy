//  EditProfileView.swift
//  Created by Aum Chauhan on 18/08/23.

import SwiftUI

struct EditProfileView: View {
    var body: some View {
        VStack {
            HeaderWithDismissButton(title: "Edit Profile")
            
            
            
            Spacer()
        }
        .padding(20)
        .background(Color.theme.background.ignoresSafeArea())
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        Text("BG")
            .sheet(isPresented: .constant(true)) {
                EditProfileView()
                    .preferredColorScheme(.dark)
            }
    }
}
