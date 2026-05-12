//
//  AccountMenuRow.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 28/03/26.
//

import SwiftUI

// MARK: - AccountMenuRowContent (layout only — used inside NavigationLink)

struct AccountMenuRowContent: View {
    let icon: String
    let iconBg: Color
    let iconFg: Color
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(iconBg)
                    .frame(width: 44, height: 44)
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(iconFg)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color(hex: "#1C1C1E"))
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Color.gray.opacity(0.35))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

// MARK: - AccountMenuRow (button wrapper — for non-navigation rows)

struct AccountMenuRow: View {
    let icon: String
    let iconBg: Color
    let iconFg: Color
    let title: String
    let subtitle: String
    let onClick: () -> Void
    var body: some View {
        Button(action: {
            onClick()

        }) {
            AccountMenuRowContent(icon: icon,
                                  iconBg: iconBg,
                                  iconFg: iconFg,
                                  title: title,
                                  subtitle: subtitle)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - AccountSectionHeader

struct AccountSectionHeader: View {
    let text: String
    init(_ text: String) { self.text = text }

    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .semibold))
            .foregroundColor(Color.gray.opacity(0.75))
            .tracking(1.4)
    }
}

// MARK: - AccountRowDivider

struct AccountRowDivider: View {
    var body: some View {
        Divider()
            .padding(.leading, 74)
    }
}
