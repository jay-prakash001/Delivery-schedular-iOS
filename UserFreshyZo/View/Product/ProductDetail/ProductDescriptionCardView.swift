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
    let productDesc : String
    let tags : [String]
    let isPad: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Description")
            Text(productDesc)
                .font(.system(size: isPad ? 16 : 14))
                .foregroundColor(.secondary)
                .lineSpacing(4)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(tags,
                            id: \.self) { tag in
                        
                        
                        Text(getEmojiTag(tag))
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


func getEmojiTag(_ tag: String) -> String {
    let lowerTag = tag.lowercased()
    
    // Using a switch or if-else chain to mimic your logic
    if lowerTag.contains("lab") {
        return "🧪 \(tag)"
    } else if lowerTag.contains("organic") {
        return "🌿 \(tag)"
    } else if lowerTag.contains("gir") {
        return "🐄 \(tag)"
    } else if lowerTag.contains("glass") {
        return "♻️ \(tag)"
    } else if lowerTag.contains("fat") {
        return "🥛 \(tag)"
    } else if lowerTag.contains("water") {
        return "💧 \(tag)"
    } else if lowerTag.contains("chemical") || lowerTag.contains("preservative") {
        return "🚫 \(tag)"
    } else if lowerTag.contains("nutritious") {
        return "✨ \(tag)"
    } else if lowerTag.contains("powder") {
        return "❌ \(tag)"
    } else {
        return tag // Return original if no match
    }
}
