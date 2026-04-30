//
//  header.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 25/03/26.
//

import SwiftUI

struct WalletHeaderView: View {
    
    var onBack: (() -> Void)? = nil  // nil = tab, non-nil = navigated from Account
    
    var body: some View {
        HStack(spacing: 12) {
            
            if let onBack = onBack {
                Button(action: onBack) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(hex: "#F2F2F2"))
                            .frame(width: 36, height: 36)
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(hex: "#1C1C1E"))
                    }
                }
            }
            
            Text("My Wallet")
                .font(.title2.bold())
            
            Spacer()
        }
    }
}

#Preview {
    WalletHeaderView()
}
