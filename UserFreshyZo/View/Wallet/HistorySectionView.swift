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

                    Button {
                        // Navigate to full history
                    } label: {
                        Text("View all ›")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(red: 0.18, green: 0.62, blue: 0.35))
                    }
                }

               

                // Custom receipt + checkmark icon
                ZStack(alignment: .topLeading) {
                    // Receipt body
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(red: 0.88, green: 0.95, blue: 0.89))
                        .frame(width: 54, height: 62)
                        .offset(x: 14, y: 8)

                    // Receipt lines
                    VStack(spacing: 5) {
                        ForEach(0..<3, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color(red: 0.55, green: 0.78, blue: 0.60))
                                .frame(width: 32, height: 3.5)
                        }
                    }
                    .offset(x: 22, y: 28)

                    // Green bottom fold
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(red: 0.25, green: 0.65, blue: 0.40))
                        .frame(width: 54, height: 16)
                        .offset(x: 14, y: 54)

                    // Green checkmark circle
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.25, green: 0.65, blue: 0.40))
                            .frame(width: 28, height: 28)
                        Image(systemName: "checkmark")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .offset(x: 0, y: 6)
                }
                .frame(width: 82, height: 76)
                .padding(.top, 10)

                // Text
                Text("No transactions yet")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)

                Text("Your recharge history will appear here")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(Color.gray.opacity(0.8))
                    .multilineTextAlignment(.center)
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
    HistorySectionView()
        .padding()
        .background(Color(red: 0.95, green: 0.96, blue: 0.96))
}
