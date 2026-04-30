//
//  NutritionView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 30/03/26.
//

//  ProductStickyBottomView.swift
//  UserFreshyZo

import SwiftUI

struct ProductStickyBottomView: View {
    let isPad: Bool
    let subscriptionQty: Int
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            Button(action: onContinue) {
                Text("Continue to Subscribe")
                    .font(.system(size: isPad ? 18 : 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: isPad ? 56 : 48)
                    .background(Color("AppGreenColor"))
                    .cornerRadius(14)
                    .padding(.horizontal, isPad ? 24 : 16)
                    .padding(.vertical, 14)
            }
            .background(.white)
        }
    }
}
