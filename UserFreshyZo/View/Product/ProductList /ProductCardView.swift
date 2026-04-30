//
//  ProductCardView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 04/03/26.
//

import SwiftUI

struct ProductCardView: View {
    
    let product: Product
    @EnvironmentObject var cartVM: CartViewModel
    
    @State private var navigateToDetail = false
    
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad

    var quantity: Int {
        cartVM.items.first(where: { $0.id == product.id })?.quantity ?? 0
    }
    
    var body: some View {
        
        ZStack(alignment: .topLeading) {
            
            // ── Hidden programmatic NavigationLink ──
            NavigationLink(
                destination: ProductDetailView(product: product)
                    .environmentObject(cartVM),
                isActive: $navigateToDetail
            ) {
                EmptyView()
            }
            .hidden()
            
            // ── Card UI ──
            HStack(spacing: isPad ? 20 : 14) {
                
                AsyncImage(url: product.imageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: isPad ? 130 : 95,
                       height: isPad ? 130 : 95)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                // Image tap → detail
                .onTapGesture {
                    navigateToDetail = true
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    
                    // Tappable info area → navigates to detail
                    VStack(alignment: .leading, spacing: 6) {
                        
                        Text(product.categoryName)
                            .font(.system(size: isPad ? 20 : 15, weight: .semibold))
                            .foregroundColor(Color("AppGreenColor"))
                        
                        Text("FreshyZo \(product.cleanName.replacingOccurrences(of: "\n", with: ""))")
                            .font(.system(size: isPad ? 18 : 15, weight: .semibold))
                        
                        Text(product.shortDesc)
                            .font(.system(size: isPad ? 16 : 13))
                            .foregroundColor(.gray)
                        
                        if !product.quantityText.isEmpty {
                            Text(product.quantityText)
                                .font(.system(size: isPad ? 13 : 11, weight: .semibold))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color("AppGreenColor").opacity(0.15))
                                .foregroundColor(Color("AppGreenColor"))
                                .cornerRadius(6)
                        }
                        
                        HStack(spacing: 6) {
                            Text("₹\(product.price)")
                                .font(.system(size: isPad ? 18 : 15, weight: .bold))
                            
                            Text("₹\(product.mrp)")
                                .font(.system(size: isPad ? 14 : 10))
                                .foregroundColor(.gray)
                                .strikethrough()
                            
                            if let price = Double(product.price),
                               let mrp = Double(product.mrp),
                               mrp > 0 {
                                let raw = ((mrp - price) / mrp) * 100
                                if raw.isFinite {
                                    let discount = Int(max(0, raw))
                                    Text("\(discount)% OFF")
                                        .font(.system(size: isPad ? 15 : 10))
                                        .lineLimit(1)
                                        .fixedSize()
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 3)
                                        .background(Color.orange.opacity(0.2))
                                        .cornerRadius(6)
                                }
                            }
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        navigateToDetail = true
                    }
                    
                    // ── Bottom row: stepper + subscribe — these do NOT navigate ──
                    HStack(spacing: 10) {
                        ProductStepperView(
                            product: product,
                            quantity: quantity,
                            isPad: isPad
                        )
                        .environmentObject(cartVM)
                        
                        Button("Subscribe") {
                            // Subscribe action
                        }
                        .font(.system(size: isPad ? 16 : 12))
                        .frame(maxWidth: .infinity)
                        .frame(height: isPad ? 40 : 30)
                        .background(Color("AppGreenColor"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.top, 6)
                }
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white)
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            .shadow(color: .black.opacity(0.06), radius: 6, y: 3)
        }
    }
}
