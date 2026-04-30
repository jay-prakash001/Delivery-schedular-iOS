//
//  UserSubscriptionViewModel.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 06/04/26.
//

import Foundation
import Combine

@MainActor
final class UserSubscriptionViewModel: ObservableObject {

    // MARK: - Published State

    @Published var subscriptions:         [UserSubscription] = []
    @Published var isLoading:             Bool               = false
    @Published var errorMessage:          String?            = nil

    // ── Cancel sheet state ────────────────────────────────────────────
    @Published var showCancelSheet:       Bool               = false
    @Published var subscriptionToCancel:  UserSubscription?  = nil
    @Published var selectedCancelReason:  CancelReason?      = nil
    @Published var showCancelSuccess:     Bool               = false

    // MARK: - Computed Lists

    var activeSubscriptions: [UserSubscription] {
        subscriptions.filter { $0.status == .active }
    }

    var pausedSubscriptions: [UserSubscription] {
        subscriptions.filter { $0.status == .paused }
    }

    var cancelledSubscriptions: [UserSubscription] {
        subscriptions.filter { $0.status == .cancelled }
    }

    // MARK: - Init

    init() {
        loadMockData()
        // Replace with: Task { await fetchSubscriptions() }
    }

    // MARK: - Fetch (mock — swap for real API)

    private func loadMockData() {
        subscriptions = [
            UserSubscription(
                id: "1",
                productName: "FreshyZo Cow Milk 1000 Ml",
                productImageUrl: nil,
                pricePerUnit: 60,
                delivery: "Everyday",
                startDate: "25 Feb 2026",
                endDate: "N/A",
                status: .active,
                cancelReason: nil
            ),
            UserSubscription(
                id: "2",
                productName: "FreshyZo Buffalo Milk 500 Ml",
                productImageUrl: nil,
                pricePerUnit: 55,
                delivery: "Alternate Day",
                startDate: "20 Feb 2026",
                endDate: "N/A",
                status: .active,
                cancelReason: nil
            ),
            UserSubscription(
                id: "3",
                productName: "FreshyZo Ghee 250g",
                productImageUrl: nil,
                pricePerUnit: 120,
                delivery: "Weekly",
                startDate: "10 Feb 2026",
                endDate: "Paused",
                status: .paused,
                cancelReason: nil
            ),
            UserSubscription(
                id: "4",
                productName: "FreshyZo Paneer 200g",
                productImageUrl: nil,
                pricePerUnit: 90,
                delivery: "Weekly",
                startDate: "1 Jan 2026",
                endDate: "Cancelled on 5 Mar 2026",
                status: .cancelled,
                cancelReason: "Too expensive"
            )
        ]
    }

    // ── When real API is ready, replace loadMockData() call with this: ─
    /*
    func fetchSubscriptions() async {
        isLoading = true
        defer { isLoading = false }
        do {
            guard let url = URL(string: "https://freshyzo.com/admin/Customer_App_Api/get_subscriptions") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            // request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let (data, _) = try await URLSession.shared.data(for: request)
            let response  = try JSONDecoder().decode(FetchSubscriptionsResponse.self, from: data)
            if response.success {
                subscriptions = response.subscriptions
            } else {
                errorMessage = response.message
            }
        } catch {
            errorMessage = "Failed to load subscriptions."
        }
    }
    */

    // MARK: - Pause

    func pause(subscription id: String) {
        guard let idx = subscriptions.firstIndex(where: { $0.id == id }) else { return }
        subscriptions[idx].status  = .paused
        subscriptions[idx].endDate = "Paused"

        // ── API call (uncomment when ready) ───────────────────────────
        /*
        Task {
            await callPauseResume(
                request: PauseResumeRequest(subscriptionId: id, action: "pause")
            )
        }
        */
    }

    // MARK: - Resume

    func resume(subscription id: String) {
        guard let idx = subscriptions.firstIndex(where: { $0.id == id }) else { return }
        subscriptions[idx].status  = .active
        subscriptions[idx].endDate = "N/A"

        // ── API call (uncomment when ready) ───────────────────────────
        /*
        Task {
            await callPauseResume(
                request: PauseResumeRequest(subscriptionId: id, action: "resume")
            )
        }
        */
    }

    // MARK: - Initiate Cancel (opens sheet)

    func initiateCancellation(of subscription: UserSubscription) {
        selectedCancelReason = nil
        subscriptionToCancel = subscription
        showCancelSheet      = true
    }

    // MARK: - Confirm Cancel

    func confirmCancellation() {
        guard
            let sub    = subscriptionToCancel,
            let reason = selectedCancelReason,
            let idx    = subscriptions.firstIndex(where: { $0.id == sub.id })
        else { return }

        let fmt        = DateFormatter()
        fmt.dateFormat = "d MMM yyyy"
        let dateStr    = fmt.string(from: Date())

        // Optimistic local update
        subscriptions[idx].status       = .cancelled
        subscriptions[idx].endDate      = "Cancelled on \(dateStr)"
        subscriptions[idx].cancelReason = reason.rawValue

        showCancelSheet      = false
        subscriptionToCancel = nil
        selectedCancelReason = nil
        showCancelSuccess    = true

        // ── API call (uncomment when ready) ───────────────────────────
        /*
        Task {
            await callCancelSubscription(
                request: CancelSubscriptionRequest(
                    subscriptionId: sub.id,
                    reason: reason.rawValue
                )
            )
        }
        */

        // Auto-dismiss toast
        Task {
            try? await Task.sleep(nanoseconds: 2_500_000_000)
            showCancelSuccess = false
        }
    }

    // MARK: - Dismiss Cancel Sheet

    func dismissCancelSheet() {
        showCancelSheet      = false
        subscriptionToCancel = nil
        selectedCancelReason = nil
    }

    // MARK: - Private API Helpers (ready to uncomment)

    /*
    private func callPauseResume(request: PauseResumeRequest) async {
        do {
            guard let url = URL(string: "https://freshyzo.com/admin/Customer_App_Api/pause_resume_subscription") else { return }
            var urlRequest        = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody   = try JSONEncoder().encode(request)
            let (data, _)         = try await URLSession.shared.data(for: urlRequest)
            let response          = try JSONDecoder().decode(SubscriptionActionResponse.self, from: data)
            if !response.success { errorMessage = response.message }
        } catch {
            errorMessage = "Action failed. Please try again."
        }
    }

    private func callCancelSubscription(request: CancelSubscriptionRequest) async {
        do {
            guard let url = URL(string: "https://freshyzo.com/admin/Customer_App_Api/cancel_subscription") else { return }
            var urlRequest        = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody   = try JSONEncoder().encode(request)
            let (data, _)         = try await URLSession.shared.data(for: urlRequest)
            let response          = try JSONDecoder().decode(SubscriptionActionResponse.self, from: data)
            if !response.success { errorMessage = response.message }
        } catch {
            errorMessage = "Cancellation failed. Please try again."
        }
    }
    */
}
