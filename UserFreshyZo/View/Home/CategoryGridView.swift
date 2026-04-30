//
//  CategoryGridView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 21/02/26.
//

import SwiftUI

struct CategoryGridView: View {

    let categories: [Category]
    var onCategoryTap: ((Category) -> Void)?

    var body: some View {

        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        let cardWidth: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 200 : 130
        let cardHeight: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 150 : 100


        VStack(spacing: 18) {

            Text("Shop By Category")
//                .font(.system(size: 14, weight: .semibold))
                .font(.system(size: isPad ? 24 : 16, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .center)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    
                    ForEach(categories) { category in
                        
                        ZStack(alignment: .topLeading) {
                            
                            Image(category.image)
                                .resizable()
                                .scaledToFill()
//                                .frame(width: 130, height: 100)
                                .frame(width: cardWidth, height: cardHeight)
                                .clipped()
                            
                            LinearGradient(
                                colors: [
                                    Color.black.opacity(0.4),
                                    Color.clear
                                ],
                                startPoint: .top,
                                endPoint: .center
                            )
//                            .frame(width: 130, height: 100)
                            .frame(width: cardWidth, height: cardHeight)


                            Text(category.name)
//                                .font(.system(size: 12, weight: .semibold))
                                .font(.system(size: isPad ? 16 : 12, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(10)
                        }
//                        .frame(width: 130,height: 100)
                        .frame(width: cardWidth, height: cardHeight)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(color: .black.opacity(0.08), radius: 5, y: 3)
                        .onTapGesture {
                            onCategoryTap?(category)
                        }
                    }
                }

            }
        }
    }
}

#Preview {
    CategoryGridView(categories: HomeViewModel().categories)
        .padding()
}
