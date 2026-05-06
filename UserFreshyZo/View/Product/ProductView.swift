//
//  ProductView.swift
//  UserFreshyZo
//

import SwiftUI

struct ProductView: View {

    @Binding var selectedTab: Int
    let selectedCategoryFromHome: String

    @EnvironmentObject private var vm : ProductViewModel

    var body: some View {
        VStack(spacing: 0) {

            ProductHeaderView(selectedTab: $selectedTab)

            DeliveryBannerView()

            HStack(spacing: 0) {
                CategorySidebarView()
                ProductListView()
                    .frame(maxWidth: .infinity)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarHidden(true)
        .onAppear {
            
            
            
            
//            vm.fetchMockCategories()
//            vm.fetchProducts()
            // Map incoming category from Home to actual category name
            let mapped: String
            switch selectedCategoryFromHome {
            case "Milk Products":
                mapped = "Dahi"
            case "All Products", "":
                mapped = vm.categoryOrder.first ?? "Milk"
            default:
                mapped = selectedCategoryFromHome
            }
            vm.selectedCategory = mapped
        }
    }
}

#Preview {
    ProductView(
        selectedTab: .constant(0),
        selectedCategoryFromHome: "All Products"
    )
}
