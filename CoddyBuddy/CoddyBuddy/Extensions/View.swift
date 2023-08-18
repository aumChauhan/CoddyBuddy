//  View.swift
//  Created by Aum Chauhan on 20/07/23.

import Foundation
import SwiftUI
import Combine

extension View {
    
    // MARK: - Default Values
    var radius: CGFloat {
        return 20
    }
    
    var iconHeight: CGFloat {
        return 40
    }

    var iconOpacity: CGFloat {
        return 0.8
    }
    
    // MARK: - Modifiers
    public func gradientForeground(gradient: LinearGradient) -> some View {
        self.overlay(
            gradient
        )
        .mask(self)
    }
    
    public func codeBlockStyle(bgColor: Color? = nil) -> some View {
        self
            .font(.system(size: 13, weight: .regular, design: .monospaced))
            .foregroundColor(.theme.primaryTitle)
            .frame(alignment: .leading)
            .padding(7)
            .padding(.horizontal, 4)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(bgColor ?? Color.theme.secondaryBackground)
            .cornerRadius(12)
    }
    
    func tagStyle(cornerRadius: CGFloat? = nil) -> some View {
        self
            .font(.poppins(.medium, 14))
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .foregroundColor(.theme.primaryTitle)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius ?? 200, style: .continuous)
                    .stroke(Color.theme.secondaryTitle.opacity(0.5), lineWidth: 1)
            )
    }
    
    func circularButton(frameSize: CGFloat, bgColor: Color? = nil) -> some View {
        self
            .padding(8)
            .frame(width: frameSize, height: frameSize)
            .background(bgColor ?? Color.theme.secondaryBackground)
            .cornerRadius(100)
    }
    
    func circularGradientButton(frameSize: CGFloat, bgColor: [Color]? = nil) -> some View {
        self
            .padding(8)
            .frame(width:frameSize, height: frameSize)
            .background(
                LinearGradient(
                    colors: bgColor ?? [
                        Color(red: 0.14, green: 0.77, blue: 0.38),
                        Color(red: 0.47, green: 0.82, blue: 0.11),
                        Color(red: 0.09, green: 0.86, blue: 0.82)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(100)
    }
    
    func inverseDynamicBackground() -> some View {
        self
            .font(.poppins(.semiBold, 14))
            .foregroundColor(.theme.inverseTitle)
            .padding(15)
            .dynamicBgFill(height: 48, bgColor: .theme.inverseBackground)
    }
    
    func bgFillToInfinity(height: CGFloat? = nil, bgColor: Color? = nil,radius: CGFloat? = nil) -> some View {
        self
            .frame(maxWidth: .infinity)
            .frame(height: height ?? 48)
            .background(bgColor ?? Color.theme.secondaryBackground)
            .cornerRadius(radius ?? 100)
    }
    
    func dynamicBgFill(height: CGFloat? = nil, bgColor: Color? = nil,radius: CGFloat? = nil) -> some View {
        self
            .frame(height: height ?? 48)
            .background(bgColor ?? Color.theme.secondaryBackground)
            .cornerRadius(radius ?? 100)
    }
    
    func dynamicGradientFill(height: CGFloat? = nil,radius: CGFloat? = nil) -> some View {
        self
            .frame(height: height ?? 48)
            .background(Color.theme.gradient)
            .cornerRadius(radius ?? 100)
    }
    
    func textEditorStyle() -> some View {
        self
            .padding(14)
            .scrollContentBackground(.hidden)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.theme.secondaryBackground)
            .cornerRadius(24)
    }
    
    func gradientFillToInfinity(height: CGFloat? = nil) -> some View {
        self
            .frame(maxWidth: .infinity)
            .frame(height: height ?? 48)
            .background(Color.theme.gradient)
            .cornerRadius(100)
    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
    
    func adaptsToKeyboard() -> some View {
        return modifier(AdaptsToKeyboard())
    }
    
    // TODO: Remove
    func alertSheetStyle(fraction: CGFloat? = nil) -> some View {
        self
            .interactiveDismissDisabled()
            .presentationDetents([.fraction(fraction ?? 0.24)])
            .presentationCornerRadius(20)
            .presentationBackgroundInteraction(.disabled)
    }
    
    func onFirstAppear(perform: (() -> Void)?) -> some View {
        modifier(FirstAppearModeifier(perform: perform))
    }
    
    func onAppearDismissKeyboard() -> some View {
        self
            .onAppear {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
    }
    
    func noPostFound(_ text: String) -> some View {
        HStack {
            Spacer()
            Text(text)
                .foregroundColor(.theme.primaryTitle)
                .font(.poppins(.semiBold, 14))
                .multilineTextAlignment(.center)
                .padding(.top, 8)
            Spacer()
        }
    }
    
    func subHeading(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.poppins(.semiBold, 14))
                .foregroundColor(.gray)
            Spacer()
        }
    }
    
    func cellView(_ image: String, _ title: String, showDivider: Bool? = nil) -> some View {
        VStack {
            HStack(alignment: .center) {
                Image(image)
                    .foregroundColor(.white)
                    .circularButton(frameSize: 40, bgColor: .theme.button)
                
                Text(title)
                    .font(.poppins(.regular, 15))
                
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray.opacity(0.8))
            }
            if showDivider ?? true {
                CustomDivider()
            }
        }
        .padding(.bottom, showDivider ?? true ? 0 : 8)
    }
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
