//
//  TrialProduct.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 26/03/26.
//

import Foundation

struct TrialProduct: Identifiable, Codable {
    let id: Int
    let name: String
    let mrp: Float        // Original price
    let discount: Float   // Discount amount
    
    var payable: Float { mrp - discount }
}
 
