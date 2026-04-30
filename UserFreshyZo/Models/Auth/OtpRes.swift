//
//  OtpRes.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 25/04/26.
//

import Foundation
struct OtpRes: Codable {
    let status: Bool
    let message: String
    let data: EmptyData
}

// Since data is an empty array, define a placeholder
struct EmptyData: Codable {}
