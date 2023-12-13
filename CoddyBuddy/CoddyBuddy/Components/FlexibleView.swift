//  FlowLayout.swift
//  Created by Aum Chauhan on 06/08/23.

import SwiftUI

// MARK: Source -> https://blog.logrocket.com/implementing-tags-swiftui/

struct FlowLayout<Data, ID, RowContent>: View where Data: RandomAccessCollection, RowContent: View, Data.Element: Hashable, ID : Hashable  {
    @State private var height: CGFloat = .zero
    
    private var data: Data
    private var id: KeyPath<Data.Element, ID>
    private var spacing: CGFloat
    private var rowContent: (Data.Element) -> RowContent
    
    public init(_ data: Data , _ id: KeyPath<Data.Element, ID> , spacing: CGFloat = 4, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) {
        self.data = data
        self.spacing = spacing
        self.rowContent = rowContent
        self.id = id
    }
    
    var body: some View {
        GeometryReader { geometry in
            content(in: geometry)
                .background(viewHeight(for: $height))
        }
        .frame(height: height)
    }
    
    private func content(in geometry: GeometryProxy) -> some View {
        var bounds = CGSize.zero
        
        return ZStack {
            ForEach(data, id: id) { item in
                rowContent(item)
                    .padding(.all, spacing)
                    .alignmentGuide(VerticalAlignment.center) { dimension in
                        let result = bounds.height
                        
                        if let firstItem = data.first, item == firstItem {
                            bounds.height = 0
                        }
                        return result
                    }
                    .alignmentGuide(HorizontalAlignment.center) { dimension in
                        if abs(bounds.width - dimension.width) > geometry.size.width {
                            bounds.width = 0
                            bounds.height -= dimension.height
                        }
                        
                        let result = bounds.width
                        
                        if let firstItem = data.first, item == firstItem {
                            bounds.width = 0
                        } else {
                            bounds.width -= dimension.width
                        }
                        return result
                    }
            }
        }
    }
    
    private func viewHeight(for binding: Binding<CGFloat>) -> some View {
        GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}

