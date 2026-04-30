//
//  CancelReasonSheet.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 06/04/26.
//

import SwiftUI

// MARK: - CancelReasonSheet

struct CancelReasonSheet: View {

    @ObservedObject var vm: UserSubscriptionViewModel
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // ── Header ────────────────────────────────────────────────
            VStack(alignment: .leading, spacing: 4) {
                Text("Cancel Subscription")
                    .font(.system(size: isPad ? 20 : 18, weight: .bold))
                Text("Please select a reason for cancelling")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            .padding(.top, 24)
            .padding(.horizontal, 20)
            .padding(.bottom, 16)

            Divider()

            // ── Reason list ───────────────────────────────────────────
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(CancelReason.allCases) { reason in
                        CancelReasonRow(
                            reason: reason,
                            isSelected: vm.selectedCancelReason == reason,
                            onTap: {
                                withAnimation(.easeInOut(duration: 0.15)) {
                                    vm.selectedCancelReason = reason
                                }
                            }
                        )
                        if reason != CancelReason.allCases.last {
                            Divider().padding(.leading, 74)
                        }
                    }
                }
                .padding(.vertical, 8)
            }

            Divider()

            // ── Action buttons ────────────────────────────────────────
            HStack(spacing: 12) {
                Button(action: vm.dismissCancelSheet) {
                    Text("Keep subscription")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color(UIColor.systemGroupedBackground))
                        .cornerRadius(12)
                }

                Button(action: vm.confirmCancellation) {
                    Text("Cancel subscription")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(vm.selectedCancelReason == nil
                                    ? Color.red.opacity(0.4)
                                    : Color.red)
                        .cornerRadius(12)
                }
                .disabled(vm.selectedCancelReason == nil)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
}

// MARK: - CancelReasonRow

struct CancelReasonRow: View {

    let reason: CancelReason
    let isSelected: Bool
    let onTap: () -> Void
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                // Icon
                ZStack {
                    Circle()
                        .fill(isSelected
                              ? Color("AppGreenColor").opacity(0.12)
                              : Color(UIColor.systemGroupedBackground))
                        .frame(width: 40, height: 40)
                    Image(systemName: reason.icon)
                        .font(.system(size: 16))
                        .foregroundColor(isSelected ? Color("AppGreenColor") : .secondary)
                }

                Text(reason.rawValue)
                    .font(.system(size: isPad ? 16 : 14,
                                  weight: isSelected ? .semibold : .regular))
                    .foregroundColor(.primary)

                Spacer()

                // Radio
                ZStack {
                    Circle()
                        .stroke(isSelected
                                ? Color("AppGreenColor")
                                : Color.gray.opacity(0.35),
                                lineWidth: 2)
                        .frame(width: 22, height: 22)
                    if isSelected {
                        Circle()
                            .fill(Color("AppGreenColor"))
                            .frame(width: 12, height: 12)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CancelReasonSheet(vm: UserSubscriptionViewModel())
}
