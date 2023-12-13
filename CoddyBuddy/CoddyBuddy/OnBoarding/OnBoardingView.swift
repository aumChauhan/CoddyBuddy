//  OnBoardingView.swift
//  Created by Aum Chauhan on 20/07/23.

import SwiftUI

struct OnBoardingView: View {
    
    @State private var selectedFilter: Int = 1
    @State private var tempString: String = ""

    private let sortingOptions = [
        ("SIGN IN", 1),
        ("SIGN UP", 2) ]
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()

            VStack(alignment: .center, spacing: 23) {

                VStack(alignment: .center) {
                    Text("Welcome to")
                        .font(.custom(Poppins.bold, size: 34))

                    Text("CoddyBuddy")
                        .font(.custom(Poppins.bold, size: 38))
                }
                .foregroundColor(.theme.inverseBackground)
                .multilineTextAlignment(.center)

                Text("Join now and start connecting with developers, and engage in meaningful discussions.")
                    .multilineTextAlignment(.center)
                    .font(.custom(Poppins.regular, size: 14))
                    .foregroundColor(.theme.secondaryTitle)


                Image("man")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 400, height: 400)

                CustomSegmentedControl(tabs: sortingOptions, selectedTab: $selectedFilter, height: 55)
                    .padding(.top, 20)


                HStack {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(height: 1)
                        .foregroundColor(.gray.opacity(0.3))
                    Text("OR")
                        .font(.custom(Poppins.regular, size: 14))
                    RoundedRectangle(cornerRadius: 12)
                        .frame(height: 1)
                        .foregroundColor(.gray.opacity(0.3))
                }

                Text("Continue with Google")
                    .foregroundColor(.theme.inverseTitle)
                    .backgroundFill(height: 55, bgColor: .theme.inverseBackground)

                Spacer()
            }
            .padding(20)
        }
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}
