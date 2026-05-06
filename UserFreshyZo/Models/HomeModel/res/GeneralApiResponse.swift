//
//  GeneralApiResponse.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 06/05/26.
//

import Foundation


struct GeneralApiResponse: Codable {
    let status: Bool
    let message: String
    let data: EmptyGeneralData
}

struct EmptyGeneralData: Codable {
    // Empty object → keep it empty
}
