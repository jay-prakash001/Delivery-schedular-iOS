//
//  UserSubscriptionModels.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 06/04/26.
//

import Foundation

// MARK: - User Subscription Status

enum UserSubscriptionStatus: String, Codable {
    case active    = "active"
    case paused    = "paused"
    case cancelled = "cancelled"
}

// MARK: - Cancel Reason

enum CancelReason: String, CaseIterable, Identifiable, Codable {
    case notNeeded  = "No longer needed"
    case expensive  = "Too expensive"
    case quality    = "Quality not satisfactory"
    case switching  = "Switching to another brand"
    case temporary  = "Taking a break temporarily"
    case other      = "Other reason"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .notNeeded:  return "xmark.circle"
        case .expensive:  return "indianrupeesign.circle"
        case .quality:    return "star.slash"
        case .switching:  return "arrow.left.arrow.right"
        case .temporary:  return "pause.circle"
        case .other:      return "ellipsis.circle"
        }
    }
}

// MARK: - User Subscription (fetched from API / shown in list)

struct UserSubscription: Identifiable, Equatable, Codable {
    let id:             String
    let productName:    String
    let productImageUrl: String?
    let pricePerUnit:   Int
    let delivery:       String
    let startDate:      String
    var endDate:        String
    var status:         UserSubscriptionStatus
    var cancelReason:   String?
}

// MARK: - API: Fetch Subscriptions Response

struct FetchSubscriptionsResponse: Codable {
    let success:       Bool
    let message:       String
    let subscriptions: [UserSubscription]
}

// MARK: - API: Pause / Resume Request

struct PauseResumeRequest: Codable {
    let subscriptionId: String
    let action:         String   // "pause" | "resume"
}

// MARK: - API: Cancel Request

struct CancelSubscriptionRequest: Codable {
    let subscriptionId: String
    let reason:         String
}

// MARK: - API: Generic Action Response

struct SubscriptionActionResponse: Codable {
    let success: Bool
    let message: String
}
