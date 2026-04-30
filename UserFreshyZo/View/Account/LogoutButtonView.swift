//
//  LogoutButtonView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 28/03/26.
//

import SwiftUI

// MARK: - LogoutButtonView
struct LogoutButtonView: View {
    @ObservedObject var vm: AccountViewModel
    
    var body: some View {
        Button(action: { vm.showLogoutConfirm = true }) {
            HStack(spacing: 10) {
                Text("LOG OUT")
                    .font(.system(size: 15, weight: .bold))
                    .tracking(1.2)
                Image(systemName: "power.circle")
                    .font(.system(size: 18, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(width: 200, height: 48)
            .background(Color(hex: "#E05050"))
            .cornerRadius(24)
        }
        .frame(maxWidth: .infinity)
    }
}
