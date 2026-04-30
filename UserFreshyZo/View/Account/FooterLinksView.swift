//
//  FooterLinksView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 28/03/26.
//

import SwiftUI

// MARK: - FooterLinksView

struct FooterLinksView: View {
    var body: some View {
        HStack(spacing: 8) {
            Spacer()
            Button("Terms") {}
                .font(.system(size: 13))
                .foregroundColor(.gray)
            Circle()
                .fill(Color.gray.opacity(0.4))
                .frame(width: 3, height: 3)
            Button("Privacy") {}
                .font(.system(size: 13))
                .foregroundColor(.gray)
            Circle()
                .fill(Color.gray.opacity(0.4))
                .frame(width: 3, height: 3)
            Button("Return") {}
                .font(.system(size: 13))
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(.top, 4)
    }
}

#Preview {
    FooterLinksView()
}
