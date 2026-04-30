//
//  SubscriptionPageContent.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 06/04/26.
//

import SwiftUI

// MARK: - SubscriptionPageContent

struct SubscriptionPageContent: View {

    @ObservedObject var vm: UserSubscriptionViewModel
    @Binding var selectedTab: SubscriptionTab
    let isPad: Bool

    var body: some View {
        VStack(spacing: 0) {
            SubTabBar(selectedTab: $selectedTab, vm: vm)

            TabView(selection: $selectedTab) {
                SubscriptionListPage(vm: vm, tab: .active, isPad: isPad)
                    .tag(SubscriptionTab.active)

                SubscriptionListPage(vm: vm, tab: .paused, isPad: isPad)
                    .tag(SubscriptionTab.paused)

                SubscriptionListPage(vm: vm, tab: .cancelled, isPad: isPad)
                    .tag(SubscriptionTab.cancelled)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            // ✅ No .animation() here — fights native page drag, causes jank
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - SubTabBar

struct SubTabBar: View {

    @Binding var selectedTab: SubscriptionTab
    @ObservedObject var vm: UserSubscriptionViewModel

    var body: some View {
        HStack(spacing: 0) {
            ForEach(SubscriptionTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 0) {
                        Spacer()
                        HStack(spacing: 6) {
                            Text(tab.title)
                                .font(.system(size: 15,
                                              weight: selectedTab == tab ? .semibold : .regular))
                                .foregroundColor(selectedTab == tab
                                                 ? Color("AppGreenColor") : .gray)

                            let count = badgeCount(for: tab)
                            if count > 0 {
                                Text("\(count)")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(minWidth: 18, minHeight: 18)
                                    .background(
                                        selectedTab == tab
                                            ? Color("AppGreenColor")
                                            : Color.gray.opacity(0.45)
                                    )
                                    .clipShape(Capsule())
                            }
                        }
                        Spacer()
                        // Active indicator
                        Rectangle()
                            .fill(selectedTab == tab ? Color("AppGreenColor") : Color.clear)
                            .frame(height: 2.5)
                    }
                    .frame(height: 52)
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(.plain)
            }
        }
        .background(Color.white)
        .overlay(
            Rectangle()
                .fill(Color.gray.opacity(0.15))
                .frame(height: 0.5),
            alignment: .bottom
        )
    }

    private func badgeCount(for tab: SubscriptionTab) -> Int {
        switch tab {
        case .active:    return vm.activeSubscriptions.count
        case .paused:    return vm.pausedSubscriptions.count
        case .cancelled: return 0
        }
    }
}

// MARK: - SubscriptionListPage (one page per tab)

struct SubscriptionListPage: View {

    @ObservedObject var vm: UserSubscriptionViewModel
    let tab: SubscriptionTab
    let isPad: Bool

    private var items: [UserSubscription] {
        switch tab {
        case .active:    return vm.activeSubscriptions
        case .paused:    return vm.pausedSubscriptions
        case .cancelled: return vm.cancelledSubscriptions
        }
    }

    var body: some View {
        if items.isEmpty {
            SubscriptionEmptyState(tab: tab)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(items) { sub in
                        SubCardView(
                            subscription: sub,
                            tab: tab,
                            onPause:  { vm.pause(subscription: sub.id) },
                            onResume: { vm.resume(subscription: sub.id) },
                            onCancel: { vm.initiateCancellation(of: sub) }
                        )
                        .padding(.horizontal, isPad ? 24 : 16)
                    }
                }
                .padding(.vertical, 16)
            }
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}


// MARK: - SubscriptionEmptyState

struct SubscriptionEmptyState: View {

    let tab: SubscriptionTab

    private var icon: String {
        switch tab {
        case .active:    return "bag"
        case .paused:    return "pause.circle"
        case .cancelled: return "xmark.circle"
        }
    }

    private var title: String {
        switch tab {
        case .active:    return "No active subscriptions"
        case .paused:    return "No paused subscriptions"
        case .cancelled: return "No cancelled subscriptions"
        }
    }

    private var subtitle: String {
        switch tab {
        case .active:    return "Your active deliveries will appear here."
        case .paused:    return "Subscriptions you pause will appear here."
        case .cancelled: return "Cancelled subscriptions will appear here."
        }
    }

    var body: some View {
        VStack(spacing: 14) {
            Spacer()
            Image(systemName: icon)
                .font(.system(size: 52))
                .foregroundColor(Color.gray.opacity(0.35))
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
            Text(subtitle)
                .font(.system(size: 13))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemGroupedBackground))
    }
}
