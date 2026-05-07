//
//  CategoryGridView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 21/02/26.
//

import SwiftUI


struct CategoryGridView: View {
    let categories: [ProductCategory]
    var onCategoryTap: ((ProductCategory) -> Void)?

    var body: some View {
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        let cardWidth: CGFloat = isPad ? 200 : 100
        let cardHeight: CGFloat = isPad ? 150 : 120

        VStack(alignment: .center, spacing: 18) {
            Text("Shop By Category")
                .font(.system(size: isPad ? 24 : 12, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .center)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) { // Set spacing to 0 because Spacers will handle it
                    Spacer(minLength: 20) // Leading edge gap
                    
                    ForEach(Array(categories.enumerated()), id: \.element.id) { index, category in
                        CategoryCardView(
                            category: category,
                            index: index,
                            cardWidth: cardWidth,
                            cardHeight: cardHeight,
                            isPad: isPad
                        )
                        .onTapGesture {
                            onCategoryTap?(category)
                        }
                        
                        // This adds space between items AND after the last item
                        Spacer(minLength: 12)
                    }
                }
                // Fill the viewport width without using deprecated UIScreen.main
                .frame(maxWidth: .infinity)
            }
        }
    }
}
struct CategoryGridView000: View {

    let categories: [ProductCategory]
    var onCategoryTap: ((ProductCategory) -> Void)?

    var body: some View {
        // Compute once to help the type checker
        let isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
        let cardWidth: CGFloat = isPad ? 200 : 100
        let cardHeight: CGFloat = isPad ? 150 : 120

        VStack(alignment: .center, spacing: 18) {

            Text("Shop By Category")
                .font(.system(size: isPad ? 24 : 12, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .center)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 14) {
                    ForEach(Array(categories.enumerated()), id: \.element.id) { index, category in
                        CategoryCardView(
                            category: category,
                            index: index,
                            cardWidth: cardWidth,
                            cardHeight: cardHeight,
                            isPad: isPad
                        )
                        .onTapGesture {
                            onCategoryTap?(category)
                        }
                    }
                }
                // Ensure at least viewport width without UIScreen.main
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

private struct CategoryCardView: View {
    let category: ProductCategory
    let index: Int
    let cardWidth: CGFloat
    let cardHeight: CGFloat
    let isPad: Bool

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            CategoryImageView(
                imageString: category.image,
                fallbackIndex: index
            )
            .frame(width: cardWidth, height: cardHeight * 0.8)
            .clipped()

            Text(category.name)
                .font(.system(size: isPad ? 16 : 10, weight: .semibold))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .foregroundColor(.white).padding(4)
                .background(Color(.secondGreen))
        }
        .frame(width: cardWidth, height: cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .black.opacity(0.08), radius: 5, y: 3)
    }
}

private struct CategoryImageView: View {
    let imageString: String
    let fallbackIndex: Int

    var body: some View {
        Group {
            if let url = URL(string: imageString), url.scheme != nil {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure, .empty:
                        Color.gray.opacity(0.2)
                            .overlay(
                                // If these are asset names, replace with Image(...)
                                Image(systemName: fallbackIndex % 2 == 0 ? "category2" : "category3")
                                    .foregroundStyle(.gray)
                            )
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(imageString)
                    .resizable()
                    .scaledToFill()
            }
        }
    }
}

#Preview {
    CategoryGridView(categories: HomeViewModel().categories)
        .padding()
}
