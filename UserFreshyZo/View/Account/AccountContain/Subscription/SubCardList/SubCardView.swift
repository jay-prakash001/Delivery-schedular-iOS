//
//  SubCardView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 06/04/26.
//

import SwiftUI

// MARK: - SubCardView

struct SubCardView: View {

    let subscription: UserSubscription
    let tab: SubscriptionTab
    let onPause:  () -> Void
    let onResume: () -> Void
    let onCancel: () -> Void

    private let isPad = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // ── Header ────────────────────────────────────────────────
            HStack(alignment: .center, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color("AppGreenColor").opacity(0.1))
                        .frame(width: 54, height: 54)
                    Image(systemName: "drop.fill")
                        .font(.system(size: 22))
                        .foregroundColor(Color("AppGreenColor"))
                }
                Text(subscription.productName)
                    .font(.system(size: isPad ? 16 : 14, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                Spacer()
                statusBadge
            }
            .padding(14)

            Divider().padding(.horizontal, 14)

            // ── Info grid ─────────────────────────────────────────────
            VStack(spacing: 0) {
                HStack {
                    infoCell(label: "Price per unit", value: "₹\(subscription.pricePerUnit)")
                    Divider().frame(height: 36)
                    infoCell(label: "Delivery", value: subscription.delivery)
                }
                Divider()
                HStack {
                    infoCell(label: "Start date", value: subscription.startDate)
                    Divider().frame(height: 36)
                    infoCell(label: "End date",
                             value: subscription.endDate,
                             valueColor: endDateColor)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)

            // ── Cancel reason row ─────────────────────────────────────
            if tab == .cancelled, let reason = subscription.cancelReason {
                Divider().padding(.horizontal, 14)
                HStack(spacing: 6) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                    Text("Reason: \(reason)")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
            }

            // ── Action buttons ────────────────────────────────────────
            if tab != .cancelled {
                Divider().padding(.horizontal, 14)
                SubCardActionButtons(
                    tab: tab,
                    onPause: onPause,
                    onResume: onResume,
                    onCancel: onCancel
                )
                .padding(14)
            }
        }
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
        .shadow(color: .black.opacity(0.05), radius: 6, y: 2)
    }

    // MARK: - Status Badge

    private var statusBadge: some View {
        Group {
            switch subscription.status {
            case .active:
                statusLabel("ACTIVE",
                            bg: Color.green.opacity(0.12),
                            fg: Color(red: 0.1, green: 0.6, blue: 0.3))
            case .paused:
                statusLabel("PAUSED",
                            bg: Color.orange.opacity(0.12),
                            fg: .orange)
            case .cancelled:
                statusLabel("CANCELLED",
                            bg: Color.red.opacity(0.1),
                            fg: .red)
            }
        }
    }

    private func statusLabel(_ text: String, bg: Color, fg: Color) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .bold))
            .foregroundColor(fg)
            .padding(.horizontal, 9)
            .padding(.vertical, 4)
            .background(bg)
            .clipShape(Capsule())
    }

    // MARK: - Info Cell

    private func infoCell(label: String,
                          value: String,
                          valueColor: Color = .primary) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.secondary)
            Text(value)
                .font(.system(size: isPad ? 14 : 13, weight: .medium))
                .foregroundColor(valueColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 6)
    }

    private var endDateColor: Color {
        switch subscription.status {
        case .active:    return .primary
        case .paused:    return .orange
        case .cancelled: return .red
        }
    }
}

// MARK: - SubCardActionButtons

struct SubCardActionButtons: View {

    let tab: SubscriptionTab
    let onPause:  () -> Void
    let onResume: () -> Void
    let onCancel: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            if tab == .active {
                actionButton(
                    title: "Pause",
                    icon: "pause.fill",
                    fg: .orange,
                    bg: Color.orange.opacity(0.1),
                    border: Color.orange.opacity(0.4),
                    action: onPause
                )
            } else if tab == .paused {
                actionButton(
                    title: "Resume",
                    icon: "play.fill",
                    fg: Color("AppGreenColor"),
                    bg: Color("AppGreenColor").opacity(0.1),
                    border: Color("AppGreenColor").opacity(0.4),
                    action: onResume
                )
            }

            // Cancel button (same for both active and paused)
            actionButton(
                title: "Cancel",
                icon: "xmark",
                fg: .secondary,
                bg: Color(UIColor.systemGroupedBackground),
                border: Color.gray.opacity(0.25),
                action: onCancel
            )
        }
    }

    private func actionButton(title: String,
                               icon: String,
                               fg: Color,
                               bg: Color,
                               border: Color,
                               action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .font(.system(size: 13, weight: title == "Cancel" ? .medium : .semibold))
                .foregroundColor(fg)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(bg)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(border, lineWidth: 1)
                )
                .cornerRadius(10)
        }
    }
}
