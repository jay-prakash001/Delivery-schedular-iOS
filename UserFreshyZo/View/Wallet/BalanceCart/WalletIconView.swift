//
//  WalletIconView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 27/03/26.
//

import SwiftUI

// MARK: - Custom Wallet Icon
struct WalletIconView: View {
    var body: some View {
        ZStack {
            // Wallet body
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.white.opacity(0.85))  // white
                .frame(width: 26, height: 18)
                .offset(y: 2)

            // Wallet flap (top fold)
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.white.opacity(0.65))  // slightly dimmer white
                .frame(width: 26, height: 10)
                .offset(y: -4)

            // Coin/card slot circle
            Circle()
                .fill(Color(red: 0.85, green: 0.65, blue: 0.10))  // gold coin
                .frame(width: 7, height: 7)
                .offset(x: 6, y: 3)

            // Card lines
            Capsule()
                .fill(Color.white.opacity(0.4))
                .frame(width: 12, height: 2)
                .offset(x: -3, y: 0)

            Capsule()
                .fill(Color.white.opacity(0.25))
                .frame(width: 8, height: 1.5)
                .offset(x: -5, y: 3)
        }
    }
}

#Preview {
    WalletIconView()
}
