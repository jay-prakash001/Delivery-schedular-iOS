//
//  ProductRes.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 06/05/26.
//

import Foundation



// MARK: - Root Response
struct ProductResponse: Codable {
    let status: Bool
    let message: String
    let data: ProductData
}

// MARK: - Data Container
struct ProductData: Codable {
    let subCategory: [SubCategory]
    let productList: [ProductFromApi]

    enum CodingKeys: String, CodingKey {
        case subCategory = "sub_category"
        case productList = "product_list"
    }
}

// MARK: - SubCategory Model
struct SubCategory: Codable, Identifiable {
    var id: String { productSubCategoryId } // Identifiable conformance
    
    let productSubCategoryId: String
    let productCategoryId: String
    let productSubCategoryName: String
    let productCategoryImage: String

    enum CodingKeys: String, CodingKey {
        case productSubCategoryId = "product_sub_category_id"
        case productCategoryId = "product_category_id"
        case productSubCategoryName = "product_sub_category_name"
        case productCategoryImage = "product_category_image"
    }
}




// MARK: - Product Model (Unified)

struct ProductFromApi: Codable, Identifiable {
    var id: String { productId }
    
    // MARK: - Guaranteed Fields (In both List & Detail JSON)
    let productId: String
    let productSubCategoryId: String
    let productName: String
    let shortDesc: String
    let unit: String
    let productPrice: String
    let dairyMrp: String
    let subscription: String

    // MARK: - List Specific Fields (Optional)
    // These are missing in the Detail API 'product_details' object
    let productCategoryId: String?
    let dairyProductImage: String?
    let nutriVal: String?
    let productCategoryName: String?
    let productSubCategoryName: String?

    // MARK: - Detail Specific Fields (Optional)
    // These are missing in the List API 'product_list' object
    var description: String?
    var descTag: String?
    var productAssets: [ProductAsset]?
    var productFaq: [ProductFAQ]?
    var review: ReviewContainer?

    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case productCategoryId = "product_category_id"
        case productSubCategoryId = "product_sub_category_id"
        case productName = "product_name"
        case dairyProductImage = "dairy_product_image"
        case shortDesc = "short_desc"
        case nutriVal = "nutri_val"
        case unit
        case productPrice = "product_price"
        case dairyMrp = "dairy_mrp"
        case subscription
        case productCategoryName = "product_category_name"
        case productSubCategoryName = "product_sub_category_name"
        case description, review
        case descTag = "desc_tag"
        case productAssets = "product_assets"
        case productFaq = "product_faq"
    }
    
    
    // MARK: - Helpers
    var priceValue: Double {
        Double(productPrice) ?? 0.0
    }
    
    var tags: [String] {
        guard let data = descTag?.data(using: .utf8) else { return [] }
        return (try? JSONDecoder().decode([String].self, from: data)) ?? []
    }
}
//// MARK: - Product Model
//struct ProductFromApi: Codable, Identifiable {
//    var id: String { productId } // Identifiable conformance
//    
//    let productId: String
//    let productCategoryId: String
//    let productSubCategoryId: String
//    let productName: String
//    let dairyProductImage: String
//    let shortDesc: String
//    let nutriVal: String
//    let unit: String
//    let productPrice: String
//    let dairyMrp: String
//    let subscription: String
//    let productCategoryName: String
//    let productSubCategoryName: String
//
//    enum CodingKeys: String, CodingKey {
//        case productId = "product_id"
//        case productCategoryId = "product_category_id"
//        case productSubCategoryId = "product_sub_category_id"
//        case productName = "product_name"
//        case dairyProductImage = "dairy_product_image"
//        case shortDesc = "short_desc"
//        case nutriVal = "nutri_val"
//        case unit
//        case productPrice = "product_price"
//        case dairyMrp = "dairy_mrp"
//        case subscription
//        case productCategoryName = "product_category_name"
//        case productSubCategoryName = "product_sub_category_name"
//    }
//    
//    // Helper to get Price as Double
//    var priceValue: Double {
//        Double(productPrice) ?? 0.0
//    }
//}
