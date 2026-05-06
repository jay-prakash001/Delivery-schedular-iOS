//
//  ToastView.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 06/05/26.
//

import SwiftUI
struct ToastView: View {
    let message: String

    var body: some View {
        Text(message)
            .font(.subheadline)
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.black.opacity(0.8))
            .cornerRadius(10)
            .padding(.bottom, 40)
    }
}
