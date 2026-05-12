//
//  recommendedSection.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 25/03/26.
//

import SwiftUI

struct RecommendedView: View {
    @ObservedObject var vm: WalletViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("RECOMMENDED")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.gray)
                .tracking(0.5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    if let wallet = vm.walletData?.walletSummary.recommendedRecharge {
                        ForEach(wallet) { item in
                            Button {
                                vm.rechargeAmount = String(Int(item.amount))
                            } label: {
                                Text("₹\(Int(item.amount)) / \(item.days) days")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
//                                    .padding(.vertical, 12)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray.opacity(0.25), lineWidth: 1)
                                    )
                            }
                        }
                    }
                }
            }
        }
    }
}
