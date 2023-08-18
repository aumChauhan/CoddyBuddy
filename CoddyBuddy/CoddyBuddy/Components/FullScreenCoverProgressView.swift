//  ProgressView_2.swift
//  Created by Aum Chauhan on 10/08/23.

import SwiftUI

struct FullScreenCoverProgressView: View {
    
    let timer = Timer.publish(every: 0.1,on: .main, in: .common).autoconnect()
    let title: String
    @State var rotationAngle: Double = 0
    
    init(_ title: String) {
        self.title = title
    }
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Image("progressBar")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(Color.theme.button)
                    .frame(width: 40, height: 40)
                    .rotationEffect(Angle(degrees: rotationAngle))
                Spacer()
            }
            Text(title)
                .foregroundColor(.theme.primaryTitle)
                .font(.poppins(.medium, 14))
                .padding(.top, 10)
            Spacer()
        }
        .background(.ultraThinMaterial)
        .edgesIgnoringSafeArea(.all)
        .onReceive(timer) { _ in
            withAnimation {
                rotationAngle += 40
            }
        }
    }
}

struct ProgressView2: View {
    
    let timer = Timer.publish(every: 0.1,on: .main, in: .common).autoconnect()
    
    @State var rotationAngle: Double = 0
    
    var body: some View {
        HStack {
            Spacer()
            Image("progressBar")
                .renderingMode(.template)
                .resizable()
                .scaledToFill()
                .foregroundColor(Color.theme.button)
                .frame(width: 40, height: 40)
                .rotationEffect(Angle(degrees: rotationAngle))
            Spacer()
        }
        .onReceive(timer) { _ in
            withAnimation {
                rotationAngle += 40
            }
        }
    }
}

struct CustomProgressView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenCoverProgressView("Signing In")
    }
}
