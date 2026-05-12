//
//  balanceCard.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 25/03/26.

import SwiftUI

struct BalanceCardView: View {
    @ObservedObject var vm: WalletViewModel

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(red: 0.10, green: 0.45, blue: 0.22),
                    Color(red: 0.13, green: 0.55, blue: 0.28)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .cornerRadius(20)

            // Decorative circles
            Circle()
                .fill(Color.white.opacity(0.07))
                .frame(width: 140, height: 140)
                .offset(x: 180, y: -50)

            Circle()
                .fill(Color.white.opacity(0.05))
                .frame(width: 100, height: 100)
                .offset(x: 140, y: 20)

            // Wallet icon — top right
            HStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.18))
                        .frame(width: 42, height: 42)
                    WalletIconView()
                        .frame(width: 26, height: 22)
                }
            }
            .padding(.top, 14)
            .padding(.trailing, 14)

            if let wallet = vm.walletData?.walletSummary {
                VStack(alignment: .leading, spacing: 8) {
                    // ACTIVE badge
                    Text("ACTIVE")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.22))
                        .cornerRadius(7)

                    // Label & Balance
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Current Balance")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.white.opacity(0.85))
                        
                        Text("₹\(wallet.balanceAmount, specifier: "%.0f")")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.white)
                    }

                    Spacer(minLength: 5)

                    // Bottom Alerts Row
                    HStack(spacing: 8) {
                        // Low balance pill
                        if wallet.balanceLow {
                            HStack(spacing: 5) {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 5, height: 5)
                                Text("Low Balance")
                                    .font(.system(size: 10, weight: .bold))
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color(red: 0.55, green: 0.18, blue: 0.12).opacity(0.9))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        
                        // Survival Info
                        HStack(spacing: 4) {
                            Image(systemName: "bolt.fill")
                                .font(.system(size: 9))
                            Text(wallet.survivalDays > 0 ? "\(wallet.survivalDays) Days Left" : "Recharge Now")
                                .font(.system(size: 10, weight: .bold))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.15))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
                .padding(16)
            }
        }
        .frame(height: 165) // Adjusted height to fit all elements perfectly
        .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 4)
//        .padding(.horizontal)
    }
}
struct BalanceCardView0: View {
    @ObservedObject var vm: WalletViewModel

    var body: some View {
        ZStack(alignment: .topLeading) {

            // Background gradient
            LinearGradient(
                colors: [
                    Color(red: 0.10, green: 0.45, blue: 0.22),  // darker variant
                           Color(red: 0.13, green: 0.55, blue: 0.28) 
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .cornerRadius(20)

            // Decorative circles
            Circle()
                .fill(Color.white.opacity(0.07))
                .frame(width: 140, height: 140)
                .offset(x: 180, y: -50)

            Circle()
                .fill(Color.white.opacity(0.05))
                .frame(width: 100, height: 100)
                .offset(x: 140, y: 20)

            // Wallet icon — top right
            VStack {
                HStack {
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.18))
                            .frame(width: 42, height: 42)

                        // Custom wallet SVG-style using SwiftUI shapes
                        WalletIconView()
                            .frame(width: 26, height: 22)
                    }
                }
                Spacer()
            }
            .padding(.top, 14)
            .padding(.trailing, 14)

            if let wallet = vm.walletData?.walletSummary{
                
                // Content
                VStack(alignment: .leading, spacing: 6) {

                    // ACTIVE badge
                    Text("ACTIVE")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.22))
                        .cornerRadius(7)

                    // Label
                    Text("Current Balance")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.white.opacity(0.85))
                
                    // Balance amount
                    Text("₹\(wallet.balanceAmount, specifier: "%.0f")")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)

                    Spacer()

                    // Low balance pill
                    HStack(spacing: 7) {
                        Circle()
                            .fill(Color.white.opacity(0.6))
                            .frame(width: 6, height: 6)
                        if wallet.balanceLow{
                            
                            Text("Low balance – please recharge!")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white)
                        }
                        
                       
                    }
                    
                    
                    
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        Color(red: 0.55, green: 0.18, blue: 0.12)
                            .opacity(0.85)
                    )
                    .cornerRadius(18)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Label {
                            Text(wallet.survivalDays > 0 ? "Survival Status" : "Action Required")
                                .font(.caption)
                                .textCase(.uppercase)
                                .opacity(0.8)
                        } icon: {
                            Image(systemName: "bolt.fill")
                        }

                        if wallet.survivalDays > 0 {
                            (Text("Your balance will last for ") +
                             Text("\(wallet.survivalDays) days").bold() +
                             Text("."))
                                .font(.system(size: 15))
                        } else {
                            Text("Your balance is too low for daily requirements.")
                                .font(.system(size: 15, weight: .medium))
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(wallet.survivalDays > 0 ? Color.blue.opacity(0.1) : Color.orange.opacity(0.1))
                    )
                    .foregroundColor(wallet.survivalDays > 0 ? .blue : .orange)
                    
                   
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
        }
        .frame(height: 145)  // ⬅ reduced from 170
        .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 4)
    }
}

