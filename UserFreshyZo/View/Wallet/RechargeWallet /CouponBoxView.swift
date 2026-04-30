//
//  CouponBoxView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 25/03/26.
//

import SwiftUI

struct CouponBoxView: View {
    var body: some View {
        HStack(spacing: 12) {
            // Red badge icon
            ZStack {
                Circle()
                    .fill(Color.red)
                    .frame(width: 36, height: 36)
                Text("%")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }

            // Text
            VStack(alignment: .leading, spacing: 2) {
                Text("Apply Coupon")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(red: 0.70, green: 0.35, blue: 0.05))

                Text("Save more on recharge")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color(red: 0.70, green: 0.35, blue: 0.05).opacity(0.8))
            }

            Spacer()

            // Arrow circle
            ZStack {
                Circle()
                    .stroke(Color.orange, lineWidth: 1.5)
                    .frame(width: 28, height: 28)
                Image(systemName: "arrow.right")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.orange)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(Color(red: 1.0, green: 0.98, blue: 0.88))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    style: StrokeStyle(lineWidth: 1.2, dash: [5])
                )
                .foregroundColor(.orange)
        )
    }
}

#Preview {
    CouponBoxView()
}
