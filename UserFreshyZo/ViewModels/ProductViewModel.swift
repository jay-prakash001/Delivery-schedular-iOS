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
    
    
    @Published var selectedProductData : ProductDetailData? = nil
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
        // 1. Guard against nil or empty data early
        guard let subCategories = productData?.subCategory, !subCategories.isEmpty else {
            print("❌ Error: No subcategories available to search.")
            return
        }

//        print("ID Update Start - Current: \(selectedCategoryId), Input Category: \(value)")

        // 2. Locate the best match or provide a safe default
        // We use .first(where:) to find the specific category,
        // falling back to .first (the very first item in the array) if no match is found.
        let matchedSubCategory = subCategories.first { $0.productCategoryId == value } ?? subCategories.first
        
        // 3. Extract the ID (The force unwrap is safe here because of the guard check above)
        let newId = matchedSubCategory!.productSubCategoryId
        
        // 4. Update state variables
        self.selectedCategoryId = newId
        self.tapRequestedCategory = newId

        print("ID Update Complete - Result: \(selectedCategoryId)")
    }
    
    
    
    func fetchProductDetailsById(_ id : String){
        
        Task{
            
            
            do{
                let headers = ["Authorization" :UserDefaults.standard.string(forKey: "auth_token")!]
                let response : ProductDetailResponse = try await APIService.shared.post(urlString: "https://www.freshyzo.com/admin/Customer_App_Api_V1/product_details" ,headers : headers, body : ProductDetailsReq(product_id: id)
                                                                                 
                )
                
                print("product details \(response)")
                if(response.status){
                    
                    DispatchQueue.main.async {
                        self.selectedProductData = response.data
                    }
                }else{
                    selectedProductData = nil
                }
                
                
                
                
                
                
            }
            catch{
                print("Product details error : \(error)")
                selectedProductData = nil
                
            }
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
