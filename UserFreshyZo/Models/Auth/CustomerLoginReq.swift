//
//  CustomerLoginReq.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 27/04/26.
//

import Foundation

struct CustomerLoginReq : Encodable{
    let mobile_no : String
    let otp : String
}
