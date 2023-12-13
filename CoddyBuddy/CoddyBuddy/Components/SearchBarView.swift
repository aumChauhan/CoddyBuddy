//  SearchBarView.swift
//  Created by Aum Chauhan on 18/07/23.

import SwiftUI

struct SearchBarView: View {
    
    var showAutoKeyboardDismiss: Bool? = nil
    
    @FocusState private var searchFieldFocused: Bool
    
    @Binding var text: String
    @State private var showKeyboardDismiss: Bool = false
    
    init(text: Binding<String>, showAutoKeyboardDismiss: Bool? = nil) {
        self._text = text
        self.showAutoKeyboardDismiss = showAutoKeyboardDismiss
    }
    
    var body: some View {
        HStack {
            HStack(spacing: 13) {
                // Image
                Image("magnifyingGlass")
                    .foregroundColor(.theme.icon)
                
                // TextField
                TextField("Search", text: $text)
                    .focused($searchFieldFocused)
                
                // Clear TextField Button
                if (text.count >= 1) {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray.opacity(iconOpacity))
                    }
                }
                
                // For Focusing On TextField (With Animation)
                if searchFieldFocused {
                    Text("")
                        .frame(width: 0, height: 0)
                        .onAppear { withAnimation { showKeyboardDismiss.toggle() } }
                        .onDisappear { withAnimation { showKeyboardDismiss.toggle() } }
                }
            }
            .padding(.horizontal, 14)
            .bgFillToInfinity()
            
            // Dismiss Keyboard Button
            if showAutoKeyboardDismiss ?? true {
                if showKeyboardDismiss {
                    Button {
                        dismissKeyboard()
                    } label: {
                        Image("arrowDown")
                            .foregroundColor(.theme.icon)
                            .circularButton(frameSize: 48)
                    }
                }
            }
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(text: .constant(""))
    }
}
