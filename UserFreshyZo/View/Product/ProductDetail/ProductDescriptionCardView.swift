//
//  ratingsCard.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 30/03/26.
//

//  ProductDescriptionCardView.swift
//  UserFreshyZo

import SwiftUI

struct ProductDescriptionCardView: View {
    let product: Product
    let isPad: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Description")
            Text(product.description)        // ← was hardcoded string
                            .font(.system(size: isPad ? 16 : 14))
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(["🌿 Organic", "🐄 Gir Breed", "🧪 Lab Tested", "♻️ Glass Bottle"],
                            id: \.self) { tag in
                        Text(tag)
                            .font(.system(size: isPad ? 14 : 12, weight: .medium))
                            .padding(.horizontal, 12).padding(.vertical, 6)
                            .background(Color("AppGreenColor").opacity(0.1))
                            .foregroundColor(Color("AppGreenColor"))
                            .cornerRadius(20)
                    }
                }
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 18).fill(Color.white))
        .shadow(color: .black.opacity(0.06), radius: 6, y: 3)
    }
}
