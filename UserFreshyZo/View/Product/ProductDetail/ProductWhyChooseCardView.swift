//
//  whyChooseCard.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 30/03/26.
//

//  ProductWhyChooseCardView.swift
//  UserFreshyZo

import SwiftUI

struct ProductWhyChooseCardView: View {
    let isPad: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Why Choose FreshyZo")
            WhyChooseRow(emoji: "🚚", title: "Free Home Delivery",
                         subtitle: "Delivered by 7:00 AM tomorrow", badge: "FREE")
            Divider()
            WhyChooseRow(emoji: "🔄", title: "Subscription Option",
                         subtitle: "Daily, weekly & monthly plans available", badge: nil)
            Divider()
            WhyChooseRow(emoji: "⏸", title: "Pause/Resume Anytime",
                         subtitle: "You can pause and resume the service any time", badge: nil)
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 18).fill(Color.white))
        .shadow(color: .black.opacity(0.06), radius: 6, y: 3)
    }
}
