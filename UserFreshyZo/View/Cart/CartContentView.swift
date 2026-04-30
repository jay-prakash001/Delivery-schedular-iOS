//
//  CartContentView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 20/03/26.
//

import SwiftUI

struct CartContentView: View {
    
    @EnvironmentObject var cartVM: CartViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                
                // TITLE
                HStack {
                    Text("ITEMS IN CART")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("\(cartVM.totalItems) items")
                        .foregroundColor(Color("AppGreenColor"))
                }
                .padding(.horizontal)
                
                // ITEMS
                ForEach(cartVM.items) { item in
                    CartItemRow(item: item)
                }
                
                // PRICE DETAILS
                PriceDetailsCard()
                
                // SAVINGS
//                Text("🎊 You're saving ₹\(cartVM.totalDiscount) on this order!")
                Text("🎊 You're saving ₹\(formatPrice(cartVM.totalDiscount)) on this order!")
                    .font(.caption)
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.bottom, 80)
        }
    }
}
