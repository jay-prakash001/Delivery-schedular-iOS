//
//  AddressModels.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 06/04/26.
//

import Foundation
import CoreLocation

// MARK: - Address Type

enum AddressType: String, CaseIterable, Identifiable, Codable {
    case home   = "Home"
    case work   = "Work"
    case other  = "Other"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .home:  return "house.fill"
        case .work:  return "briefcase.fill"
        case .other: return "mappin.circle.fill"
        }
    }
}

// MARK: - User Address

struct UserAddress: Identifiable, Equatable, Codable {
    let id:           String
    var name:         String
    var phone:        String
    var fullAddress:  String
    var latitude:     Double
    var longitude:    Double
    var addressType:  AddressType
    var isDefault:    Bool

    var coordinateText: String {
        guard latitude != 0 || longitude != 0 else { return "0.0, 0.0" }
        return String(format: "%.6f, %.6f", latitude, longitude)
    }
}

// MARK: - API: Fetch Addresses Response

struct FetchAddressesResponse: Codable {
    let success:   Bool
    let message:   String
    let addresses: [UserAddress]
}

// MARK: - API: Save / Update Address Request

struct SaveAddressRequest: Codable {
    let id:          String?      // nil = new, non-nil = update
    let name:        String
    let phone:       String
    let fullAddress: String
    let latitude:    Double
    let longitude:   Double
    let addressType: String
    let isDefault:   Bool
}

// MARK: - API: Delete Address Request

struct DeleteAddressRequest: Codable {
    let addressId: String
}

// MARK: - API: Generic Action Response

struct AddressActionResponse: Codable {
    let success: Bool
    let message: String
    let addressId: String?
}
