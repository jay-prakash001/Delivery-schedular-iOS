//
//  Banner.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 26/02/26.
//

import Foundation

struct Banner: Identifiable, Codable, Hashable {
    let id : Int
    let name : String
    let image : String
    let price : Float
    
    var trialProducts: [TrialProduct]?
}
