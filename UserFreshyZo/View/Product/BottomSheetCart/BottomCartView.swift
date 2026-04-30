//
//  BottomCartView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 19/03/26.
//

import SwiftUI
struct BottomCartView: View {

    @EnvironmentObject var cartVM: CartViewModel
    @Binding var selectedTab: Int

    var body: some View {
        HStack {

            VStack(alignment: .leading, spacing: 4) {
                Text("\(cartVM.totalItems) items")
                    .font(.caption)
                    .foregroundColor(.white)

                Text("₹\(formatPrice(cartVM.totalPrice))")
                    .font(.headline)
                    .foregroundColor(.white)
            }

            Spacer()

            Button {
                selectedTab = 4   
            } label: {
                HStack {
                    Text("View Cart")
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.white)
            .foregroundColor(Color("AppGreenColor"))
            .cornerRadius(10)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("AppGreenColor"))
                .shadow(radius: 6)
        )
    }
}

func formatPrice(_ value: Double) -> String {
    return String(format: "%.2f", value)
}
