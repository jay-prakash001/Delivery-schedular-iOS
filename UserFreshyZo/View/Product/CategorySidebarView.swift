//
//  CategorySidebarView.swift
//  UserFreshyZo
//

import SwiftUI

struct CategorySidebarView: View {
    
    @EnvironmentObject var vm: ProductViewModel
    private let isIPad = UIDevice.current.userInterfaceIdiom == .pad
    
    // Precompute a concrete array to help the type-checker
    private var categories: [SubCategory] {
        vm.productData?.subCategory ?? []
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack(spacing: isIPad ? 20 : 10) {
                    ForEach(categories) { category in
                        CategoryTileView(
                            category: category,
                            isSelected: vm.selectedCategoryId == category.productSubCategoryId,
                            isIPad: isIPad
                        )
                        .id(category.productSubCategoryName)
                        .onTapGesture {
                            // Highlight sidebar tile instantly
                            vm.selectedCategoryId = category.productSubCategoryId
                            // Tell ProductListView to scroll
                            vm.tapRequestedCategory = category.productSubCategoryId
                        }
                    }
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 8)
            }
            .frame(width: isIPad ? 160 : 90)
            .background(Color(.systemGroupedBackground))
            
            // Auto-scroll sidebar to keep active tile visible during finger scroll
            .onChange(of: vm.selectedCategoryId) { _, newValue in
                withAnimation(.easeInOut(duration: 0.25)) {
                    proxy.scrollTo(newValue, anchor: .center)
                }
            }
        }
    }
}

// MARK: - Category Tile
struct CategoryTileView: View {
    let category: SubCategory
    let isSelected: Bool
    let isIPad: Bool
    
    var body: some View {
        VStack(spacing: isIPad ? 10 : 6) {
            let urlString = category.productCategoryImage.isEmpty
            ? "https://freshyzo.com/admin/uploads/product_image/975021742984753b4d0221b.JPG"
            : category.productCategoryImage
            
            AsyncImage(url: URL(string: urlString)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: isIPad ? 80 : 38)
                    
                case .empty:
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: isIPad ? 80 : 38)
                        .overlay(ProgressView().scaleEffect(0.8))
                    
                case .failure, _:
                    placeholderView
                @unknown default:
                    placeholderView
                }
            }
            
            Text(category.productSubCategoryName)
                .font(.system(size: isIPad ? 16 : 11,
                              weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? .green : .gray)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .frame(width: isIPad ? 130 : 68, height: isIPad ? 140 : 76)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(isSelected ? Color.green.opacity(0.08) : Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(
                    isSelected ? Color.green : Color.gray.opacity(0.12),
                    lineWidth: isSelected ? 1.5 : 0.8
                )
        )
        .shadow(color: .black.opacity(isSelected ? 0.08 : 0.04),
                radius: isSelected ? 4 : 2, y: 2)
        .scaleEffect(isSelected ? 1.04 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
    
    
    @ViewBuilder
    private var placeholderView: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.15))
            .frame(height: isIPad ? 80 : 38)
            .overlay(
                Image(systemName: "photo")
                    .foregroundColor(.gray.opacity(0.4))
            )
    }
}
