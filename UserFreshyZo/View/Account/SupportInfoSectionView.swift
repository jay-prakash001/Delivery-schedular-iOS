//
//  SupportInfoSectionView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 28/03/26.
//

import SwiftUI

// MARK: - SupportInfoSectionView
struct SupportInfoSectionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            AccountSectionHeader("SUPPORT & INFO")
            
            VStack(spacing: 0) {
                
                // ← Test Report row
                NavigationLink(destination: LabReportView()) {
                    AccountMenuRowContent(icon: "bandage.fill",
                                         iconBg: Color(hex: "#E6F4F1"),
                                         iconFg: Color(hex: "#1A6B55"),
                                         title: "Test Report",
                                         subtitle: "Know the quality of our products")
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                AccountRowDivider()
                
                AccountMenuRow(icon: "gift.fill",
                               iconBg: Color(hex: "#FFF0E6"),
                               iconFg: Color(hex: "#B03A10"),
                               title: "Refer and Earn",
                               subtitle: "Browse coupons, earn points")
                AccountRowDivider()
                
                NavigationLink(destination: ComplaintView()) {
                    AccountMenuRowContent(icon: "bubble.left.fill",
                                          iconBg: Color(hex: "#E6EEF4"),
                                          iconFg: Color(hex: "#1A3D6B"),
                                          title: "Complaint Assistance",
                                          subtitle: "Facing an issue? We're here to help!")
                        .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                
                AccountMenuRow(icon: "character.bubble.fill",
                               iconBg: Color(hex: "#E6F4F1"),
                               iconFg: Color(hex: "#1A6B55"),
                               title: "Language",
                               subtitle: "Manage your language preferences")
                AccountRowDivider()
                
                AccountMenuRow(icon: "exclamationmark.square.fill",
                               iconBg: Color(hex: "#E6F4F1"),
                               iconFg: Color(hex: "#1A6B55"),
                               title: "FAQs",
                               subtitle: "FreshyZo related query")
                AccountRowDivider()
                
                Link(destination: URL(string: "https://freshyzo.com/about-us/")!) {
                    AccountMenuRowContent(
                        icon: "info.circle.fill",
                        iconBg: Color(hex: "#D7F0FF"),
                        iconFg: Color(hex: "#0F5C85"),
                        title: "About Us",
                        subtitle: "Get to know us"
                    )
                    .contentShape(Rectangle())
                }
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
    }
}

#Preview {
    NavigationStack {
        SupportInfoSectionView()
    }
}
