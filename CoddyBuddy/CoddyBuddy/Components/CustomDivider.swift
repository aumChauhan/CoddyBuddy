//  CustomDivider.swift
//  Created by Aum Chauhan on 24/07/23.

import SwiftUI

struct CustomDivider: View {
    private let overlayColor: Color?
    
    init(_ overlayColor: Color? = nil) {
        self.overlayColor = overlayColor
    }
    
    var body: some View {
        HLine()
            .stroke(style: StrokeStyle(lineWidth: 1, dash: [8]))
            .foregroundColor(overlayColor ?? .gray.opacity(0.4))
            .frame(height: 1)
    }
}

struct HLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        return path
    }
}


struct CustomDivider_Previews: PreviewProvider {
    static var previews: some View {
        CustomDivider()
    }
}
