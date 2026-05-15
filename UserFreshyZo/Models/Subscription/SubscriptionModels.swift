//
//  SubscriptionModels.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 30/03/26.
//

import Foundation

// MARK: - Delivery Frequency

enum DeliveryFrequency: String, CaseIterable, Identifiable {
    case altDays = "Daily"
    case weekly  = "Weekly"
    case offers   = "Offers"

    var id: String { rawValue }
}

// MARK: - Alt Day Interval

enum AltDayOption: String, CaseIterable, Identifiable {
    case everyDay       = "Every Day"
    case everyAlternate = "Every Alternate Day"
    case every2Days     = "Every 2 Days"
    case every3Days     = "Every 3 Days"

    var id: String { rawValue }

    var index: Int {
        switch self {
        case .everyDay:       return 0
        case .everyAlternate: return 1
        case .every2Days:     return 2
        case .every3Days:     return 3
        }
    }

    var deliveriesPerMonth: Double {
        return 30.0 / Double(index + 1)
    }
}

// MARK: - Weekly Day State

struct WeeklyDayState: Identifiable, Equatable {
    let id: String
    var isOn: Bool
    var qty: Int

    static let defaultOrder = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    static func defaults() -> [WeeklyDayState] {
        defaultOrder.map { WeeklyDayState(id: $0, isOn: true, qty: 1) }
    }
}

// MARK: - Subscription UI State

struct SubscriptionUiState: Equatable {

    var selectedFrequency: DeliveryFrequency = .altDays
    var altDayOption:      AltDayOption      = .everyAlternate
    var weeklyDayStates:   [WeeklyDayState]  = WeeklyDayState.defaults()
    var simpleQty:         Int               = 1

    var startDate:          Date   = SubscriptionUiState.defaultStartDate()
    var startDateFormatted: String = ""
    var deliveryBeginsText: String = ""

    var basePrice:            Int    = 0
    var mrpPrice:             Int    = 0
    var packetsPerDelivery:   Int    = 0
    var deliveriesPerMonth:   Int    = 0
    var subtotalMrp:          Double = 0
    var productDiscount:      Double = 0
    var subscriptionDiscount: Double = 0
    var totalMonthly:         Double = 0
    var perDeliveryAvg:       Double = 0
    var perPacketAvg:         Double = 0

    var totalPriceText: String = "Subscribe Now"
    var summaryLine:    String = ""
    var daySummaryText: String = ""

    static func defaultStartDate() -> Date {
        let now  = Date()
        let hour = Calendar.current.component(.hour, from: now)
        if hour >= 9 {
            return Calendar.current.date(byAdding: .day, value: 1, to: now) ?? now
        }
        return now
    }

    var totalWeeklyPackets: Int {
        weeklyDayStates.filter(\.isOn).reduce(0) { $0 + $1.qty }
    }

    var activeDaysCount: Int {
        weeklyDayStates.filter(\.isOn).count
    }
}

// MARK: - Subscription Request (sent to API)

struct SubscriptionRequest: Codable {
    let productId:          String
    let productName:        String
    let basePrice:          Int
    let frequency:          String
    let altDayOption:       String?
    let weeklyDays:         [WeeklyDayRequest]?
    let simpleQty:          Int?
    let startDate:          String
    let totalMonthly:       Double
    let deliveriesPerMonth: Int
    let totalPackets:       Int
}

struct WeeklyDayRequest: Codable {
    let day: String
    let qty: Int
}

// MARK: - Subscription Response (from API)

struct SubscriptionResponse: Codable {
    let success:        Bool
    let message:        String
    let subscriptionId: String?
}
