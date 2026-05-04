//
//  ContentView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 21/02/26.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var vm = HomeViewModel()
    @Binding var selectedTab: Int
    @Binding var selectedCategory: String
    
    
    var body: some View {
        
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        
            VStack(spacing: 0) {
                HeaderView()

            
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    DateList(data : vm.calendar)
                        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                    VStack(spacing: isPad ? 40 : 30) {
                        BannerCarouselView(banners: vm.banners)
                            .padding(.top, 16) 
//                        CategoryGridView(categories: vm.categories)
                        CategoryGridView(categories: vm.categories) { category in
                            
                            selectedCategory = category.name   // ✅ set
                            selectedTab = 1                    // ✅ go to Product tab
                        }
                        MilkTestReportCard()
                        ComboOfferSection(offers: vm.offers)
                        ArticleSection(articles: vm.articles)
                        SuggestionView()
                        BottomBrandingView()   
                    }
                    .padding(.horizontal, isPad ? 20 : 16)
                    .padding(.bottom, 30)
                }
            }
            .background(Color(.systemGroupedBackground))
       
    }
}

//#Preview {
//    HomeView()
//}
