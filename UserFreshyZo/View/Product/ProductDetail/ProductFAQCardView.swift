//
//  faqCard.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 30/03/26.
//

//  ProductFAQCardView.swift
//  UserFreshyZo

import SwiftUI

struct ProductFAQCardView: View {
    let faqItems: [FAQItem]
    let isPad: Bool
    @Binding var expandedFAQID: UUID?

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Frequently Asked Questions")

            ForEach(Array(faqItems.enumerated()), id: \.element.id) { index, item in
                VStack(alignment: .leading, spacing: 0) {
                    Button(action: {
                        expandedFAQID = expandedFAQID == item.id ? nil : item.id
                    }) {
                        HStack(alignment: .top) {
                            Text(item.question)
                                .font(.system(size: isPad ? 16 : 14, weight: .medium))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Image(systemName: expandedFAQID == item.id ? "chevron.up" : "chevron.down")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.gray)
                                .padding(.top, 2)
                        }
                        .padding(.vertical, 14)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)

                    if expandedFAQID == item.id {
                        Text(item.answer)
                            .font(.system(size: isPad ? 15 : 13))
                            .foregroundColor(.secondary)
                            .lineSpacing(5)
                            .padding(.bottom, 14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    if index < faqItems.count - 1 {
                        Divider()
                    }
                }
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 18).fill(Color.white))
        .shadow(color: .black.opacity(0.06), radius: 6, y: 3)
    }
}
