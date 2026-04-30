//
//  statsRow.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 25/03/26.
//

import SwiftUI

struct StatsRowView: View {
    @ObservedObject var vm: WalletViewModel

    var body: some View {
        HStack(spacing: 10) {
            StatItemView(
                title: "Total Added",
                value: vm.totalAdded,
                icon: "💰",
                iconColor: .orange
            )
            StatItemView(
                title: "Total Spent",
                value: vm.totalSpent,
                icon: "🛒",
                iconColor: .teal
            )
            StatItemView(
                title: "Cashback",
                value: vm.cashback,
                icon: "%",
                iconColor: .red,
                isBadgeIcon: true
            )
        }
        .padding(.horizontal, 2)
    }
}

// MARK: - Stat Item Card
struct StatItemView: View {
    let title: String
    let value: Double
    let icon: String
    let iconColor: Color
    var isBadgeIcon: Bool = false

    var body: some View {
        VStack(alignment: .center, spacing: 6) {  // ⬅ center aligned

            // Icon + Title row
            HStack(spacing: 5) {
                if isBadgeIcon {
                    ZStack {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 18, height: 18)  // ⬅ smaller badge
                        Text("%")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.white)
                    }
                } else {
                    Text(icon)
                        .font(.system(size: 14))  // ⬅ smaller emoji
                }

                Text(title)
                    .font(.system(size: 10, weight: .medium))  // ⬅ smaller label
                    .foregroundColor(iconColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }

            // Amount — centered
            Text("₹\(Int(value))")
                .font(.system(size: 17, weight: .bold))  // ⬅ slightly smaller
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .center)  // ⬅ center
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 10)
        .padding(.vertical, 10)  // ⬅ reduced from 14
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
    }
}
