//
//  HeaderView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 21/02/26.
//

import SwiftUI

struct HeaderView: View {
    
    var walletAmount: String = "₹0"
    
    var body: some View {
        
        let isIPad = UIDevice.current.userInterfaceIdiom == .pad
        
        let horizontalPad: CGFloat  = isIPad ? 32 : 16
        let logoHeight: CGFloat     = isIPad ? 58 : 44
        let iconSize: CGFloat       = isIPad ? 52 : 42
        let titleFontSize: CGFloat  = isIPad ? 17 : 14
        let subFontSize: CGFloat    = isIPad ? 16 : 14
        
        VStack(spacing: 2) {
            
            // MARK: Top Row
            HStack(spacing: 16) {
                
                Image("freshyzo_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: logoHeight)
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: iconSize, height: iconSize)
                    
                    Image("notification-bell")
                        .resizable()
                        .scaledToFit()
//                        .frame(width: 24, height: 24)
                        .frame(width: isIPad ? 28 : 24, height: isIPad ? 28 : 24)
                }
                
                VStack(spacing: 8) {
                    Image("wallet")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: iconSize * 0.9,
                            height: iconSize * 0.60
                        )
                    
                    Text(walletAmount)
                        .font(.system(size: isIPad ? 14 : 12, weight: .semibold))
                        .padding(.vertical, -8)
                }
            }
            .padding(.horizontal, horizontalPad)
//            .padding(.top, 8)
            .padding(.top, isIPad ? 14 : 8)
            
            Divider()
                .background(Color.gray.opacity(0.3))
            // MARK: Delivery Info (Proper Leading)
            VStack(alignment: .leading, spacing: 5) {
                
                Text("Order before 09:00 pm for delivery tomorrow!")
                    .font(.system(size: titleFontSize, weight: .semibold))
                    .foregroundColor(.black)
                
                Text("Delivering fresh between 5 AM – 9 AM")
                    .font(.system(size: subFontSize))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading) // 🔥 THIS FIXES CENTER ISSUE
            .padding(.horizontal, horizontalPad)
            .padding(.vertical, 10)
        }
        .background(Color.white)
    }
}

#Preview {
    HeaderView()
}
   
