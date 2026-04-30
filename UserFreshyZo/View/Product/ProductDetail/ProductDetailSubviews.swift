//
//  ProductDetailSubviews.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 30/03/26.
//

import SwiftUI

// MARK: - ShareSheet
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Section Header
struct SectionHeader: View {
    let title: String
    var body: some View {
        HStack(spacing: 8) {
            Circle().fill(Color("AppGreenColor")).frame(width: 10, height: 10)
            Text(title).font(.system(size: 16, weight: .semibold))
        }
    }
}

// MARK: - Nutrition Badge
struct NutritionBadge: View {
    let icon: String; let value: String; let label: String
    var body: some View {
        VStack(spacing: 6) {
            Text(icon).font(.system(size: 22))
            Text(value).font(.system(size: 16, weight: .bold)).foregroundColor(Color("AppGreenColor"))
            Text(label).font(.system(size: 11, weight: .medium)).foregroundColor(.gray).tracking(0.5)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 14)
        .background(Color(UIColor.systemGroupedBackground)).cornerRadius(12)
    }
}

// MARK: - Comparison Row
struct ComparisonRow: View {
    let feature: ComparisonFeature
    let isPad: Bool
    var body: some View {
        HStack {
            Text(feature.name)
                .font(.system(size: isPad ? 14 : 12))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            ComparisonCell(value: feature.freshyzo, isPad: isPad).frame(width: isPad ? 80 : 64)
            ComparisonCell(value: feature.others,   isPad: isPad).frame(width: isPad ? 60 : 48)
            ComparisonCell(value: feature.mass,     isPad: isPad).frame(width: isPad ? 60 : 48)
            ComparisonCell(value: feature.regular,  isPad: isPad).frame(width: isPad ? 60 : 48)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Comparison Cell
struct ComparisonCell: View {
    let value: Bool?; let isPad: Bool
    var body: some View {
        Group {
            if let v = value {
                Image(systemName: v ? "checkmark" : "xmark")
                    .font(.system(size: isPad ? 14 : 12, weight: .bold))
                    .foregroundColor(v ? Color("AppGreenColor") : .red)
            } else {
                Text("~").font(.system(size: isPad ? 16 : 13, weight: .bold)).foregroundColor(.orange)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Legend Item
struct LegendItem: View {
    let symbol: String; let color: Color; let label: String
    var body: some View {
        HStack(spacing: 4) {
            Text(symbol).font(.system(size: 13, weight: .bold)).foregroundColor(color)
            Text(label).font(.system(size: 12)).foregroundColor(.gray)
        }
    }
}

// MARK: - Review Card
struct ReviewCard: View {
    let isPad: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle().fill(Color.gray.opacity(0.2)).frame(width: 36, height: 36)
                    .overlay(Text("R").font(.system(size: 16, weight: .semibold)).foregroundColor(.gray))
                VStack(alignment: .leading, spacing: 2) {
                    Text("Ravi S.").font(.system(size: isPad ? 14 : 13, weight: .semibold))
                    HStack(spacing: 3) {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(Color("AppGreenColor")).font(.system(size: 10))
                        Text("Verified Buyer").font(.system(size: 11)).foregroundColor(Color("AppGreenColor"))
                    }
                }
                Spacer()
                Text("★ 5.0")
                    .font(.system(size: isPad ? 13 : 11, weight: .bold)).foregroundColor(.white)
                    .padding(.horizontal, 10).padding(.vertical, 5)
                    .background(Color("AppGreenColor")).cornerRadius(20)
            }
            Text("Best milk I've ever had! Tastes so fresh and creamy. My kids love it. Will subscribe monthly!")
                .font(.system(size: isPad ? 14 : 12)).foregroundColor(.secondary).lineSpacing(3)
            Text("Feb 14, 2026").font(.system(size: isPad ? 12 : 10)).foregroundColor(.gray)
            HStack(spacing: 4) {
                Text("Helpful?").font(.system(size: isPad ? 12 : 10)).foregroundColor(.gray)
                Text("👍 12").font(.system(size: isPad ? 12 : 10)).foregroundColor(.gray)
            }
        }
        .padding(12)
        .frame(width: isPad ? 300 : 230)
        .background(Color(UIColor.systemGroupedBackground)).cornerRadius(14)
    }
}

// MARK: - Why Choose Row
struct WhyChooseRow: View {
    let emoji: String; let title: String; let subtitle: String; let badge: String?
    var body: some View {
        HStack(spacing: 14) {
            Text(emoji).font(.system(size: 28))
                .frame(width: 44, height: 44)
                .background(Color(UIColor.systemGroupedBackground)).cornerRadius(10)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(size: 15, weight: .semibold))
                Text(subtitle).font(.system(size: 12)).foregroundColor(.gray)
            }
            Spacer()
            if let badge = badge {
                Text(badge)
                    .font(.system(size: 12, weight: .bold)).foregroundColor(Color("AppGreenColor"))
                    .padding(.horizontal, 10).padding(.vertical, 5)
                    .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("AppGreenColor"), lineWidth: 1.5))
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Subscription Stepper
struct SubscriptionStepperView: View {
    @Binding var qty: Int
    let isPad: Bool

    var body: some View {
        HStack(spacing: 8) {
            Button(action: { if qty > 2 { qty -= 1 } }) {
                Text("-")
                    .font(.system(size: isPad ? 18 : 16, weight: .semibold))
                    .foregroundColor(qty <= 2 ? Color.gray.opacity(0.35) : Color("AppGreenColor"))
                    .frame(width: isPad ? 32 : 28, height: isPad ? 32 : 28)
            }
            .disabled(qty <= 2)

            Text("\(qty)")
                .font(.system(size: isPad ? 16 : 15, weight: .bold))
                .frame(minWidth: isPad ? 24 : 20)
                .multilineTextAlignment(.center)

            Button(action: { qty += 1 }) {
                Text("+")
                    .font(.system(size: isPad ? 18 : 16, weight: .semibold))
                    .foregroundColor(Color("AppGreenColor"))
                    .frame(width: isPad ? 32 : 28, height: isPad ? 32 : 28)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color("AppGreenColor").opacity(0.12))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("AppGreenColor").opacity(0.3), lineWidth: 1)
        )
    }
}
