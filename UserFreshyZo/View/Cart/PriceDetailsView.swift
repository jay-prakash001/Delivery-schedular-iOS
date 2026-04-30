//
//  PriceDetailsView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 19/03/26.
//

import SwiftUI

struct PriceDetailsCard: View {
    
    @EnvironmentObject var cartVM: CartViewModel
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Price Details")
                .font(.headline)
            
            row("Total MRP", cartVM.totalMRP)
            
            row("Total Discount", cartVM.totalDiscount, isNegative: true)
            
            HStack {
                Text("Delivery Fee")
                Spacer()
                Text("FREE")
                    .foregroundColor(.green)
                    .fontWeight(.semibold)
            }
            
            Divider()
            
            row("Total Payable", cartVM.totalPrice, bold: true)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
        )
        .padding(.horizontal)
    }
    
    func row(_ title: String, _ value: Double, isNegative: Bool = false, bold: Bool = false) -> some View {
        HStack {
            Text(title)
            
            Spacer()
            
            Text(isNegative ? "- ₹\(formatPrice(value))" : "₹\(formatPrice(value))")
                .foregroundColor(isNegative ? .green : .primary)
                .fontWeight(bold ? .bold : .regular)
        }
    }
}

#Preview {
    PriceDetailsCard()
        .environmentObject(CartViewModel())
}
