//
//  CategorySidebarView.swift
//  UserFreshyZo
//

import SwiftUI

struct CategorySidebarView: View {

    @ObservedObject var vm: ProductViewModel
    private let isIPad = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack(spacing: isIPad ? 20 : 10) {
                    ForEach(vm.categories) { category in
                        CategoryTileView(
                            category: category,
                            isSelected: vm.selectedCategory == category.name,
                            isIPad: isIPad
                        )
                        .id(category.name)
                        .onTapGesture {
                            // ✅ Set BOTH:
                            // selectedCategory → highlights sidebar tile instantly
                            // tapRequestedCategory → tells ProductListView to scroll
                            vm.selectedCategory = category.name
                            vm.tapRequestedCategory = category.name
                        }
                    }
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 8)
            }
            .frame(width: isIPad ? 160 : 90)
            .background(Color(.systemGroupedBackground))

            // Auto-scroll sidebar to keep active tile visible during finger scroll
            .onChange(of: vm.selectedCategory) { _, newValue in
                withAnimation(.easeInOut(duration: 0.25)) {
                    proxy.scrollTo(newValue, anchor: .center)
                }
            }
        }
    }
}

// MARK: - Category Tile
struct CategoryTileView: View {
    let category: CategorySidebar
    let isSelected: Bool
    let isIPad: Bool

    var body: some View {
        VStack(spacing: isIPad ? 10 : 6) {

            if UIImage(named: category.image) != nil {
                Image(category.image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: isIPad ? 80 : 38)
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.15))
                    .frame(height: isIPad ? 80 : 38)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray.opacity(0.4))
                    )
            }

            Text(category.name)
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
}
