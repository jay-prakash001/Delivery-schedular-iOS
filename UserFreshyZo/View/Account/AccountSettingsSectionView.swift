//
//  AccountSettingsSectionView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 28/03/26.
//

import SwiftUI

// MARK: - AccountSettingsSectionView

struct AccountSettingsSectionView: View {
    
    @ObservedObject var vm: AccountViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            AccountSectionHeader("ACCOUNT & SETTINGS")
            
            VStack(spacing: 0) {
                
                // ← Subscriptions row
                NavigationLink(destination: MySubscriptionsView()) {
                    AccountMenuRowContent(icon: "arrow.2.circlepath.circle.fill",
                                         iconBg: Color(hex: "#E6F4F1"),
                                         iconFg: Color(hex: "#1A6B55"),
                                         title: "Subscriptions",
                                         subtitle: "Check and manage subscriptions")
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                AccountRowDivider()
                
                // ← Profile row
                NavigationLink(destination: ProfileView(vm: vm)) {
                    AccountMenuRowContent(icon: "person.fill",
                                         iconBg: Color(hex: "#E6EEF4"),
                                         iconFg: Color(hex: "#1A3D6B"),
                                         title: "Profile",
                                         subtitle: "Manage and update your profile")
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                AccountRowDivider()
                
                NavigationLink(destination: ManageAddressView()) {
                    AccountMenuRowContent(icon: "house.fill",
                                          iconBg: Color(hex: "#F4EEE6"),
                                          iconFg: Color(hex: "#6B3A1A"),
                                          title: "Address",
                                          subtitle: "Manage and update saved addresses")
                        .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())

                AccountRowDivider()
                
                // ← Payments and Wallet row
                NavigationLink(destination: WalletView(isNavigated: true)) {
                    AccountMenuRowContent(icon: "bag.fill",
                                         iconBg: Color(hex: "#F4F0E6"),
                                         iconFg: Color(hex: "#6B5A1A"),
                                         title: "Payments and Wallet",
                                         subtitle: "Manage your wallet")
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
    }
}

#Preview {
    NavigationStack {
        AccountSettingsSectionView(vm: AccountViewModel())
    }
}
