//
//  SubscriptionComponents.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 30/03/26.
//

// MARK: - SubscriptionComponents.swift
// Reusable sub-views — keep SubscriptionView lean

import SwiftUI

// MARK: - Stepper Button (reusable pill stepper)

struct PillStepperView: View {
    let value: Int
    let min: Int
    let max: Int
    let onIncrease: () -> Void
    let onDecrease: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Button(action: onDecrease) {
                Text("—")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(value <= min
                                     ? Color.gray.opacity(0.35)
                                     : Color("AppGreenColor"))
                    .frame(width: 32, height: 32)
            }
            .disabled(value <= min)

            Text("\(value)")
                .font(.system(size: 15, weight: .bold))
                .frame(minWidth: 22)
                .multilineTextAlignment(.center)

            Button(action: onIncrease) {
                Text("+")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(value >= max
                                     ? Color.gray.opacity(0.35)
                                     : Color("AppGreenColor"))
                    .frame(width: 32, height: 32)
            }
            .disabled(value >= max)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(Color("AppGreenColor").opacity(0.10))
        .cornerRadius(50)
        .overlay(
            RoundedRectangle(cornerRadius: 50)
                .stroke(Color("AppGreenColor").opacity(0.25), lineWidth: 1)
        )
    }
}

// MARK: - Section Header Label

struct SectionHeaderLabel: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: 11, weight: .semibold))
            .foregroundColor(.gray)
            .tracking(1)
    }
}

// MARK: - Card Container

struct CardContainer<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            content
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }
}

// MARK: - Frequency Selector Card

struct FrequencySelectorCard: View {
    let selectedFrequency: DeliveryFrequency
    let onSelect: (DeliveryFrequency) -> Void
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {
        CardContainer {
            SectionHeaderLabel(title: "DELIVERY FREQUENCY")

            HStack(spacing: 0) {
                ForEach(DeliveryFrequency.allCases) { tab in
                    Button(action: { onSelect(tab) }) {
                        Text(tab.rawValue)
                            .font(.system(size: isPad ? 15 : 13, weight: .semibold))
                            .foregroundColor(selectedFrequency == tab
                                             ? Color("AppGreenColor")
                                             : .gray)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(
                                        selectedFrequency == tab
                                            ? Color("AppGreenColor")
                                            : Color.gray.opacity(0.25),
                                        lineWidth: 1.5
                                    )
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(selectedFrequency == tab
                                                  ? Color("AppGreenColor").opacity(0.07)
                                                  : Color.clear)
                                    )
                            )
                    }
                    .buttonStyle(.plain)
                    .padding(3)
                }
            }
        }
    }
}

// MARK: - Alt Day Options Card

struct AltDayOptionsCard: View {
    let selected: AltDayOption
    let onSelect: (AltDayOption) -> Void
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {
        CardContainer {
            SectionHeaderLabel(title: "DELIVER")

            ForEach(AltDayOption.allCases) { option in
                Button(action: { onSelect(option) }) {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .stroke(selected == option
                                        ? Color("AppGreenColor")
                                        : Color.gray.opacity(0.35),
                                        lineWidth: 2)
                                .frame(width: 22, height: 22)
                            if selected == option {
                                Circle()
                                    .fill(Color("AppGreenColor"))
                                    .frame(width: 12, height: 12)
                            }
                        }
                        Text(option.rawValue)
                            .font(.system(size: isPad ? 16 : 14))
                            .foregroundColor(.primary)
                        Spacer()
                    }
                }
                .buttonStyle(.plain)

                if option != AltDayOption.allCases.last {
                    Divider()
                }
            }
        }
    }
}

// MARK: - Simple Quantity Card

struct SimpleQuantityCard: View {
    let qty: Int
    let summaryLine: String
    let onIncrease: () -> Void
    let onDecrease: () -> Void
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {
        CardContainer {
            SectionHeaderLabel(title: "QUANTITY")

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Packets per delivery")
                        .font(.system(size: isPad ? 16 : 15, weight: .semibold))
                    Text(summaryLine)
                        .font(.system(size: isPad ? 13 : 11))
                        .foregroundColor(.gray)
                }
                Spacer()
                PillStepperView(
                    value: qty, min: 2, max: 10,
                    onIncrease: onIncrease,
                    onDecrease: onDecrease
                )
            }
        }
    }
}

// MARK: - Weekly Day Row

struct WeeklyDayRow: View {
    let day: WeeklyDayState
    let pricePerUnit: Double
    let onToggle: () -> Void
    let onIncrease: () -> Void
    let onDecrease: () -> Void
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {
        HStack(spacing: 12) {
            // Toggle (tap the check icon to toggle on/off)
            Button(action: onToggle) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(day.isOn ? Color("AppGreenColor") : Color.gray.opacity(0.15))
                        .frame(width: 36, height: 36)
                    if day.isOn {
                        Image(systemName: "checkmark")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .buttonStyle(.plain)

            Text(day.id)
                .font(.system(size: isPad ? 16 : 14, weight: .medium))
                .foregroundColor(day.isOn ? .primary : .gray)

            Spacer()

            // Stepper (greyed out if day is off)
            PillStepperView(
                value: day.qty, min: 1, max: 10,
                onIncrease: onIncrease,
                onDecrease: onDecrease
            )
            .opacity(day.isOn ? 1 : 0.35)
            .disabled(!day.isOn)

            // Price for this day
            Text(day.isOn
                 ? "₹\(Int(pricePerUnit * Double(day.qty)))"
                 : "—")
                .font(.system(size: isPad ? 14 : 13, weight: .semibold))
                .foregroundColor(day.isOn ? Color("AppGreenColor") : .gray)
                .frame(width: 46, alignment: .trailing)
        }
    }
}

// MARK: - Weekly Days Card

struct WeeklyDaysCard: View {
    let days: [WeeklyDayState]
    let pricePerUnit: Double
    let onToggle: (String) -> Void
    let onIncrease: (String) -> Void
    let onDecrease: (String) -> Void

    var body: some View {
        CardContainer {
            SectionHeaderLabel(title: "SELECT DAYS & QUANTITY")

            ForEach(days) { day in
                WeeklyDayRow(
                    day: day,
                    pricePerUnit: pricePerUnit,
                    onToggle:   { onToggle(day.id) },
                    onIncrease: { onIncrease(day.id) },
                    onDecrease: { onDecrease(day.id) }
                )
                if day.id != days.last?.id {
                    Divider()
                }
            }
        }
    }
}

// MARK: - Start Date Card

struct StartDateCard: View {
    let formattedDate: String
    let deliveryBeginsText: String
    let onTap: () -> Void
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {
        CardContainer {
            SectionHeaderLabel(title: "START DATE")

            HStack(spacing: 12) {
                Image(systemName: "calendar")
                    .font(.system(size: 20))
                    .foregroundColor(.red)

                VStack(alignment: .leading, spacing: 2) {
                    Text(formattedDate)
                        .font(.system(size: isPad ? 16 : 15, weight: .semibold))
                    Text(deliveryBeginsText)
                        .font(.system(size: isPad ? 13 : 11))
                        .foregroundColor(.gray)
                }

                Spacer()

                Image(systemName: "pencil")
                    .font(.system(size: 16))
                    .foregroundColor(Color("AppGreenColor"))
            }
            .padding(12)
            .background(Color(UIColor.systemGroupedBackground))
            .cornerRadius(12)
        }
        .onTapGesture { onTap() }
    }
}

// MARK: - Price Summary Card

// MARK: - Price Summary Card

struct PriceSummaryCard: View {
    let state: SubscriptionUiState
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {
        CardContainer {
            // Bold dark header — matches screenshot
            Text("MONTHLY PRICE SUMMARY")
                .font(.system(size: isPad ? 13 : 11, weight: .bold))
                .foregroundColor(Color(UIColor.darkGray))
                .tracking(0.5)

            // Row 1: Price per packet
            summaryRow(
                label: "Price per packet",
                value: "₹\(state.basePrice)"
            )

            // Row 2: Total Packets
            summaryRow(
                label: "Total Packets",
                value: state.selectedFrequency == .weekly
                    ? "\(state.totalWeeklyPackets) pkt/week"
                    : "\(state.packetsPerDelivery) pkt"
            )

            // Row 3: Total Deliveries
            summaryRow(
                label: "Total Deliveries",
                value: "\(state.deliveriesPerMonth) days"
            )

            // Divider before total
            Divider()
                .padding(.vertical, 4)

            // Total row — light green rounded box
            HStack {
                Text("Total")
                    .font(.system(size: isPad ? 17 : 16, weight: .bold))
                    .foregroundColor(.primary)
                Spacer()
                Text("₹\(formatPrice(state.totalMonthly))")
                    .font(.system(size: isPad ? 22 : 20, weight: .bold))
                    .foregroundColor(Color("AppGreenColor"))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("AppGreenColor").opacity(0.08))
            )
        }
    }

    private func summaryRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: isPad ? 15 : 14))
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.system(size: isPad ? 16 : 15, weight: .bold))
                .foregroundColor(.primary)
        }
    }

    private func formatPrice(_ value: Double) -> String {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.maximumFractionDigits = 0
        return f.string(from: NSNumber(value: value)) ?? "\(Int(value))"
    }
}

// MARK: - Offer Banner

struct OfferBanner: View {
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "tag.fill")
                .font(.system(size: 24))
                .foregroundColor(.yellow)
                .padding(10)
                .background(Color.white.opacity(0.12))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text("Subscription Offer Applied")
                    .font(.system(size: isPad ? 15 : 13, weight: .bold))
                    .foregroundColor(.white)
                Text("Flat 25% off + Up to 30 packets FREE on 1st recharge")
                    .font(.system(size: isPad ? 13 : 11))
                    .foregroundColor(.white.opacity(0.85))
            }

            Spacer()

            Text("✓ Applied")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Color("AppGreenColor"))
                .padding(.horizontal, 10).padding(.vertical, 6)
                .background(Color.white)
                .cornerRadius(20)
        }
        .padding(14)
        .background(Color(red: 0.1, green: 0.12, blue: 0.15))
        .cornerRadius(16)
    }
}

// MARK: - Date Picker Sheet

struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    let minimumDate: Date
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            DatePicker(
                "Start Date",
                selection: $selectedDate,
                in: minimumDate...,
                displayedComponents: .date
            )
            .datePickerStyle(.wheel)
            .accentColor(Color("AppGreenColor"))
            .labelsHidden()
            .padding()
            .navigationTitle("Select Start Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .foregroundColor(Color("AppGreenColor"))
                }
            }
        }
    }
}


// MARK: - Subscription Success Popup

struct SubscriptionSuccessPopup: View {
    let onDone: () -> Void
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {
        ZStack {
            // Dim background
            Color.black.opacity(0.45)
                .ignoresSafeArea()

            // Popup card
            VStack(spacing: 0) {

                // ── Green top section ──────────────────────────────
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 80, height: 80)
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 52))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 28)

                    Text("Subscription Done!")
                        .font(.system(size: isPad ? 22 : 20, weight: .bold))
                        .foregroundColor(.white)

                    Text("Your subscription has been\nplaced successfully.")
                        .font(.system(size: isPad ? 15 : 13))
                        .foregroundColor(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 24)
                }
                .frame(maxWidth: .infinity)
                .background(Color("AppGreenColor"))

                // ── White bottom section ───────────────────────────
                VStack(spacing: 16) {

                    // Divider with icon
                    HStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 1)
                        Image(systemName: "leaf.fill")
                            .foregroundColor(Color("AppGreenColor"))
                            .font(.system(size: 14))
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 1)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                    Text("Fresh delivery starts from\nyour selected date 🥛")
                        .font(.system(size: isPad ? 14 : 13))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)

                    Button(action: onDone) {
                        Text("Go to Home")
                            .font(.system(size: isPad ? 17 : 15, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: isPad ? 50 : 44)
                            .background(Color("AppGreenColor"))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                }
                .background(Color.white)
            }
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .padding(.horizontal, isPad ? 60 : 32)
            .shadow(color: .black.opacity(0.15), radius: 20, y: 8)
        }
    }
}
