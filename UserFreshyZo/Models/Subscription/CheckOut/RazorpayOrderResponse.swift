//
//  RazorpayOrderResponse.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 11/05/26.
//

import Foundation

import Foundation

// MARK: - Root Response
struct RazorpayOrderResponse: Codable {
    let status: Bool
    let message: String
    let data: RazorpayOrderData?
}

// MARK: - Data Layer
struct RazorpayOrderData: Codable {
    let status: Bool
    let orderId: String
    let amount: Int // Changed from String to Int to match JSON
    let currency: String
    let keyId: String
    let razorpayOrderDetails: RazorpayOrderDetails?

    enum CodingKeys: String, CodingKey {
        case status
        case orderId = "order_id"
        case amount
        case currency
        case keyId = "key_id"
        case razorpayOrderDetails = "razorpay_order_response"
    }
}

// MARK: - Detailed SDK Response
struct RazorpayOrderDetails: Codable {
    let id: String
    let entity: String
    let amount: Int
    let amountPaid: Int
    let amountDue: Int
    let currency: String
    let receipt: String?
    let status: String
    let attempts: Int
    let createdAt: Int
    let notes: RazorpayNotes?

    enum CodingKeys: String, CodingKey {
        case id, entity, amount, currency, receipt, status, attempts, notes
        case amountPaid = "amount_paid"
        case amountDue = "amount_due"
        case createdAt = "created_at"
    }
}

struct RazorpayNotes: Codable {
    let couponCode: String?
    let customerId: String?
    let mobileNo: String?

    enum CodingKeys: String, CodingKey {
        case couponCode = "coupon_code"
        case customerId = "customer_id"
        case mobileNo = "mobile_no"
    }
}

struct GetTrialResponse: Codable {
    let status: Bool
    let message: String
}
