//
//  AppVersionView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 28/03/26.
//

import SwiftUI

// MARK: - AppVersionView

struct AppVersionView: View {
    var body: some View {
        Text("Made with freshness in Raipur 🌿 · v3.2.0")
            .font(.system(size: 12))
            .foregroundColor(Color.gray.opacity(0.7))
            .padding(.bottom, 4)
    }
}


#Preview {
    AppVersionView()
}
