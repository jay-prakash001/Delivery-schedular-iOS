//
//  VerifyOtpRes.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 27/04/26.
//

import Foundation



struct VerifyOtpRes: Codable {
    let status: Bool
    let message: String
    let data: OtpData?
}

struct OtpData: Codable {
    let token: String?
}
