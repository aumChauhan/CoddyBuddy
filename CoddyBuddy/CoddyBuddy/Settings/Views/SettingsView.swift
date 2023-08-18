//  SettingsView.swift
//  Created by Aum Chauhan on 18/08/23.

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationHeaderView(title: "Settings", alignLeft: true) {
            
            subHeading("General Settings")
            
            cellView("brush", "Appeareance")
            cellView("speaker", "Sounds & Haptics", showDivider: false)
            
            subHeading("Account Settings")
            
            cellView("user-edit", "Edit Profile")
            cellView("like-1", "Liked Posts")
            cellView("key", "Reset Password", showDivider: false)
            
            subHeading("Session")

            HStack(alignment: .center) {
                Image("share")
                    .rotationEffect(Angle(degrees: 90))
                    .foregroundColor(.white)
                    .circularButton(frameSize: 40, bgColor: .red)
                
                Text("Sign Out")
                    .font(.poppins(.regular, 15))
                    .foregroundColor(.red)
            }
            
        } topLeading: {
            DismissButtonView(imageName: "arrowLeft", frameSize: iconHeight)
            
        } topTrailing: {
            
        } subHeader: {
            
        }
        .toolbar(.hidden)
    }
}

extension SettingsView {
    

}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
