//  Color.swift
//  Created by Aum Chauhan on 17/07/23.

import Foundation
import SwiftUI

extension Color {
    static let theme = ClassicGreen()
}

struct ClassicGreen {
    let background: Color = Color("background")
    let button: Color = Color("button")
    let icon: Color = .secondary
    let primaryTitle: Color = Color("primaryTitle")
    let secondaryBackground: Color = Color("secondaryBackground")
    let secondaryTitle: Color = Color("secondaryTitle")
    let inverseBackground: Color = Color("inverseBackground")
    let inverseTitle: Color = Color("inverseTitle")
    let tabBackground: Color = Color("tabBackground")
    let gradient = LinearGradient(
        colors: [
            Color(red: 0.14, green: 0.77, blue: 0.38),
            Color(red: 0.47, green: 0.82, blue: 0.11),
            Color(red: 0.09, green: 0.86, blue: 0.82)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    let nilGradient = LinearGradient(
        colors: [ ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
