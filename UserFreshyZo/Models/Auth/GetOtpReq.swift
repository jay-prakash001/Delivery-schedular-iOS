//
//  GetOtpReq.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 25/04/26.
//

import Foundation

struct GetOtpReq: Encodable {
    let mobileNo: String
    let deviceType: String
    let deviceModel: String
    
    enum CodingKeys: String, CodingKey {
        case mobileNo = "mobile_no"
        case deviceType = "device_type"
        case deviceModel = "device_model"
    }
}
