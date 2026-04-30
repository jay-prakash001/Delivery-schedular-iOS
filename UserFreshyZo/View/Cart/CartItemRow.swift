//
//  CartItemRow.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 19/03/26.
//
import SwiftUI
import SDWebImageSwiftUI

struct CartItemRow: View {
    
    @EnvironmentObject var cartVM: CartViewModel
    let item: CartItem
    
    private var imageURL: URL? {
        let raw = item.image.trimmingCharacters(in: .whitespaces)
        guard !raw.isEmpty else { return nil }
        if raw.hasPrefix("http") { return URL(string: raw) }
        return URL(string: "https://freshyzo.com/admin/uploads/product_image/\(raw)")
    }
    
    var body: some View {
        
        HStack(spacing: 12) {
            
            // IMAGE ← WebImage replaces AsyncImage
            WebImage(url: imageURL)
                .resizable()
              
                .scaledToFill()
                .frame(width: 70, height: 70)
                .clipped()
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text(item.name)
                    .font(.headline)
                
                if let variant = item.variant {
                    Text(variant)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                HStack(spacing: 6) {
                    
                    let discount = item.mrp > 0
                        ? Int(((Double(item.mrp - item.price) / Double(item.mrp)) * 100))
                        : 0
                    
                    if discount > 0 {
                        Text("\(discount)% OFF")
                            .font(.caption)
                            .padding(4)
                            .background(Color.orange.opacity(0.2))
                            .cornerRadius(6)
                    }
                    
                    Text("₹\(Int(item.mrp))")
                        .strikethrough()
                        .foregroundColor(.gray)
                    
                    Text("₹\(Int(item.price))")
                        .bold()
                        .foregroundColor(Color("AppGreenColor"))
                }
                
            }
            
            Spacer()
            
            // STEPPER
            HStack {
                
                Button {
                    cartVM.removeItem(id: item.id)
                } label: {
                    Text("-")
                        .font(.headline)
                }
                
                Text("\(item.quantity)")
                    .frame(minWidth: 20)
                
                Button {
                    cartVM.addItem(
                        id: item.id,
                        name: item.name,
                        price: item.price,
                        mrp: item.mrp,
                        image: item.image,
                        variant: item.variant
                    )
                } label: {
                    Text("+")
                        .font(.headline)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("AppGreenColor"), lineWidth: 2)
            )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
        )
        .padding(.horizontal)
    }
}
