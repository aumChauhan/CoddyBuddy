//  TextFieldView.swift
//  Created by Aum Chauhan on 20/07/23.

import SwiftUI

struct TextFieldView: View {
    
    @State private var tempString: String = ""
    
    var body: some View {
        HStack {
            TextField("Username", text: $tempString)
                .padding(10)
                .singleTag()
        }
    }
}

struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldView()
    }
}
