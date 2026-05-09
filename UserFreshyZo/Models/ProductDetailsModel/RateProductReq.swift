//
//  RateProductReq.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 09/05/26.
//

import Foundation



struct RateProductReq: Encodable {
    let product_id: String
    let product_sub_category_id : String
    let product_rating : Int
    let feedback : String
}
