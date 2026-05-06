//
//  ProductDetailsRes.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 06/05/26.
//

import Foundation



// MARK: - Root Response
struct ProductDetailResponse: Codable {
    let status: Bool
    let message: String
    let data: ProductDetailData
}

// MARK: - Data Container
struct ProductDetailData: Codable {
    let productDetails: [ProductDetail]
    let productAssets: [ProductAsset]
    let productFaq: [ProductFAQ]
    let review: ProductReviewContainer

    enum CodingKeys: String, CodingKey {
        case productDetails = "product_details"
        case productAssets = "product_assets"
        case productFaq = "product_faq"
        case review
    }
}

// MARK: - Product Detail
struct ProductDetail: Codable, Identifiable {
    var id: String { productId }
    
    let productId: String
    let productSubCategoryId: String
    let productName: String
    let shortDesc: String
    let description: String
    let unit: String
    let productPrice: String
    let dairyMrp: String
    let subscription: String

    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case productSubCategoryId = "product_sub_category_id"
        case productName = "product_name"
        case shortDesc = "short_desc"
        case description, unit
        case productPrice = "product_price"
        case dairyMrp = "dairy_mrp"
        case subscription
    }
}

// MARK: - Product Asset
struct ProductAsset: Codable, Hashable {
    let asset: String
    
    // Helper to check if asset is a video
    var isVideo: Bool {
        asset.lowercased().hasSuffix(".mp4") || asset.lowercased().hasSuffix(".mov")
    }
}

// MARK: - Product FAQ
struct ProductFAQ: Codable, Identifiable {
    var id: String { qus } // Using question as ID if no unique ID exists
    
    let qus: String
    let ans: String
}

// MARK: - Review Models
struct ProductReviewContainer: Codable {
    let customerBought: Bool
    let feedbacks: [ProductFeedback]

    enum CodingKeys: String, CodingKey {
        case customerBought = "customer_bought"
        case feedbacks
    }
}

struct ProductFeedback: Codable, Identifiable {
    var id: String { feedbackId }
    
    let feedbackId: String
    let customerId: String
    let productId: String
    let productSubCategoryId: String
    let productRating: String
    let serviceRating: String
    let feedback: String
    let timeStamp: String
    let feedbackStatus: String
    let customerName: String

    enum CodingKeys: String, CodingKey {
        case feedbackId = "feedback_id"
        case customerId = "customer_id"
        case productId = "product_id"
        case productSubCategoryId = "product_sub_category_id"
        case productRating = "product_rating"
        case serviceRating = "service_rating"
        case feedback
        case timeStamp = "time_stamp"
        case feedbackStatus = "feedback_status"
        case customerName = "customer_name"
    }
    
    // Helper to get rating as Double/Int
    var ratingValue: Int {
        Int(productRating) ?? 0
    }
}
