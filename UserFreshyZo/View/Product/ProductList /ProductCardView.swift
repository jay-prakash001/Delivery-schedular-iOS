//
//  ProductCardView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 04/03/26.
//

import SwiftUI

// MARK: - Helpers on ProductFromApi to match UI needs
extension ProductFromApi {
    
    // Previously Product.imageURL
    var imageURL: URL? {
        let encoded = dairyProductImage.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        )
        return URL(string: encoded ?? "")
    }
    
    // Previously Product.quantityText (parsed from name)
    var quantityText: String {
        let pattern = #"(\d+\s?(ml|gm|kg|lit))"#
        if let range = productName.lowercased()
            .range(of: pattern, options: .regularExpression) {
            return String(productName[range])
        }
        return ""
    }
    
    // Previously Product.cleanName (remove quantity suffix from name)
    var cleanName: String {
        let pattern = #"\s?\d+\s?(ml|gm|kg|lit).*"#
        return productName.capitalized
//            .replacingOccurrences(of: pattern, with: "", options: .regularExpression)
//            .trimmingCharacters(in: .whitespaces)
    }
    
    // Convenience to access price/mrp as strings like old Product
    var price: String { productPrice }
    var mrp: String { dairyMrp }
    
    // Previously Product.cleanCategory (simple heuristic)
    var cleanCategory: String {productSubCategoryId}
    
    var discountPercentage: Int {
            // Convert Strings to Doubles
            let priceValue = Double(productPrice) ?? 0.0
            let mrpValue = Double(dairyMrp) ?? 0.0
            
            // Safety check: ensure MRP is greater than Price and not Zero
            guard mrpValue > 0, mrpValue > priceValue else { return 0 }
            
            let discount = ((mrpValue - priceValue) / mrpValue) * 100
            return Int(discount) // Rounds down to the nearest whole number
        }
    
    var unitFromTitle: String {
            // Split the name by spaces and remove empty entries
            let components = productName.components(separatedBy: .whitespaces)
                                       .filter { !$0.isEmpty }
            
            // Ensure there are at least two words to grab
            if components.count >= 2 {
                let lastTwo = components.suffix(2)
                return lastTwo.joined(separator: " ")
            }
            
            // Fallback: If only one word exists, return it; otherwise return empty
            return components.last ?? ""
        }
}



//fiable {
//    var id: String { productId } // Identifiable conformance
//
//    let productId: String
//    let productCategoryId: String
//    let productSubCategoryId: String
//    let productName: String
//    let dairyProductImage: String
//    let shortDesc: String
//    let nutriVal: String
//    let unit: String
//    let productPrice: String
//    let dairyMrp: String
//    let subscription: String
//    let productCategoryName: String
//    let productSubCategoryName: String
struct ProductCardView: View {
    
    let product: ProductFromApi
    @EnvironmentObject var cartVM: CartViewModel
    @EnvironmentObject var productViewModel : ProductViewModel
    
    @State private var navigateToDetail = false
    @EnvironmentObject var mainRouter : MainRouter
    
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad
    
    var quantity: Int {
        cartVM.items.first(where: { $0.id == product.id })?.quantity ?? 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) { // Wrap everything in a main container
            HStack(spacing: isPad ? 20 : 14) {
                
                // 1. IMAGE AREA
                
                AsyncImage(url: product.imageURL) { phase in
                switch phase {
                case .empty:
                    // 1. Actively loading
                    ProgressView()
                        .frame(width: isPad ? 130 : 95, height: isPad ? 130 : 95)
                        .background(Color.gray.opacity(0.1))
                        
                case .success(let image):
                    // 2. Successfully loaded
                    image
                        .resizable()
                        .scaledToFill()
                        
                case .failure(_):
                    // 3. Error state (Invalid URL, 404, or no internet)
                    VStack(spacing: 4) {
                        Image(systemName: "photo.fill") // Use a default icon
                            .font(.system(size: 24))
                        Text("No Image")
                            .font(.system(size: 10))
                    }
                    .foregroundColor(.gray)
                    .frame(width: isPad ? 130 : 95, height: isPad ? 130 : 95)
                    .background(Color.gray.opacity(0.1))
                    
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: isPad ? 130 : 95, height: isPad ? 130 : 95)
            .clipShape(RoundedRectangle(cornerRadius: 14))

                // 2. TEXT AREA
                VStack(alignment: .leading, spacing: 6) {
//                    Text(product.productSubCategoryName)
//                        .font(.system(size: isPad ? 20 : 15, weight: .semibold))
//                        .foregroundColor(Color("AppGreenColor"))
                    
                    Text("\(product.cleanName)")
                        .font(.system(size: isPad ? 18 : 14, weight: .semibold))
                    
                    HStack(alignment: .center, spacing: 6){
                        
                        Text("₹\(product.productPrice)")
                            .font(.system(size: isPad ? 18 : 16, weight: .regular))
                        
                        Text("₹\(product.mrp.components(separatedBy: ".").first ?? product.mrp)")
                            .font(.system(size: isPad ? 18 : 13, weight: .thin))
                            .strikethrough()
                            .foregroundColor(.gray)
                        
                        if product.discountPercentage > 0 {
                            Text("\(product.discountPercentage)% OFF")
                                .font(.system(size: isPad ? 14 : 10, weight: .semibold))
                                .foregroundColor(.orange)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(.blue.opacity   (0.1))
                                .cornerRadius(4)
                        }
                        
                        
                        
                    }.padding(.top, 4)
//                    Text(product.shortDesc)
//                        .font(.system(size: isPad ? 16 : 10))
//                        .foregroundColor(.gray)
                    
                    if !product.unitFromTitle.isEmpty {
                        Text(product.unitFromTitle)
                            .font(.system(size: isPad ? 13 : 8, weight: .bold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                            .foregroundColor(Color(.appGreen))
                            .background(
                                Color(.lightAppGreen).opacity(0.08)
                                    .cornerRadius(6)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color(.appGreen).opacity(0.3), lineWidth: 1) // 👈 The Border
                            )
                    }
                    
//                    Spacer()
                    // ... (Price and Discount code)
                }.padding(.top,4)
            }
            // Apply the navigation gesture to the WHOLE TOP SECTION
            .contentShape(Rectangle()) // Makes the entire HStack (including gaps) tappable
            .onTapGesture {
                navigateToProduct()
            }

            // 3. INTERACTIVE BUTTONS AREA (Separate from the tap gesture)
            HStack(spacing: 10) {
                
                    Spacer()
                ProductStepperView(product: product, quantity: quantity, isPad: isPad)
                    .environmentObject(cartVM)
                
                if product.subscription == "active" {
                    
                    
                    Button("Subscribe") {
                        print("Subscribe tapped")
                        
                        
                        
                        mainRouter.navigate(to: .subscriptionstart(product: product,quantity : quantity))
                    }
                    .buttonStyle(.plain) // Ensures it doesn't trigger parent gestures
                    .font(.system(size: isPad ? 16 : 12))
                    .frame(maxWidth: .infinity)
                    .frame(height: isPad ? 40 : 30)
                    .background(Color("AppGreenColor"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .padding(.top, 12)
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 18).fill(Color.white))
        .shadow(color: .black.opacity(0.06), radius: 6, y: 3)
    }

    // Helper to keep code clean
    private func navigateToProduct() {
//        print("Navigating to \(product.id)")
        productViewModel.fetchProductDetailsById(product.id)

        withAnimation {
            mainRouter.navigate(to: .productdetails(id: product.id))
            
        }
    }
    
}

