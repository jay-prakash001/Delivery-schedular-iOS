//
//  RegisterNewCustomerRes.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 04/05/26.
//

import Foundation

struct RegisterNewCustomerRes: Codable {
    let data: RegisterNewCustomerData
    let message: String
    let status: Bool
}

struct RegisterNewCustomerData: Codable {
    let customerId: Int
    let deliveryAvailable: Bool
    let token: String?

    enum CodingKeys: String, CodingKey {
        case customerId        = "customer_id"
        case deliveryAvailable = "delivery_available"
        case token
    }
}
