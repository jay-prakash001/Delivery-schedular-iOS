//
//  CartView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 19/03/26.
//

import SwiftUI

struct CartView: View {
    
    @EnvironmentObject var cartVM: CartViewModel
    @Binding var selectedTab: Int   
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            // HEADER
            Text("My Cart")
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color("AppGreenColor"))
                .foregroundColor(.white)
            
            if cartVM.items.isEmpty {
                EmptyCartView(selectedTab: $selectedTab)
            } else {
                CartContentView()
            }
        }
        .background(Color(.systemGroupedBackground))
        
        // FIXED BUTTON
        .safeAreaInset(edge: .bottom) {
            if !cartVM.items.isEmpty {
                
                VStack {
                    Button {
                        print("Proceed to Pay")
                    } label: {
                        Text("Proceed to Pay")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color("AppGreenColor"))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 8)
                .padding(.bottom, 10) // ✅ IMPORTANT (gap from tab bar)
                .background(Color(.systemGroupedBackground))
                .shadow(color: .black.opacity(0.08), radius: 5, y: -2) // ✅ floating effect
            }
        }
    }
}
