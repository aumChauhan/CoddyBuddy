//  CustomSegmentedControl.swift
//  Created by Aum Chauhan on 17/07/23.

import SwiftUI

struct SegmentedControlView: View {
    
    let tabs: [(tabName: String, tabNumber: Int)]
    let showText: Bool?
    let height: CGFloat?
    let cornerRadius: CGFloat?
    
    @Binding var selectedTab: Int
    @Namespace private var namespace
    
    init(tabs: [(tabName: String, tabNumber: Int)], showText: Bool? = nil, selectedTab: Binding<Int>, height: CGFloat? = nil, cornerRadius: CGFloat? = nil) {
        self.tabs = tabs
        self.showText = showText
        self.height = height
        self._selectedTab = selectedTab
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        HStack {
            ForEach(tabs, id: \.tabNumber) { tab in
                Button {
                    withAnimation(.spring()) {
                        selectedTab = tab.tabNumber
                        HapticManager.light()
                    }
                } label: {
                    ZStack {
                        if selectedTab == tab.tabNumber {
                            RoundedRectangle(cornerRadius: cornerRadius ?? 100)
                                .frame(maxHeight: .infinity)
                                .foregroundColor(.theme.inverseBackground)
                                .matchedGeometryEffect(id: "tab", in: namespace)
                        }
                        if showText ?? true {
                            Text("\(tab.tabName)")
                                .font(.poppins(.medium, 14))
                                .foregroundColor(tab.tabNumber == selectedTab ? .theme.inverseTitle : .theme.secondaryTitle)
                        } else {
                            Image(tab.tabName)
                                .renderingMode(.template)
                                .foregroundColor(tab.tabNumber == selectedTab ? .theme.inverseTitle : .theme.secondaryTitle)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .tint(.primary)
            }
        }
        .bgFillToInfinity(height: height, radius: cornerRadius ?? 100)
    }
}
