//
//  WalletResponse.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 12/05/26.
//


import Foundation

// MARK: - WalletResponse
struct WalletResponse: Codable {
    let status: Bool
    let message: String
    let data: WalletData
}

// MARK: - WalletData
struct WalletData: Codable {
    let walletSummary: WalletSummary
    let rechargeHistory: [RechargeHistory]

    enum CodingKeys: String, CodingKey {
        case walletSummary = "wallet_summary"
        case rechargeHistory = "recharge_history"
    }
}

// MARK: - WalletSummary
struct WalletSummary: Codable {
    let totalRecharge: Double
    let cashback: Double
    let totalSpent: Double
    let balanceAmount: Double
    let dailyRequired: Double
    let survivalDays: Int
    let balanceLow: Bool
    let recommendedRecharge: [RecommendedRecharge]

    enum CodingKeys: String, CodingKey {
        case totalRecharge = "total_recharge"
        case cashback
        case totalSpent = "total_spent"
        case balanceAmount = "balance_amount"
        case dailyRequired = "daily_required"
        case survivalDays = "survival_days"
        case balanceLow = "balance_low"
        case recommendedRecharge = "recommended_recharge"
    }
}

// MARK: - RecommendedRecharge
struct RecommendedRecharge: Codable, Identifiable {
    var id: Int { days } // Useful for SwiftUI lists
    let months: Int
    let days: Int
    let amount: Double
}

// MARK: - RechargeHistory
struct RechargeHistory: Codable, Identifiable {
    var id: String { rechargeId } // Maps to recharge_id
    let rechargeId: String
    let rechargeAmount: String // Note: JSON shows this as a String "250"
    let rechargeDate: String
    let paymentMode: String

    enum CodingKeys: String, CodingKey {
        case rechargeId = "recharge_id"
        case rechargeAmount = "recharge_amount"
        case rechargeDate = "recharge_date"
        case paymentMode = "payment_mode"
    }
}