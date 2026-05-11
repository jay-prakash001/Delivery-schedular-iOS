//
//  RazorPayOrderReq.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 11/05/26.
//

import Foundation


struct RazorPayOrderReq : Codable{
 
    
    let mobile_no : String
    let amount  : String
    let coupon_code : String
}
