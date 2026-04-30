//
//  WalletViewModel.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 25/03/26.
//

import Foundation
import Combine

class WalletViewModel: ObservableObject {
    
    @Published var balance: Double = 1500
    @Published var totalAdded: Double = 0
    @Published var totalSpent: Double = 0
    @Published var cashback: Double = 0
    
    @Published var rechargeAmount: String = ""
    
    let recommendedAmounts: [Int] = [1000, 2000, 3000, 5000]
    
    func recharge() {
        guard let amount = Double(rechargeAmount), amount > 0 else { return }
        balance += amount
        totalAdded += amount
        rechargeAmount = ""
    }
}
