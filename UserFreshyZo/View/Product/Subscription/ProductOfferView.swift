//
//  ProductOfferView.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 16/05/26.
//

import SwiftUI

struct ProductOfferView: View {
    
    var offer: ProductOffer
    var isSelected: Bool = true
    var isPopular: Bool = true
    var body: some View {
        
        VStack(alignment: .leading,spacing: 12) {
            
            
            HStack{
               
                    
                    Text(offer.days)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                
                Spacer()
                
                if isPopular{
                    Text("👑 POPULAR" )
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.thirdGreen)
                        .clipShape(RoundedCorner(radius: 6, corners: .allCorners))

                }
                
            }
            
            Text("\(offer.totalDeliveries) deliveries")
                .font(.caption2)
                .foregroundColor(Color.gray)
            
            // Days
            HStack(spacing: 8) {
                
                
                Text("₹\(offer.amount)")
                    .font(.system(size: 26, weight: .bold))
                    
                
                
                Text("₹\(offer.originalAmount)")
                    .font(.system(size: 22, weight: .light))
                    .foregroundColor(Color.gray).strikethrough()
            }
            HStack(spacing: 4) {
                // Discount Badge
                Text(offer.discountLabel)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color.thirdGreen)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(Color.thirdGreen.opacity(0.05))
                    .clipShape(Capsule())
                
                Text("+\(offer.freeMilk) days free")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color.thirdGreen)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(Color.thirdGreen.opacity(0.05))
                    .clipShape(Capsule())
                
            }
            
            
            Text("Cashback ₹\(offer.offAmount)")
            
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.blue)
            
            HStack(spacing: 4){
                Image(systemName: "checkmark").foregroundColor(.thirdGreen).font(.caption2).bold()
                Text("Pause anytime").font(.caption2).foregroundColor(.gray)
            }
            HStack(spacing: 4){
                Image(systemName: "checkmark").foregroundColor(.thirdGreen).font(.caption2).bold()
                Text("Priority support").font(.caption2).foregroundColor(.gray)
            }
          
            
          
        }.onAppear{
            print("\(offer)")
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(isSelected ? Color.appGreen : Color.gray, lineWidth: isSelected ? 2 : 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    
    let offer = ProductOffer(
        offerId: "13",
        productId: "39",
        days: "3 Months",
        amount: "8010",
        offPercent: "10",
        freeMilk: "9",
        couponCode: "FreshCow8010"
    )
    
    ProductOfferView(offer: offer)
        .padding()
}
