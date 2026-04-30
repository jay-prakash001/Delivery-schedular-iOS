//
//  SubscriptionStepperView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 30/03/26.
//

//  ProductRatingsCardView.swift
//  UserFreshyZo

import SwiftUI

struct ProductRatingsCardView: View {
    let isPad: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                SectionHeader(title: "Ratings")
                Spacer()
                Button("See all →") {}
                    .font(.system(size: isPad ? 15 : 13, weight: .medium))
                    .foregroundColor(Color("AppGreenColor"))
            }

            HStack(spacing: 20) {
                VStack(spacing: 4) {
                    Text("4.8").font(.system(size: isPad ? 48 : 38, weight: .bold))
                    HStack(spacing: 2) {
                        ForEach(0..<5) { i in
                            Image(systemName: i < 4 ? "star.fill" : "star.leadinghalf.filled")
                                .foregroundColor(.orange)
                                .font(.system(size: isPad ? 14 : 11))
                        }
                    }
                    Text("2,341 reviews")
                        .font(.system(size: isPad ? 13 : 11)).foregroundColor(.gray)
                }

                VStack(spacing: 6) {
                    ForEach((1...5).reversed(), id: \.self) { star in
                        HStack(spacing: 8) {
                            Text("\(star)")
                                .font(.system(size: isPad ? 13 : 11))
                                .foregroundColor(.gray).frame(width: 12)
                            Image(systemName: "star.fill")
                                .foregroundColor(.orange)
                                .font(.system(size: isPad ? 11 : 9))
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4).fill(Color.gray.opacity(0.15))
                                    RoundedRectangle(cornerRadius: 4).fill(Color("AppGreenColor"))
                                        .frame(width: geo.size.width * 0.85)
                                }
                            }
                            .frame(height: 8)
                            Text("85%")
                                .font(.system(size: isPad ? 12 : 10))
                                .foregroundColor(.gray).frame(width: 32)
                        }
                    }
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(0..<3) { _ in ReviewCard(isPad: isPad) }
                }
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 18).fill(Color.white))
        .shadow(color: .black.opacity(0.06), radius: 6, y: 3)
    }
}
