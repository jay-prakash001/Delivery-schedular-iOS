//
//  ProductViewModel.swift
//  UserFreshyZo
//

import Foundation
import Combine

@MainActor
class ProductViewModel: ObservableObject {
    
    @Published var products: [ProductFromApi] = []
    @Published var categories: [CategorySidebar] = []
    @Published var selectedCategoryId: String = ""
    @Published var groupedProducts: [String: [ProductFromApi]] = [:]
    
    
    @Published var productData: ProductData? = nil
    
    // ✅ Only set from tap — never from scroll
    @Published var tapRequestedCategory: String? = nil
    
    var categoryOrder = ["Milk", "Dahi", "khowa", "Paneer", "Ghee"]
    
    init(){
        getProductList()
    }
    
    func getProductList(){
        Task{
            do{
                let headers = ["Authorization" :UserDefaults.standard.string(forKey: "auth_token")!]
                let response : ProductResponse = try await APIService.shared.get(urlString: "https://www.freshyzo.com/admin/Customer_App_Api_V1/product_list" ,headers : headers
                                                                                 
                )
                
                
                if(response.status){
                    productData = response.data
                    products = response.data.productList
                    categoryOrder = response.data.subCategory.map{$0.productSubCategoryId}
                    self.groupedProducts = Dictionary(grouping: products) { $0.cleanCategory }
                }
                
                
                
                print("Product Res : \(response)")
                
                
                
            }
            catch{
                print("Product Res : \(error)")
                
                
            }
        }
    }
    
    func updateSubCategoryByCategoryId(_ value: String) {
        // Finding the first subcategory that matches the parent category ID
        if let match = productData?.subCategory.first(where: { $0.productCategoryId == value }) {
            selectedCategoryId = match.productSubCategoryId
        }
    }
    
    //    // MARK: - Fetch Products
    //    func fetchProducts() {
    //        guard let url = URL(string: "https://freshyzo.com/admin/Customer_App_Api/fetch_product") else { return }
    //
    //        Task {
    //            do {
    //                let (data, _) = try await URLSession.shared.data(from: url)
    //                let decoded = try JSONDecoder().decode([Product].self, from: data)
    //                self.products = decoded
    //                self.groupedProducts = Dictionary(grouping: decoded) { $0.cleanCategory }
    //                if self.selectedCategory.isEmpty {
    //                    self.selectedCategory = self.categoryOrder.first ?? ""
    //                }
    //            } catch {
    //                print("Fetch/Decode error:", error)
    //            }
    //        }
    //    }
    
    // MARK: - Search Products
    func searchProducts(with text: String) -> [ProductFromApi] {
        guard !text.isEmpty else { return [] }
        return products.filter {
            $0.productName.localizedCaseInsensitiveContains(text)
        }
    }
    
}
