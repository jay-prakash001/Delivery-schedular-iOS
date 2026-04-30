//
//  CartItem.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 19/03/26.
//

import Foundation

struct CartItem: Codable, Identifiable {
    let id: String
    var quantity: Int
    let name: String
    let price: Double
    let mrp: Double
    let image: String
    let variant: String?
}
