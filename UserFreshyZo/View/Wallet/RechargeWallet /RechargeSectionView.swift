//
//  rechargeSection.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 25/03/26.
//
//
//  RechargeSectionView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 25/03/26.
//

import SwiftUI

// MARK: - Main Recharge Section
struct RechargeSectionView: View {
    @ObservedObject var vm: WalletViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // Title
            Text("Recharge Wallet")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)

            // Input + Button Row
            HStack(spacing: 10) {
                // Amount TextField
                HStack(spacing: 6) {
                    Text("₹")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color(red: 0.18, green: 0.62, blue: 0.35))

                    TextField("Enter amount", text: $vm.rechargeAmount)
                        .keyboardType(.numberPad)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 14)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(red: 0.18, green: 0.62, blue: 0.35), lineWidth: 1.5)
                )

                // Recharge Button
                Button {
                    vm.recharge()
                } label: {
                    Text("Recharge")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 110, height: 50)
                        .background(Color(red: 0.40, green: 0.75, blue: 0.55))
                        .cornerRadius(12)
                }
            }

            // Coupon Box
            CouponBoxView()

            // Recommended Section
            RecommendedView(vm: vm)

            // Info Box
            InfoBoxView()
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}
