//
//  Offer.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 21/02/26.
//

import Foundation

struct Offer: Identifiable, Codable{
    let id: Int
    let title: String
    let subtitle: String
    let price: Float
    let image: String
}
