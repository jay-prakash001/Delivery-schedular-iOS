//
//  RefferalView.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 12/05/26.
//

import SwiftUI

struct RefferalView: View {
    
    let referralCode = "FRESHYZ050"
    
    @State private var showCopied = false
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            
            VStack(spacing: 18) {
                
                // MARK: - Top Card
                
                VStack(spacing: 14) {
                    
                    Image("gift")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    
                    VStack(spacing: 6) {
                        
                        Text("Invite & Earn Rewards 🎉")
                            .font(.system(size: 22, weight: .bold))
                            .multilineTextAlignment(.center)
                        
                        Text("Share your referral code with friends and earn ₹50 instantly when they place their first order.")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 10)
                    }
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 20)
                .background(Color(.systemGray6))
                .cornerRadius(24)
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                
                
                // MARK: - Referral Code Card
                
                VStack(spacing: 16) {
                    
                    Text("YOUR REFERRAL CODE")
                        .font(.system(size: 12, weight: .medium))
                        .tracking(2)
                        .foregroundColor(.gray)
                    
                    Button {
                        copyCode()
                    } label: {
                        
                        VStack(spacing: 8) {
                            
                            Text(referralCode)
                                .font(.system(size: 30, weight: .heavy))
                                .foregroundColor(Color(hex: "#009688"))
                                .padding(.horizontal, 26)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            style: StrokeStyle(
                                                lineWidth: 2,
                                                dash: [8]
                                            )
                                        )
                                        .foregroundColor(Color(hex: "#00B894"))
                                )
                            
                            Text(showCopied ? "Copied ✓" : "Tap to copy")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Color(hex: "#009688"))
                        }
                    }
                }
                .padding(.vertical, 24)
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.98, green: 0.95, blue: 0.98))
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.green.opacity(0.2), lineWidth: 1)
                )
                .cornerRadius(22)
                
                
                // MARK: - Share Button
                
                ShareLink(
                    item: shareMessage,
                    subject: Text("Join FreshyZo"),
                    message: Text(shareMessage)
                ) {
                    
                    HStack(spacing: 12) {
                        
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 18, weight: .semibold))
                        
                        Text("Invite Friends")
                            .font(.system(size: 19, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        LinearGradient(
                            colors: [
                                Color(hex: "#1DD1A1"),
                                Color(hex: "#009688")
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(30)
                }
                
                
                // MARK: - How It Works
                
                VStack(alignment: .leading, spacing: 22) {
                    
                    Text("How it works")
                        .font(.headline)
                    
                    ReferralStepView(
                        number: "1",
                        title: "Invite your friends",
                        subtitle: "Share your referral code easily"
                    )
                    
                    ReferralStepView(
                        number: "2",
                        title: "They place their first order",
                        subtitle: "When they use your code to order"
                    )
                    
                    ReferralStepView(
                        number: "3",
                        title: "You both get rewards",
                        subtitle: "Rewards credited to your wallet"
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 6)
            }
            .padding(18)
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.automatic)
        .navigationTitle(Text("Refer and Earn"))
    }
    
    
    // MARK: - Share Text
    
    var shareMessage: String {
        """
        Join FreshyZo using my referral code \(referralCode) and get exciting rewards 🎉

        Download the app now!
        """
    }
    
    
    // MARK: - Copy Function
    
    func copyCode() {
        
        UIPasteboard.general.string = referralCode
        
        withAnimation {
            showCopied = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showCopied = false
            }
        }
    }
}


// MARK: - Step View

struct ReferralStepView: View {
    
    var number: String
    var title: String
    var subtitle: String
    
    var body: some View {
        
        HStack(alignment: .top, spacing: 14) {
            
            ZStack {
                
                Circle()
                    .fill(Color.green.opacity(0.08))
                    .frame(width: 42, height: 42)
                
                Text(number)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(hex: "#009688"))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
        }
    }
}


// MARK: - Hex Color

extension Color {
    
    init(hex: String) {
        
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        
        switch hex.count {
            
        case 3:
            (a, r, g, b) = (
                255,
                (int >> 8) * 17,
                (int >> 4 & 0xF) * 17,
                (int & 0xF) * 17
            )
            
        case 6:
            (a, r, g, b) = (
                255,
                int >> 16,
                int >> 8 & 0xFF,
                int & 0xFF
            )
            
        case 8:
            (a, r, g, b) = (
                int >> 24,
                int >> 16 & 0xFF,
                int >> 8 & 0xFF,
                int & 0xFF
            )
            
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


#Preview {
    
    NavigationStack {
        RefferalView()
    }
}
