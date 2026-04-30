//
//  OfferCardView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 21/02/26.
//

import SwiftUI

struct OfferCardView: View {
    
    let offer: Offer
    
    var body: some View {
        
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
               
        let cardWidth: CGFloat = isPad ? 220 : 140
        let cardHeight: CGFloat = isPad ? 240 : 180
        let imageHeight: CGFloat = isPad ? 130 : 90
        
        VStack(alignment: .leading, spacing: 6) {
            
            Image(offer.image)
                .resizable()
                .scaledToFill()
//                .frame(width: 140, height: 90)
                .frame(width: cardWidth, height: imageHeight)
                .clipped()
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(offer.title)
//                    .font(.system(size: 14, weight: .semibold))
                    .font(.system(size: isPad ? 18 : 14, weight: .semibold))

                
                Text(offer.subtitle)
//                    .font(.system(size: 12))
                    .font(.system(size: isPad ? 16 : 12))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
                       
            Spacer()
            
            HStack {
                Text("₹\(offer.price)")
//                    .font(.system(size: 14, weight: .semibold))
                    .font(.system(size: isPad ? 18 : 14, weight: .semibold))

                    
                Spacer()
                
                Button("+") {
                    
                }
                .font(.system(size: isPad ? 18 : 14, weight: .bold))
//                .frame(width: 25, height: 25)
                .frame(width: isPad ? 32 : 25, height: isPad ? 32 : 25)
                .background(Color("AppGreenColor"))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
//        .frame(width: 140, height: 180)
        .frame(width: cardWidth, height: cardHeight)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
        )
        .shadow(color: .black.opacity(0.08), radius: 6, y: 4)
    }
}

//#Preview {
//    OfferCardView(offers: HomeViewModel().offers)
//}

#Preview {
    OfferCardView(
        offer: Offer(
            id: 1,
            title: "Milk and Ghee",
            subtitle: "Fresh combo",
            price: 120,
            image: "milk_ghee"
        )
    )
    .padding()
}

