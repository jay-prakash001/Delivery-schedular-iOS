//
//  DeliveriesView.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 18/05/26.
//

import SwiftUI

struct DeliveriesView: View {
    // Mock array simulating your upcoming data feed
    let currentDeliveries = [
        DeliveryItem(title: "Wireless Headphones", img: "https://example.com/item1.jpg", price: 149.99, qty: 1, state: "Placed", date: "May 20, 2026", txnId: "TXN-77341", bal: 49.99),
        DeliveryItem(title: "Mechanical Keyboard", img: "https://example.com/item2.jpg", price: 89.50, qty: 2, state: "Pending", date: "May 24, 2026", txnId: "TXN-88214", bal: 179.00),
        DeliveryItem(title: "USB-C Hub Adapter", img: "https://example.com/item3.jpg", price: 35.00, qty: 1, state: "Cancelled", date: "May 15, 2026", txnId: "TXN-11045", bal: 0.00)
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 14) { // Provides breathing room between your elevated cards
                ForEach(currentDeliveries) { item in
                    DeliveriesItemView(
                        imageName: item.img,
                        title: item.title,
                        unitPrice: item.price,
                        quantity: item.qty,
                        status: item.state,
                        deliveryDate: item.date,
                        transactionId: item.txnId,
                        remainingBalance: item.bal
                    )
                }
            }
            .padding(.vertical)
        }.background(Color(.systemBackground)) // Base layer underneath the elevated items
            .navigationTitle("Deliveries")
            
            // --- GREEN NAVIGATION BAR STYLING ---
            .tint(.white) // 👈 Makes your back button and navigation icons white so they pop on green
            .toolbarBackground(Color.appGreen, for: .navigationBar) // 👈 Applies your green background
            .toolbarBackground(.visible, for: .navigationBar) // 👈 Ensures the green stays visible during scroll
            // -------------------------------------- // Your app brand color
        // --------------------------------------
        // ---------------------------------------
    }
}
struct DeliveryItem: Identifiable {
    let id = UUID()
    let title: String
    let img: String
    let price: Double
    let qty: Int
    let state: String
    let date: String
    let txnId: String
    let bal: Double
}

struct DeliveriesItemView: View {
    // 1. Define Parameters
    let imageName: String           // System symbol name or asset name
    let title: String
    let unitPrice: Double
    let quantity: Int
    let status: String              // e.g., "Placed", "Pending", "Cancelled"
    let deliveryDate: String
    let transactionId: String       // e.g., "TXN-98765"
    let remainingBalance: Double    // The remaining balance value
    
    var body: some View {
        VStack(spacing: 12) { // Tighter internal spacing for a compact layout
            
            // Top Section: Product Details & Status
            HStack(alignment: .center, spacing: 12) {
                
                // Product Image (Fixed 1:1 Size Boundary)
                AsyncImage(url: URL(string: imageName)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 64, height: 64)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)
                .clipped()
                
                // Product Metadata Stack
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    // Price calculation: displays "Unit Price × Qty"
                    Text(String(format: "$%.2f × %d", unitPrice, quantity))
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                        .frame(height: 2)
                    Text(String(format: "$%.2f", unitPrice))
                        .font(.subheadline).bold()
                        .foregroundColor(.primary)
                }
                
                Spacer() // Pushes content to the left
            }
            .fixedSize(horizontal: false, vertical: true)
            
            Divider()
                .background(Color.primary.opacity(0.08))
            
            // Middle Section: Transaction Details & Remaining Balance
            VStack(spacing: 6) {
                // Transaction ID Row
                HStack {
                    Text(String(format: "🆔 Transaction ID: $%.2f", transactionId))
                    
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                
                
                HStack {
                    Text(String(format: "🗓️ Date : $%.2f", deliveryDate))
                    
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                
                Divider()
                    .background(Color.primary.opacity(0.08))
                // Remaining Balance Row (Highlighted in Orange)
                HStack {
                    Text(String(format: "💰 Remaining Balance: $%.2f", remainingBalance))
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.orange)
                    
                    Spacer()
                }
            }
            
            
        }
        .padding(12) // Inner padding
        
        // --- TRUE MATERIAL ELEVATION (NO DROP SHADOW) ---
        .background(Color(.white))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
        // ------------------------------------------------
        
        .padding(.horizontal) // Layout spacing away from device margins
    }
}
#Preview {
    DeliveriesView()
}

