//
//  SubscriptionViewModel.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 30/03/26.
//

import Foundation
import Combine

@MainActor
final class SubscriptionViewModel: ObservableObject {

    // ── Single published state ────────────────────────────────────────
    @Published private(set) var state = SubscriptionUiState()

    // ── API state ─────────────────────────────────────────────────────
    @Published var isLoading:    Bool    = false
    @Published var isSuccess:    Bool    = false
    @Published var errorMessage: String? = nil

    // ── Private price store ───────────────────────────────────────────
    private var basePrice: Int = 0
    private var mrpPrice:  Int = 0

    // MARK: - Init

    init() {
        rebuildState()
    }

    // MARK: - Setup

    func setup(basePrice: Int, mrpPrice: Int, initialQty: Int) {
        self.basePrice = basePrice
        self.mrpPrice  = mrpPrice
        var s = state
        s.simpleQty = max(initialQty, 2)
        state = s
        rebuildState()
    }

    // MARK: - Frequency

    func selectFrequency(_ freq: DeliveryFrequency) {
        var s = state
        s.selectedFrequency = freq
        if freq == .weekly {
            s.weeklyDayStates = s.weeklyDayStates.map { day in
                var d = day
                d.isOn = true
                if d.qty == 0 { d.qty = 1 }
                return d
            }
        }
        s.simpleQty = max(s.simpleQty, 2)
        state = s
        rebuildState()
    }

    // MARK: - Alt Day

    func selectAltDayOption(_ option: AltDayOption) {
        var s = state
        s.altDayOption = option
        state = s
        rebuildState()
    }

    // MARK: - Simple Quantity

    func increaseSimpleQty() {
        guard state.simpleQty < 10 else { return }
        var s = state
        s.simpleQty += 1
        state = s
        rebuildState()
    }

    func decreaseSimpleQty() {
        guard state.simpleQty > 2 else { return }
        var s = state
        s.simpleQty -= 1
        state = s
        rebuildState()
    }

    // MARK: - Weekly Days

    func toggleDay(id: String) {
        var s = state
        s.weeklyDayStates = s.weeklyDayStates.map { day in
            guard day.id == id else { return day }
            var d = day
            if d.isOn { d.isOn = false; d.qty = 0 }
            else      { d.isOn = true;  d.qty = 1 }
            return d
        }
        state = s
        rebuildState()
    }

    func increaseDayQty(id: String) {
        var s = state
        s.weeklyDayStates = s.weeklyDayStates.map { day in
            guard day.id == id, day.isOn, day.qty < 10 else { return day }
            var d = day; d.qty += 1; return d
        }
        state = s
        rebuildState()
    }

    func decreaseDayQty(id: String) {
        var s = state
        s.weeklyDayStates = s.weeklyDayStates.map { day in
            guard day.id == id, day.isOn, day.qty > 1 else { return day }
            var d = day; d.qty -= 1; return d
        }
        state = s
        rebuildState()
    }

    // MARK: - Date

    func updateStartDate(_ date: Date) {
        var s = state
        s.startDate = date
        state = s
        rebuildState()
    }

    // MARK: - Confirm Subscription

    func confirmSubscription(productId: String, productName: String) {
        let s = state

        let weeklyDays: [WeeklyDayRequest]? = s.selectedFrequency == .weekly
            ? s.weeklyDayStates.filter(\.isOn).map { WeeklyDayRequest(day: $0.id, qty: $0.qty) }
            : nil

        let totalPackets = s.selectedFrequency == .weekly
            ? s.totalWeeklyPackets * 4
            : s.simpleQty * s.deliveriesPerMonth

        let request = SubscriptionRequest(
            productId:          productId,
            productName:        productName,
            basePrice:          s.basePrice,
            frequency:          s.selectedFrequency.rawValue,
            altDayOption:       s.selectedFrequency == .altDays ? s.altDayOption.rawValue : nil,
            weeklyDays:         weeklyDays,
            simpleQty:          s.selectedFrequency != .weekly ? s.simpleQty : nil,
            startDate:          s.startDateFormatted,
            totalMonthly:       s.totalMonthly,
            deliveriesPerMonth: s.deliveriesPerMonth,
            totalPackets:       totalPackets
        )

        Task {
            await saveSubscription(request: request)
        }
    }

    // MARK: - API Call (mock now, real later)

    private func saveSubscription(request: SubscriptionRequest) async {
        isLoading    = true
        errorMessage = nil

        do {
            // ── MOCK: simulate network delay ──────────────────────────
            try await Task.sleep(nanoseconds: 1_500_000_000)

            // ── MOCK: simulate success response ───────────────────────
            let mockResponse = SubscriptionResponse(
                success:        true,
                message:        "Subscription saved successfully!",
                subscriptionId: "SUB-\(Int.random(in: 10000...99999))"
            )

            // ── When real API is ready, replace mock block above with: ─
            /*
            guard let url = URL(string: "https://freshyzo.com/admin/Customer_App_Api/save_subscription") else { return }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(request)
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let mockResponse = try JSONDecoder().decode(SubscriptionResponse.self, from: data)
            */

            if mockResponse.success {
                isSuccess = true
            } else {
                errorMessage = mockResponse.message
            }

        } catch {
            errorMessage = "Something went wrong. Please try again."
        }

        isLoading = false
    }

    // MARK: - Rebuild Derived State

    private func rebuildState() {
        var s = state

        // 1. Deliveries per month
        let deliveriesPerMonth: Int
        switch s.selectedFrequency {
        case .daily:   deliveriesPerMonth = 30
        case .altDays: deliveriesPerMonth = Int(s.altDayOption.deliveriesPerMonth)
        case .weekly:  deliveriesPerMonth = s.activeDaysCount * 4
        }

        // 2. Packets
        let packetsPerDelivery: Int
        let totalPacketsMonth:  Int
        if s.selectedFrequency == .weekly {
            packetsPerDelivery = s.totalWeeklyPackets
            totalPacketsMonth  = s.totalWeeklyPackets * 4
        } else {
            packetsPerDelivery = s.simpleQty
            totalPacketsMonth  = s.simpleQty * deliveriesPerMonth
        }

        // 3. Pricing — base price × packets only, no discount
        let totalMonthly         = Double(basePrice * totalPacketsMonth)
        let subtotalMrp          = Double(mrpPrice  * totalPacketsMonth)
        let productDiscount      = subtotalMrp - totalMonthly
        let subscriptionDiscount = 0.0
        let perDeliveryAvg       = deliveriesPerMonth > 0 ? totalMonthly / Double(deliveriesPerMonth) : 0
        let perPacketAvg         = totalPacketsMonth  > 0 ? totalMonthly / Double(totalPacketsMonth)  : 0

        // 4. Date formatting
        let dateFormatter      = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        let dayFormatter       = DateFormatter()
        dayFormatter.dateFormat = "EEEE"
        let formattedDate      = dateFormatter.string(from: s.startDate)
        let dayName            = dayFormatter.string(from: s.startDate)

        // 5. Summary text
        let summaryLine    = buildSummaryLine(state: s, deliveriesPerMonth: deliveriesPerMonth, totalMonthly: totalMonthly)
        let daySummaryText = buildDaySummary(state: s)

        // 6. Write back
        s.basePrice             = basePrice
        s.mrpPrice              = mrpPrice
        s.packetsPerDelivery    = packetsPerDelivery
        s.deliveriesPerMonth    = deliveriesPerMonth
        s.subtotalMrp           = subtotalMrp
        s.productDiscount       = productDiscount
        s.subscriptionDiscount  = subscriptionDiscount
        s.totalMonthly          = totalMonthly
        s.perDeliveryAvg        = perDeliveryAvg
        s.perPacketAvg          = perPacketAvg
        s.startDateFormatted    = formattedDate
        s.deliveryBeginsText    = "Delivery begins \(dayName)"
        s.summaryLine           = summaryLine
        s.daySummaryText        = daySummaryText
        s.totalPriceText        = "Subscribe Now"

        state = s
    }

    // MARK: - Text Builders

    private func buildSummaryLine(state: SubscriptionUiState,
                                  deliveriesPerMonth: Int,
                                  totalMonthly: Double) -> String {
        let qty  = state.simpleQty
        let unit = qty == 1 ? "packet" : "packets"

        switch state.selectedFrequency {
        case .daily:
            return "\(qty) \(unit) × daily = ~₹\(formatPrice(totalMonthly))/month"
        case .altDays:
            let intervalText: String
            switch state.altDayOption {
            case .everyDay:       intervalText = "every day"
            case .everyAlternate: intervalText = "alternate days"
            case .every2Days:     intervalText = "every 2 days"
            case .every3Days:     intervalText = "every 3 days"
            }
            return "\(qty) \(unit) × \(intervalText) = ~₹\(formatPrice(totalMonthly))/month"
        case .weekly:
            let total    = state.totalWeeklyPackets
            let days     = state.activeDaysCount
            let dayLabel = days == 1 ? "day" : "days"
            return "\(total) packets on \(days) \(dayLabel)/week = ~₹\(formatPrice(totalMonthly))/month"
        }
    }

    private func buildDaySummary(state: SubscriptionUiState) -> String {
        switch state.selectedFrequency {
        case .weekly, .altDays:
            let total = state.weeklyDayStates.filter(\.isOn).reduce(0) { $0 + $1.qty }
            let days  = state.activeDaysCount
            let label = days == 1 ? "day" : "days"
            return "\(total) packets on \(days) \(label)/cycle"
        default:
            return ""
        }
    }

    private func formatPrice(_ value: Double) -> String {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.maximumFractionDigits = 0
        return f.string(from: NSNumber(value: value)) ?? "\(Int(value))"
    }
}
