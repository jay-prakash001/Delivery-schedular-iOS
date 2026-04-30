//
//  stickyBottomButton.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 30/03/26.
//

//  ProductComparisonCardView.swift
//  UserFreshyZo

import SwiftUI

struct ProductComparisonCardView: View {
    let isPad: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Freshyzo vs Other Brand")

            HStack(spacing: 10) {
                Text("💡")
                Text("We compared ourselves with top brands so you can make the best choice for your family.")
                    .font(.system(size: isPad ? 14 : 12)).foregroundColor(.secondary)
            }
            .padding(12)
            .background(Color("AppGreenColor").opacity(0.07))
            .cornerRadius(10)

            // Header row
            HStack {
                Text("FEATURE")
                    .font(.system(size: isPad ? 12 : 10, weight: .semibold))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("FreshyZo\n⭐ Ours")
                    .font(.system(size: isPad ? 11 : 9, weight: .bold))
                    .foregroundColor(.white).multilineTextAlignment(.center)
                    .frame(width: isPad ? 80 : 64).padding(.vertical, 6)
                    .background(Color("AppGreenColor")).cornerRadius(8)
                Text("OTHER\nBRANDS")
                    .font(.system(size: isPad ? 10 : 8, weight: .semibold))
                    .foregroundColor(.gray).multilineTextAlignment(.center)
                    .frame(width: isPad ? 60 : 48)
                Text("MASS\nMARKET")
                    .font(.system(size: isPad ? 10 : 8, weight: .semibold))
                    .foregroundColor(.gray).multilineTextAlignment(.center)
                    .frame(width: isPad ? 60 : 48)
                Text("REGULAR\nDAIRY")
                    .font(.system(size: isPad ? 10 : 8, weight: .semibold))
                    .foregroundColor(.gray).multilineTextAlignment(.center)
                    .frame(width: isPad ? 60 : 48)
            }

            Divider()

            ForEach(ComparisonDataProvider.features, id: \.name) { feature in
                ComparisonRow(feature: feature, isPad: isPad)
                Divider()
            }

            HStack(spacing: 14) {
                LegendItem(symbol: "✓", color: Color("AppGreenColor"), label: "Yes")
                LegendItem(symbol: "✗", color: .red,                   label: "No")
                LegendItem(symbol: "~", color: .orange,                label: "Partial")
            }
            .padding(.top, 4)
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 18).fill(Color.white))
        .shadow(color: .black.opacity(0.06), radius: 6, y: 3)
    }
}

