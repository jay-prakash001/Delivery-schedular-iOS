//
//  SwiftUIView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 06/04/26.
//

import SwiftUI

// MARK: - SubscriptionToastBanner

struct SubscriptionToastBanner: View {

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            Text("Subscription cancelled successfully")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .black.opacity(0.12), radius: 12, y: 4)
        )
        .padding(.bottom, 28)
        .padding(.horizontal, 24)
    }
}


#Preview {
    SubscriptionToastBanner()
}
