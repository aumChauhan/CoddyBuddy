//  ButtonModifier.swift
//  Created by Aum Chauhan on 20/07/23.

import Foundation
import SwiftUI

struct ButtonModifier: ViewModifier {
    let frameSize: CGFloat
    let bgColor: Color?
    
    init(frameSize: CGFloat, bgColor: Color? = nil) {
        self.frameSize = frameSize
        self.bgColor = bgColor
    }
    
    func body(content: Content) -> some View {
        content
            .padding(8)
            .frame(width: frameSize, height: frameSize)
            .background(bgColor ?? Color.theme.secondaryBackground)
            .cornerRadius(100)
    }
}

struct GradientButtonModifier: ViewModifier {
    let frameSize: CGFloat
    
    init(frameSize: CGFloat) {
        self.frameSize = frameSize
    }
    
    func body(content: Content) -> some View {
        content
            .padding(8)
            .frame(width: 60, height: 60)
            .background(
                    LinearGradient(
                        colors: [
                            Color(red: 0.14, green: 0.77, blue: 0.38),
                            Color(red: 0.47, green: 0.82, blue: 0.11),
                            Color(red: 0.09, green: 0.86, blue: 0.82)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                
            )
            .cornerRadius(100)
    }
}
