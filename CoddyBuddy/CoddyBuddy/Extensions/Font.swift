//  Font.swift
//  Created by Aum Chauhan on 21/07/23.

import Foundation
import SwiftUI

extension Font {
    enum PoppinsFont: String {
        case black = "Poppins-Black"
        case bold = "Poppins-Bold"
        case extraBold = "Poppins-ExtraBold"
        case extraLight = "Poppins-ExtraLight"
        case light = "Poppins-Light"
        case medium = "Poppins-Medium"
        case regular = "Poppins-Regular"
        case semiBold = "Poppins-SemiBold"
        case thin = "Poppins-Thin"
    }
    
    static func poppins(_ type: PoppinsFont, _ size: CGFloat) -> Font {
        return .custom(type.rawValue, size: size)
    }
}

