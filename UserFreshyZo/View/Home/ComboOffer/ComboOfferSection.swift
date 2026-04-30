//
//  ComboOfferSection.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 21/02/26.
//

import SwiftUI

struct ComboOfferSection: View {
    let offers: [Offer]
    
    var body: some View {
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        
        VStack(alignment: .leading, spacing : 12){

            Text("COMBO OFFER")
//                .font(.system(size: 17, weight: .bold))
                .font(.system(size: isPad ? 24 : 17, weight: .bold))
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing: isPad ? 20 : 16){
                    ForEach(offers){
                        offer in OfferCardView(offer: offer)
                    }
                }
//                .padding(.horizontal)
            }
        }
    }
}


#Preview{
    ComboOfferSection(offers: HomeViewModel().offers)
}

