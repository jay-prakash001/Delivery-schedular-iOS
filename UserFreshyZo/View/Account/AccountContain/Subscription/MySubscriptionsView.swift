//
//  MySubscriptionsView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 06/04/26.
//

import SwiftUI

// MARK: - Tab Enum

enum SubscriptionTab: Int, CaseIterable {
    case active    = 0
    case paused    = 1
    case cancelled = 2

    var title: String {
        switch self {
        case .active:    return "Active"
        case .paused:    return "Pause"
        case .cancelled: return "Cancel"
        }
    }
}

// MARK: - MySubscriptionsView (Main — composes subviews only)

struct MySubscriptionsView: View {

    @StateObject private var vm = UserSubscriptionViewModel()
    @State private var selectedTab: SubscriptionTab = .active
    @Environment(\.dismiss) private var dismiss

    private let isPad = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                SubscriptionNavBar(onBack: { dismiss() })
                SubscriptionPageContent(
                    vm: vm,
                    selectedTab: $selectedTab,
                    isPad: isPad
                )
            }
            .background(Color(UIColor.systemGroupedBackground))

            // Toast
            if vm.showCancelSuccess {
                SubscriptionToastBanner()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(2)
            }
        }
        .navigationBarHidden(true)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: vm.showCancelSuccess)
        .sheet(isPresented: $vm.showCancelSheet) {
            CancelReasonSheet(vm: vm)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    NavigationStack {
        MySubscriptionsView()
    }
}
