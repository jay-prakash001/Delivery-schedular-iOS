//
//  BottomBrandingView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 02/03/26.
//

import SwiftUI

struct BottomBrandingView: View {
    
    var body: some View {
        let isPad = UIDevice.current.userInterfaceIdiom == .pad

        VStack(alignment: .leading, spacing: isPad ? 18 : 12) {
            
            Spacer()
            
            Text("FreshyZo")
//                .font(.system(size: 48, weight: .bold))
                .font(.system(size: isPad ? 72 : 48, weight: .bold))
                .foregroundColor(Color.gray.opacity(0.25)) // faded look
            
            Text("WE MAKE 100% PURE PRODUCT\nSELECTION BASED ON QUALITY.")
//                .font(.system(size: 14, weight: .medium))
                .font(.system(size: isPad ? 18 : 14, weight: .medium))

                .multilineTextAlignment(.center)
                .foregroundColor(Color.gray.opacity(0.6))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, isPad ? 40 : 16)
        .padding(.vertical, isPad ? 80 : 40)
        .background(Color(.systemGroupedBackground))
    }
}

#Preview{
    BottomBrandingView()   
}
