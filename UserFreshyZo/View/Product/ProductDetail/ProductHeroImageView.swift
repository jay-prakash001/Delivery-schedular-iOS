//
//  heroImageSection.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 30/03/26.
//

//  ProductHeroImageView.swift
//  UserFreshyZo

import SwiftUI

struct ProductHeroImageView: View {
    let product: Product
    let isPad: Bool
    let currentImageIndex: Int
    let onBack: () -> Void
    let onShare: () -> Void

    var body: some View {
        ZStack(alignment: .top) {
            AsyncImage(url: product.imageURL) { img in
                img.resizable().scaledToFill()
            } placeholder: {
                Color(UIColor.systemGroupedBackground).overlay(ProgressView())
            }
            .frame(height: isPad ? 500 : 380)
            .clipped()

            HStack {
                Button(action: onBack) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(width: 40, height: 40)
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
                }
                Spacer()
                Button(action: onShare) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(width: 40, height: 40)
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 56)

//            VStack {
//                Spacer()
//                HStack(spacing: 6) {
//                    ForEach(0..<3, id: \.self) { i in
//                        Capsule()
//                            .fill(i == currentImageIndex
//                                  ? Color("AppGreenColor")
//                                  : Color.gray.opacity(0.4))
//                            .frame(width: i == currentImageIndex ? 20 : 8, height: 8)
//                    }
//                }
//                .padding(.bottom, 12)
//            }
        }
        .frame(height: isPad ? 500 : 380)
    }
}
