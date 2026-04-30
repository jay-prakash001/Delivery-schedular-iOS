//
//  ProductStepperView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 20/03/26.
//

import SwiftUI

struct ProductStepperView: View {
    
    let product: Product
    let quantity: Int
    let isPad: Bool
    
    @EnvironmentObject var cartVM: CartViewModel
    
    var body: some View {
        
        let price = Double(product.price) ?? 0
        let mrpRaw = Double(product.mrp) ?? 0
        let mrp = mrpRaw > 0 ? mrpRaw : price
        let imageURLString = product.imageURL?.absoluteString ?? ""
        
        if quantity == 0 {
            
            Button("Buy Once") {
                cartVM.addItem(
                    id: product.id,
                    name: product.cleanName,
                    price: price,
                    mrp: mrp,
                    image: imageURLString,
                    variant: product.quantityText
                )
            }
            .font(.system(size: isPad ? 16 : 12))
            .frame(maxWidth: .infinity)
            .foregroundColor(Color("AppGreenColor"))
            .frame(height: isPad ? 40 : 30)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("AppGreenColor"))
            )
            
        } else {
            
            HStack {
                
                Spacer()
                
                Button {
                    cartVM.removeItem(id: product.id)
                } label: {
                    Text("-")
                        .font(.system(size: isPad ? 18 : 14, weight: .bold))
                        .foregroundColor(Color("AppGreenColor"))
                }
                
                Spacer()
                
                Text("\(quantity)")
                    .foregroundColor(.black)
                
                Spacer()
                
                Button {
                    cartVM.addItem(
                        id: product.id,
                        name: product.cleanName,
                        price: price,
                        mrp: mrp,
                        image: imageURLString,
                        variant: product.quantityText
                    )
                } label: {
                    Text("+")
                        .font(.system(size: isPad ? 18 : 14, weight: .bold))
                        .foregroundColor(Color("AppGreenColor"))
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: isPad ? 40 : 30)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("AppGreenColor").opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("AppGreenColor"), lineWidth: 2)
            )
        }
    }
}
