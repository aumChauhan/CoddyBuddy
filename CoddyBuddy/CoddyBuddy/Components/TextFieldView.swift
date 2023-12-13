//  TextFieldView.swift
//  Created by Aum Chauhan on 10/08/23.

import SwiftUI

struct TextFieldView: View {
    
    let imageName: String?
    let placeHolder: String
    
    @FocusState private var textFieldFocused: Bool
    
    @Binding var text: String
    @Binding var showPassword: Bool
    let description: String?
    
    @State private var showKeyboardDismiss: Bool = false
    
    init(imageName: String? = nil, placeHolder: String,
         text: Binding<String>, description: String? = nil,
         showPassword: Binding<Bool>) {
        self.imageName = imageName
        self.placeHolder = placeHolder
        self._text = text
        self.description = description
        self._showPassword = showPassword
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                HStack(spacing: 13) {
                    // Image
                    if let imageName {
                        Image(imageName)
                            .foregroundColor(.theme.icon)
                    }
                    
                    // Switching Between Text & Secure Field
                    if showPassword {
                        TextField(placeHolder, text: $text)
                            .focused($textFieldFocused)
                    } else {
                        SecureField(placeHolder, text: $text)
                            .focused($textFieldFocused)
                    }
                    
                    // Clear TextField Button
                    if ((text.count >= 1) && textFieldFocused) {
                        Button {
                            text = ""
                            HapticManager.soft()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray.opacity(iconOpacity))
                        }
                    }
                    
                    // For Focusing On TextField (With Animation)
                    if textFieldFocused {
                        Text("")
                            .frame(width: 0, height: 0)
                            .onAppear { withAnimation { showKeyboardDismiss.toggle() } }
                            .onDisappear { withAnimation { showKeyboardDismiss.toggle() } }
                    }
                }
                .padding(.horizontal, 14)
                .bgFillToInfinity()
                
                // Dismiss Keyboard Button
                if showKeyboardDismiss {
                    Button {
                        dismissKeyboard()
                        HapticManager.soft()
                    } label: {
                        // Image("arrowDown")
                        Image(systemName: "keyboard.chevron.compact.down.fill")
                            .foregroundColor(.theme.icon)
                            .circularButton(frameSize: 48)
                    }
                    .tint(.primary)
                }
            }
            
            // Description
            if let description {
                if showKeyboardDismiss {
                    Text(description)
                        .font(.poppins(.regular, 12))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 8)
                }
            }
        }
    }
}


struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldView(placeHolder: "Name", text: .constant("Hello"), description: "hello", showPassword: .constant(false))
    }
}
