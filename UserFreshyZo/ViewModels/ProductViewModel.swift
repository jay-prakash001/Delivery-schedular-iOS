//
//  ProductViewModel.swift
//  UserFreshyZo
//

import Foundation
import Combine

@MainActor
class ProductViewModel: ObservableObject {

    @Published var products: [Product] = []
    @Published var categories: [CategorySidebar] = []
    @Published var selectedCategory: String = ""
    @Published var groupedProducts: [String: [Product]] = [:]

    // ✅ Only set from tap — never from scroll
    @Published var tapRequestedCategory: String? = nil

    let categoryOrder = ["Milk", "Dahi", "khowa", "Paneer", "Ghee"]

    // MARK: - Fetch Products
    func fetchProducts() {
        guard let url = URL(string: "https://freshyzo.com/admin/Customer_App_Api/fetch_product") else { return }

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoded = try JSONDecoder().decode([Product].self, from: data)
                self.products = decoded
                self.groupedProducts = Dictionary(grouping: decoded) { $0.cleanCategory }
                if self.selectedCategory.isEmpty {
                    self.selectedCategory = self.categoryOrder.first ?? ""
                }
            } catch {
                print("Fetch/Decode error:", error)
            }
        }
    }

    // MARK: - Search Products
    func searchProducts(with text: String) -> [Product] {
        guard !text.isEmpty else { return [] }
        return products.filter {
            $0.productName.localizedCaseInsensitiveContains(text)
        }
    }

    // MARK: - Fetch Categories
    func fetchMockCategories() {
        categories = [
            CategorySidebar(id: "1", name: "Milk",   image: "milk"),
            CategorySidebar(id: "2", name: "Dahi",   image: "dahi"),
            CategorySidebar(id: "3", name: "khowa",  image: "khowa"),
            CategorySidebar(id: "4", name: "Paneer", image: "paneer"),
            CategorySidebar(id: "5", name: "Ghee",   image: "ghee")
        ]
    }
}
