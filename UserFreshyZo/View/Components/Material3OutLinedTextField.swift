//
//  Material3OutLinedTextField.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 25/04/26.
//

import SwiftUI

struct Material3OutLinedTextField: View {
    
    let title: String
    
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
            
            // Border
            RoundedRectangle(cornerRadius: 12)
                .stroke(isFocused ? Color.green : Color.gray.opacity(0.4), lineWidth: 1.2)
                .frame(height: 56)
            
            // Floating Label
            Text(title)
                .foregroundColor(isFocused ? .green : .gray)
                .background(Color.white)
                .padding(.horizontal, 4)
                .scaleEffect((isFocused || !text.isEmpty) ? 0.8 : 1.0)
                .offset(x: (isFocused || !text.isEmpty) ? 2 : 10, y: (isFocused || !text.isEmpty) ? -28 : 0)
                .animation(.easeInOut(duration: 0.2), value: isFocused || !text.isEmpty)
            
            // TextField
            TextField("", text: $text)
                .focused($isFocused)
                .padding(.horizontal, 12)
                .padding(.top, (isFocused || !text.isEmpty) ? 12 : 0)
                .frame(height: 56)
                .keyboardType(.numberPad)
        }
        .padding(.horizontal)
    }
}
