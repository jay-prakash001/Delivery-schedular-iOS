//
//  DeliveryBannerView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 04/03/26.
//

import SwiftUI

struct DeliveryBannerView: View {
    
    var body: some View {
        
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        
        HStack(spacing:  isPad ? 16 : 12) {
            
            Image(systemName: "scooter")
//                .font(.title2)
                .font(.system(size: isPad ? 28 : 20))
                .foregroundColor(.white)
            
            VStack(alignment: .leading) {
                
                Text("Order by 9:00 PM — Deliver tomorrow!")
//                    .font(.subheadline)
                    .font(.system(size: isPad ? 18 : 14, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Delivering fresh between 5 AM – 9 AM")
//                    .font(.caption)
                    .font(.system(size: isPad ? 16 : 12))
                    .foregroundColor(.white.opacity(0.9))
            }
            
            Spacer()
        }
//        .padding()
        .padding(isPad ? 18 : 14)
        .background(Color("AppGreenColor").opacity(0.95))
    }
}

#Preview {
    DeliveryBannerView()
}
