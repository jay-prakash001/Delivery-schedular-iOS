//
//  TrialResponse.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 09/05/26.
//


import Foundation

// MARK: - TrialResponse
struct TrialResponse: Codable {
    let status: Bool
    let message: String
    let data: TrialData
}

// MARK: - TrialData
struct TrialData: Codable {
    let heading: String
    let trialProductDetails: [TrialProductDetail]

    enum CodingKeys: String, CodingKey {
        case heading
        case trialProductDetails = "trial_product_details"
    }
}

// MARK: - TrialProductDetail
struct TrialProductDetail: Codable, Identifiable, Equatable, Hashable {
    // Using Identifiable makes it easy to use in SwiftUI ForEach
    var id: String { productId }
    
    let productName: String
    let productImage: String
    let productId: String
    let amount: String
    let couponCode: String
    let days: String

    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case productImage = "product_image"
        case productId = "product_id"
        case amount
        case couponCode = "coupon_code"
        case days
    }
}
