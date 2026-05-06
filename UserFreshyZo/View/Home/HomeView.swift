//
//  ContentView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 21/02/26.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm:  HomeViewModel
    @EnvironmentObject private var productViewModel : ProductViewModel
    @EnvironmentObject var mainRouter : MainRouter
    @Binding var selectedTab: Int
    @Binding var selectedCategory: String
    @State var selectedDate : Int? = nil

    
    var body: some View {
        
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        
        ZStack(alignment: .top) {
            
                VStack(spacing: 0) {
                    HeaderView(walletAmount: "\(vm.calendar.first?.remainingBalance ?? 0)")
                
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
//                        Divider().frame(height: 1).background(.black.opacity(0.1))
                        DateList(data : vm.calendar){ index in
                            withAnimation{
                                selectedDate = index

                            }
                        }
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 0)
                        
                        VStack(spacing: isPad ? 40 : 10)
                        {
                            BannerCarouselView(banners: vm.banners)
                            CategoryGridView(categories: vm.categories) { category in
                                
                                productViewModel.updateSubCategoryByCategoryId(  category.id)
                                selectedTab = 1
                            }
                            MilkTestReportCard()
//                            ComboOfferSection(offers: vm.offers)
                            ArticleSection(articles: vm.homeRes?.data.blogs ?? [])
                            SuggestionView()
                            BottomBrandingView()
                        }
                        .padding(.horizontal, isPad ? 20 : 16)
                        .padding(.bottom, 30)
                    }
                }
                
                .background(Color(.white))
            
            
            if let date = selectedDate {
                HomeCalendarDialog(calendarData: vm.calendar[date]) {
                    withAnimation{
                        selectedDate = nil

                    }
                }
            }
            if let toastString = vm.toastString {
                VStack {
                    Spacer()
                    ToastView(message: toastString)
                        .padding(.bottom, 20) // 👈 spacing from bottom
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity) // 👈 IMPORTANT
            }
            
        }.onTapGesture {
            withAnimation{
                selectedDate = nil

            }        }
       
    }
}

//#Preview {
//    HomeView()
//}
