//
//  ProductInfoView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 30/03/26.
//

//  ProductNutritionCardView.swift
//  UserFreshyZo

import SwiftUI

struct ProductNutritionCardView: View {
    let isPad: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Nutrition")
            HStack(spacing: 12) {
                NutritionBadge(icon: "🌿", value: "A2",   label: "PROTEIN")
                NutritionBadge(icon: "🍃", value: "100%", label: "ORGANIC")
                NutritionBadge(icon: "🥛", value: "Gir",  label: "BREED")
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 18).fill(Color.white))
        .shadow(color: .black.opacity(0.06), radius: 6, y: 3)
    }
}
