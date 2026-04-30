//
//  productInfoCard.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 30/03/26.
//

import SwiftUI

struct ProductInfoCardView: View {
    let product: Product
    let isPad: Bool
    @Binding var subscriptionQty: Int

    private var displayTitle: String {
           let name = product.cleanName
               .replacingOccurrences(of: "\n", with: "")
               .trimmingCharacters(in: .whitespaces)
           return "FreshyZo \(name)"
       }
    
    private var unitText: String {
            product.quantityText.trimmingCharacters(in: .whitespaces)
        }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("FRESHYZO · FRESH DAILY")
                .font(.system(size: isPad ? 14 : 11, weight: .semibold))
                .foregroundColor(Color("AppGreenColor"))
                .tracking(1.2)

            Text(displayTitle)
                .font(.system(size: isPad ? 28 : 22, weight: .bold))

            Text(product.shortDesc)
                .font(.system(size: isPad ? 16 : 14))
                .foregroundColor(.gray)
            
            // ── unit pill  e.g. "500ml" ──
            if !unitText.isEmpty {
                Text(unitText)
                    .font(.system(size: isPad ? 15 : 13, weight: .semibold))
                    .foregroundColor(Color("AppGreenColor"))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(Color("AppGreenColor").opacity(0.12))
                    .cornerRadius(20)
            }


            HStack(alignment: .center, spacing: 10) {
                Text("₹\(product.price)")
                    .font(.system(size: isPad ? 26 : 20, weight: .bold))
                Text("₹\(product.mrp)")
                    .font(.system(size: isPad ? 16 : 13))
                    .foregroundColor(.gray)
                    .strikethrough()
                if let price = Double(product.price),
                   let mrp = Double(product.mrp), mrp > 0 {
                    let raw = ((mrp - price) / mrp) * 100
                    if raw.isFinite {
                        Text("\(Int(max(0, raw)))% OFF")
                            .font(.system(size: isPad ? 14 : 11, weight: .semibold))
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(Color.orange.opacity(0.15))
                            .foregroundColor(.orange)
                            .cornerRadius(6)
                    }
                }
                Spacer()
                HStack(spacing: 4) {
                    Circle().fill(Color("AppGreenColor")).frame(width: 7, height: 7)
                    Text("In Stock")
                        .font(.system(size: isPad ? 14 : 12, weight: .medium))
                        .foregroundColor(Color("AppGreenColor"))
                }
            }

            HStack {
                Text("Quantity")
                    .font(.system(size: isPad ? 18 : 16, weight: .semibold))
                Spacer()
                SubscriptionStepperView(qty: $subscriptionQty, isPad: isPad)
            }
            .padding(.top, 4)
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 18).fill(Color.white))
        .shadow(color: .black.opacity(0.06), radius: 6, y: 3)
    }
}
