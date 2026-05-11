//
//  GetTrialRequest.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 11/05/26.
//


import Foundation

struct GetTrialRequest: Codable {
    let productId: String
    let startOn: String
    let trialDays: String

    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case startOn = "start_on"
        case trialDays = "trial_days"
    }
}