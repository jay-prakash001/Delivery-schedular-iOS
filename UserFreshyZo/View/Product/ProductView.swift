//
//  ProductView.swift
//  UserFreshyZo
//

import SwiftUI

struct ProductView: View {

    @Binding var selectedTab: Int

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
            
            
            
        }
    }
}

#Preview {
    ProductView(
        selectedTab: .constant(0),
//        selectedCategoryFromHome: "All Products"
    )
}
