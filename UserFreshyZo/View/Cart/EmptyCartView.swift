//
//  EmptyCartView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 19/03/26.
//

import SwiftUI

struct EmptyCartView: View {
    
    @Binding var selectedTab: Int
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            Spacer()
            
            LottieView(name: "empty_cart")
                .frame(height: 200)
            
            Text("Your Cart is empty!")
                .font(.title3.bold())
            
            Text("Fill this cart with freshness")
                .foregroundColor(.gray)
            
            Button("Shop now") {
                selectedTab = 1 // go to products tab
            }
            .padding()
            .frame(width: 150)
            .background(Color("AppGreenColor"))
            .foregroundColor(.white)
            .cornerRadius(10)
            
            Spacer()
        }
    }
}
