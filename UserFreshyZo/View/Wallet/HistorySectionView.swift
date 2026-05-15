//
//  historySection.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 25/03/26.
//
//
//  historySection.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 25/03/26.
//

import SwiftUI

struct HistorySectionView: View {
    @EnvironmentObject var walletViewModel: WalletViewModel
    @EnvironmentObject var mainRouter: MainRouter
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Empty state card
            VStack(spacing: 14) {
                // Header row — INSIDE the card
                HStack {
                    Text("Recharge History")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    if let history = walletViewModel.walletData?.rechargeHistory, !history.isEmpty {
                        Button {
                            
                            mainRouter.navigate(to: .walletrechargehistory(rechargeHistory: history))
                        } label: {
                            Text("View all ›")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(red: 0.18, green: 0.62, blue: 0.35))
                        }
                    }
                  
                }
                
                if let history = walletViewModel.walletData?.rechargeHistory, !history.isEmpty {
                    // Example simple list of history items
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(history.prefix(3)) { item in
                            
                            RechargeHistoryRow(item: item)
                        }
                    }
                } else {
                    Image("payment_check")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    Text("No transactions yet")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text("Your recharge history will appear here")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(Color.gray.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .padding(.horizontal, 16)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
        }
    }
}

#Preview {
    // Provide an EnvironmentObject to avoid preview crash
    let vm = WalletViewModel()
    vm.state = .success(
        WalletData(
            walletSummary: WalletSummary(
                totalRecharge: 0,
                cashback: 0,
                totalSpent: 0,
                balanceAmount: 0,
                dailyRequired: 0,
                survivalDays: 0,
                balanceLow: false,
                recommendedRecharge: []
            ),
            rechargeHistory: [] // try adding mock RechargeHistory items to preview non-empty state
        )
    )
    return HistorySectionView()
        .environmentObject(vm)
        .padding()
        .background(Color(red: 0.95, green: 0.96, blue: 0.96))
}
