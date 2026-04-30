//
//  SearchProductsScreen.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 09/03/26.
//
import SwiftUI

struct SearchProductsScreen: View {
    
    @ObservedObject var vm: ProductViewModel
    @State private var searchText = ""
    @Environment(\.dismiss) var dismiss
    @State private var searchHistory: [String] =
    UserDefaults.standard.stringArray(forKey: "search_history") ?? []
    
    let popularProducts = [
        PopularItem(name: "Milk", image: "milk"),
        PopularItem(name: "Dahi", image: "dahi"),
        PopularItem(name: "Paneer", image: "paneer"),
        PopularItem(name: "Ghee", image: "ghee"),
        PopularItem(name: "Khowa", image: "khowa")
    ]
    
    var filteredProducts: [Product] {
        vm.searchProducts(with: searchText)
    }
    
    var body: some View {
        
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        
        VStack(spacing:0){
            
            // GREEN HEADER
            VStack(alignment:.leading, spacing:16){
                
                // SEARCH BAR
                HStack(spacing:12){

                    Button{
                        dismiss()
                    }label:{
                        Image(systemName:"arrow.left")
                            .font(.system(size:18, weight:.semibold))
                            .foregroundColor(.white)
                            .frame(width: isPad ? 50 : 36, height: isPad ? 50 : 36)
                            .background(Color.white.opacity(0.25))
                            .clipShape(Circle())
                    }

                    HStack{

                        Image(systemName:"magnifyingglass")
                            .font(.system(size: isPad ? 22 : 16))
                            .foregroundColor(.gray)

                        TextField("Search for milk", text:$searchText)
                            .font(.system(size: isPad ? 20 : 16))
                            .onSubmit(saveSearch)

                        if !searchText.isEmpty{
                            Button{
                                searchText = ""
                            }label:{
                                Image(systemName:"xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.vertical, isPad ? 14 : 10)
                    .padding(.horizontal, isPad ? 18 : 12)
                    .background(Color.white)
                    .cornerRadius(25)
                }
                
                
                // POPULAR PRODUCTS TITLE
                Text("Popular Products")
                    .foregroundColor(.white)
                    .font(.system(size: isPad ? 24 : 18, weight: .semibold))
                
                
                // POPULAR PRODUCTS LIST
                ScrollView(.horizontal, showsIndicators:false){
                    
                    HStack(spacing:15){
                        
                        ForEach(popularProducts){ item in
                            
                            Button{
                                searchText = item.name
                                saveSearch()
                            }label:{
                                
                                VStack(spacing:8){
                                    
                                    Image(item.image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: isPad ? 70 : 50, height: isPad ? 70 : 50)
                                    
                                    Text(item.name)
                                        .font(.system(size: isPad ? 18 : 12))
                                        .foregroundColor(.white)
                                }
                                .frame(width: isPad ? 120 : 80, height: isPad ? 130 : 90)
                                .background(Color.white.opacity(0.15))
                                .cornerRadius(15)
                            }
                        }
                    }
                }
            }
            .padding()
            .background(Color("AppGreenColor"))
            
            
            // RECENT SEARCHES
            VStack(alignment:.leading){
                
                if searchText.isEmpty && !searchHistory.isEmpty{
                    HStack{
                        
                        Text("Recent Searches")
                            .font(.system(size: isPad ? 22 : 16, weight: .semibold))

                        Spacer()
                        
                        Button("Clear All"){
                            clearAllHistory()
                            
                        }
                        .foregroundColor(.red)
                        .font(.system(size: isPad ? 22 : 16))

                    }
                    
                    
                    // HISTORY LIST
                    ScrollView(.horizontal, showsIndicators:false){
                        
                        HStack{
                            
                            ForEach(searchHistory, id:\.self){ item in
                                
                                HStack{
                                    
                                    Image(systemName:"clock")
                                        .foregroundColor(.gray)
                                    
                                    Text(item)
                                    
                                    
                                    Spacer()
                                    
                                    Button{
                                        deleteHistoryItem(item)
                                    }label:{
                                        Image(systemName:"xmark.circle.fill")
                                            .foregroundColor(.red)
                                    }
                                }
                                .padding(.horizontal, isPad ? 18 : 12)
                                .padding(.vertical, isPad ? 10 : 6)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(20)
                                .onTapGesture {
                                       searchText = item
                                   }
                            }
                        }
                    }
                }
                
                // SEARCH RESULTS
                if !searchText.isEmpty {

                    if filteredProducts.isEmpty {

                        Spacer()

                        VStack(spacing:10) {

                            LottieView(name: "no_search")
                                .frame(width: isPad ? 300 : 180,
                                       height: isPad ? 300 : 180)

                            Text("No products found")
                                .foregroundColor(.gray)
                                .font(.system(size: isPad ? 20 : 16))
                        }
                        .padding(.top, 30)

                        Spacer()

                    } else {

                        ScrollView {

                            LazyVStack(spacing: 0) {

                                ForEach(filteredProducts) { product in
                                    ProductCardView(product: product)
                                        .padding(.bottom, isPad ? 24 : 16)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            loadSearchHistory()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    
    struct PopularItem: Identifiable{
        let id = UUID()
        let name:String
        let image:String
    }
    
    
    // SAVE SEARCH
    private func saveSearch(){
        
        guard !searchText.isEmpty else { return }
        
        if !searchHistory.contains(searchText){
            
            searchHistory.insert(searchText, at:0)
            searchHistory = Array(searchHistory.prefix(6))
            
            UserDefaults.standard.set(searchHistory, forKey:"search_history")
        }
    }
    
    
    // DELETE ONE
    private func deleteHistoryItem(_ item:String){
        
        searchHistory.removeAll{ $0 == item }
        UserDefaults.standard.set(searchHistory, forKey:"search_history")
    }
    
    
    // CLEAR ALL
    private func clearAllHistory(){
        
        searchHistory.removeAll()
        UserDefaults.standard.removeObject(forKey:"search_history")
    }
    
    private func loadSearchHistory() {
        searchHistory =
        UserDefaults.standard.stringArray(forKey: "search_history") ?? []
    }
}
