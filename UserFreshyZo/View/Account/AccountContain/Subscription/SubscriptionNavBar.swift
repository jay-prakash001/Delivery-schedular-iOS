//
//  SubscriptionNavBar.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 06/04/26.
//

import SwiftUI

// MARK: - SubscriptionNavBar

struct SubscriptionNavBar: View {

    let onBack: () -> Void
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
            }
            Spacer()
            Text("Subscription")
                .font(.system(size: isPad ? 20 : 17, weight: .bold))
                .foregroundColor(.white)
            Spacer()
            Color.clear.frame(width: 36, height: 36)
        }
        .padding(.horizontal, isPad ? 24 : 16)
        .padding(.vertical, 14)
        .background(Color("AppGreenColor"))
    }
}

#Preview {
    SubscriptionNavBar(onBack: {})
}
