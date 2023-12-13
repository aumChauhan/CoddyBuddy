//  AppearanceSettingView.swift
//  Created by Aum Chauhan on 18/08/23.

import SwiftUI

struct AppearanceSettingView: View {
    
    private let filterOptions = [ ("Light", 1), ("Dark", 2), ("Default", 3)]
    
    @State private var selectedFilter: Int = 1
    
    var body: some View {
        NavigationHeaderView(title: "Appearance", alignLeft: true) {
            
            subHeading("Color Scheme")
            
            ScrollView(.horizontal) {
                HStack(spacing: 15) {
                    Text("Classic Green")
                        .padding(.horizontal, 10)
                        .dynamicBgFill(height: 40, bgColor: .green)
                    
                    Text("Classic Blue")
                        .padding(.horizontal, 10)
                        .dynamicBgFill(height: 40, bgColor: .blue)
                }
                .foregroundColor(.white)
                .font(.poppins(.semiBold, 14))
            }
            
            subHeading("App Theme")
                .padding(.top, 10)
            
            SegmentedControlView(tabs: filterOptions, selectedTab: $selectedFilter, height: 48)
            
        } topLeading: {
            DismissButtonView(imageName: "arrowLeft", frameSize: iconHeight)
            
        } topTrailing: {
            
        } subHeader: {
            
        }
        .navigationBarBackButtonHidden()
    }
}

struct AppearanceSetting_Previews: PreviewProvider {
    static var previews: some View {
        AppearanceSettingView()
    }
}
