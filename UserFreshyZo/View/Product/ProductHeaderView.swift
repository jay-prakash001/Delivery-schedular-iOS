//
//  ProductHeaderView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 04/03/26.
//

import SwiftUI
struct ProductHeaderView: View {
    
    @Binding var selectedTab: Int
    @ObservedObject var vm: ProductViewModel

    var body: some View {
        let isPad = UIDevice.current.userInterfaceIdiom == .pad

        HStack {
            
            Button{
                selectedTab = 0
            }label:{
                Image(systemName: "arrow.left")
                    .font(.system(size: isPad ? 22 : 18, weight: .semibold))
                    .foregroundStyle(.white)
            }
           
            Text("Product Category")
                .foregroundColor(.white)
//                .font(.headline)
                .font(.system(size: isPad ? 22 : 18, weight: .semibold))
            
            Spacer()
            
            NavigationLink(destination: SearchProductsScreen(vm: vm)) {
                
                Image(systemName: "magnifyingglass")
                    .font(.system(size: isPad ? 18 : 14))
                    .foregroundColor(.white)
                    .padding(isPad ? 12 : 10)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, isPad ? 24 : 16)
        .padding(.vertical, isPad ? 16 : 10)
        .background(Color("AppGreenColor"))
    }
}
