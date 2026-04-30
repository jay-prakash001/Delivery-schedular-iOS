//
//  InterpretationView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 27/03/26.
//

import SwiftUI

// MARK: - Subview: Interpretation
struct InterpretationView: View {

    private let items: [(String, [String])] = [
        ("1. FAT (Milk Fat Content)", [
            "Butterfat portion in milk.",
            "Cow Milk: 3.5% – 3.9%",
            "Buffalo Milk: 8.5 – 8.8%"
        ]),
        ("2. SNF (Solids Not Fat)", [
            "Includes casein, lactose, vitamins, minerals.",
            "Cow Milk SNF: 7.5% – 8.5%",
            "Buffalo Milk SNF: 8.5% – 9.5%"
        ]),
        ("3. Urea", [
            "Pass — No urea detected",
            "Fail — Urea adulteration detected"
        ]),
        ("4. Starch", [
            "Pass — No starch detected",
            "Fail — Starch adulteration detected"
        ]),
        ("5. Acidity", [
            "Pass — Acidity within acceptable limits (fresh milk)",
            "Fail — Acidity exceeds acceptable limits (spoiled or poor-quality milk)"
        ]),
        ("6. Detergent", [
            "Pass — No detergent detected",
            "Fail — Detergent adulteration detected"
        ]),
        ("7. Antibiotics", [
            "Pass — No antibiotics detected",
            "Fail — Antibiotics found"
        ]),
        ("8. Caustic Soda", [
            "Pass — No caustic soda detected",
            "Fail — Caustic soda found"
        ]),
    ]

    var body: some View {
        VStack(spacing: 0) {

            // Green Header
            VStack(alignment: .leading, spacing: 2) {
                Text("Interpretation")
                    .font(.title3).bold()
                    .foregroundColor(.white)
                Text("UNDERSTANDING YOUR TEST RESULTS")
                    .font(.caption).fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.8))
                    .kerning(1.2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(
                LinearGradient(
                    colors: [Color(hex: "#2E7D32"), Color(hex: "#43A047")],
                    startPoint: .leading, endPoint: .trailing
                )
            )
            .cornerRadius(16, corners: [.topLeft, .topRight])

            // Items
            VStack(spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(item.0)
                            .font(.subheadline).bold()
                        ForEach(item.1, id: \.self) { line in
                            Text(line)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .overlay(
                        Rectangle()
                            .fill(Color(hex: "#2E7D32"))
                            .frame(width: 3),
                        alignment: .leading
                    )

                    if index < items.count - 1 {
                        Divider().padding(.horizontal, 16)
                    }
                }
            }
            .background(Color.white)
            .cornerRadius(16, corners: [.bottomLeft, .bottomRight])
        }
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 3)
    }
}

#Preview {
    InterpretationView()
}
