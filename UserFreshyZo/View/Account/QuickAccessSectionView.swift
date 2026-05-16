//
//  QuickAccessCell.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 28/03/26.
//

import SwiftUI

// MARK: - QuickAccessSectionView

struct QuickAccessSectionView: View {
    @EnvironmentObject var mainRouter: MainRouter
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            AccountSectionHeader("QUICK ACCESS")
            
            HStack(spacing: 0) {
                QuickAccessCell(icon: "shippingbox.fill",  label: "My Order",   bgColor: Color(hex: "#F5ECD7")){}
                QuickAccessCell(icon: "truck.box.fill",    label: "Deliveries", bgColor: Color(hex: "#D7EAFF")){}
                QuickAccessCell(icon: "airplane",          label: "Vacation",   bgColor: Color(hex: "#EAD7FF")){}
                QuickAccessCell(icon: "doc.text.fill",     label: "Invoice",    bgColor: Color(hex: "#D7FFE8")){
                    mainRouter.navigate(to: .invoice)
                }
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
    }
}

struct QuickAccessCell: View {
    let icon: String
    let label: String
    let bgColor: Color
    let action: () -> Void // Added action closure
    
    // Using an optional trailing closure syntax for clean call-sites
    init(icon: String, label: String, bgColor: Color, action: @escaping () -> Void) {
        self.icon = icon
        self.label = label
        self.bgColor = bgColor
        self.action = action
    }
    
    var body: some View {
        Button(action: action) { // Passed the action directly here
            VStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(bgColor)
                        .frame(width: 54, height: 54)
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color(hex: "#1A1A1A"))
                }
                Text(label)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(hex: "#1A1A1A"))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}


