//
//  RegisterNewCustomerReq.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 04/05/26.
//

import Foundation
struct RegisterNewCustomerReq: Encodable {
    let first_name: String
    let last_name: String
    let lat: String
    let lng: String
    let address: String
    let mobile_no: String

    enum CodingKeys: String, CodingKey {
        case first_name = "first_name"
        case last_name  = "last_name"
        case lat        = "lat"
        case lng        = "lng"
        case address    = "address"
        case mobile_no  = "mobile_no"
    }
}
