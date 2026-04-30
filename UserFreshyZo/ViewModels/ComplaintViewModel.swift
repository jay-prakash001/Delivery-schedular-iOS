//
//  ComplaintViewModel.swift
//  UserFreshyZo
//
//  Created by Developer on 07/04/26.
//

import Foundation
import Combine

@MainActor
class ComplaintViewModel: ObservableObject {

    // MARK: - Published State
    @Published var complaints: [Complaint] = []
    @Published var isSubmitting: Bool = false
    @Published var submitSuccess: Bool = false
    @Published var errorMessage: String? = nil

    // MARK: - Sheet State
    @Published var selectedCategory: ComplaintCategory? = nil
    @Published var selectedIssueType: ComplaintIssueOption? = nil
    @Published var descriptionText: String = ""

    // MARK: - Navigation
    @Published var showHistory: Bool = false

    // MARK: - Static Categories (matches your screenshots)
    let categories: [ComplaintCategory] = [
        ComplaintCategory(id: "1", name: "App Related Issue",      subtitle: "Issues with app or performance",    icon: "iphone"),
        ComplaintCategory(id: "2", name: "Product Related Issue",  subtitle: "Issues with FreshyZo products",     icon: "shippingbox"),
        ComplaintCategory(id: "3", name: "Recharge Related Issue", subtitle: "Failed recharge & payment issues",  icon: "indianrupeesign.circle"),
        ComplaintCategory(id: "4", name: "Delivery Related Issue", subtitle: "Issues with delivery or partner",   icon: "truck.box"),
        ComplaintCategory(id: "5", name: "Other Issue",            subtitle: "Any other issue you may have",      icon: "questionmark.circle")
    ]

    // MARK: - Issue Options per Category
    func issueOptions(for category: ComplaintCategory) -> [ComplaintIssueOption] {
        switch category.id {
        case "1": // App
            return [
                ComplaintIssueOption(id: "a1", label: "App crashing or freezing"),
                ComplaintIssueOption(id: "a2", label: "Login issues"),
                ComplaintIssueOption(id: "a3", label: "Slow performance"),
                ComplaintIssueOption(id: "a4", label: "Notification not working"),
                ComplaintIssueOption(id: "a5", label: "Other app issue")
            ]
        case "2": // Product
            return [
                ComplaintIssueOption(id: "p1", label: "Damaged Product"),
                ComplaintIssueOption(id: "p2", label: "Quality Issue"),
                ComplaintIssueOption(id: "p3", label: "Wrong Item"),
                ComplaintIssueOption(id: "p4", label: "Missing Item"),
                ComplaintIssueOption(id: "p5", label: "Expiry concern"),
                ComplaintIssueOption(id: "p6", label: "Other")
            ]
        case "3": // Recharge
            return [
                ComplaintIssueOption(id: "r1", label: "Amount deducted, not recharged"),
                ComplaintIssueOption(id: "r2", label: "Payment failed"),
                ComplaintIssueOption(id: "r3", label: "Wrong amount charged"),
                ComplaintIssueOption(id: "r4", label: "Refund not received"),
                ComplaintIssueOption(id: "r5", label: "Other")
            ]
        case "4": // Delivery
            return [
                ComplaintIssueOption(id: "d1", label: "Late Delivery"),
                ComplaintIssueOption(id: "d2", label: "Item not delivered"),
                ComplaintIssueOption(id: "d3", label: "Wrong address delivery"),
                ComplaintIssueOption(id: "d4", label: "Delivery partner issue"),
                ComplaintIssueOption(id: "d5", label: "Other")
            ]
        default: // Other
            return [
                ComplaintIssueOption(id: "o1", label: "Subscription issue"),
                ComplaintIssueOption(id: "o2", label: "Account related"),
                ComplaintIssueOption(id: "o3", label: "Feedback"),
                ComplaintIssueOption(id: "o4", label: "Feature request"),
                ComplaintIssueOption(id: "o5", label: "Other")
            ]
        }
    }

    // MARK: - Reset Sheet
    func resetSheet() {
        selectedIssueType = nil
        descriptionText = ""
        errorMessage = nil
    }

    // MARK: - Fetch Complaints (DUMMY — replace URL + parsing when API ready)
    func fetchComplaints() {
        // ─── DUMMY DATA ─────────────────────────────────────────────────────
        // When your real API is ready, replace this block with:
        //
        // guard let url = URL(string: "https://freshyzo.com/admin/Customer_App_Api/fetch_complaints") else { return }
        // Task {
        //     do {
        //         let (data, _) = try await URLSession.shared.data(from: url)
        //         let decoded = try JSONDecoder().decode([Complaint].self, from: data)
        //         self.complaints = decoded
        //     } catch {
        //         print("Fetch error:", error)
        //     }
        // }
        // ────────────────────────────────────────────────────────────────────

        self.complaints = [
            Complaint(
                id: "c001",
                category: "App Related Issue",
                issueType: "App crashing or freezing",
                description: "App closes when I try to recharge my wallet.",
                status: .pending,
                createdAt: "28 Oct 2025, 03:45 PM"
            ),
            Complaint(
                id: "c002",
                category: "Product Related Issue",
                issueType: "Quality Issue",
                description: "Milk was sour when delivered today morning.",
                status: .resolved,
                createdAt: "25 Oct 2025, 07:20 AM"
            ),
            Complaint(
                id: "c003",
                category: "Delivery Related Issue",
                issueType: "Late Delivery",
                description: "Delivery was delayed by 2 hours without any notice.",
                status: .resolved,
                createdAt: "20 Oct 2025, 09:15 AM"
            )
        ]
    }

    // MARK: - Submit Complaint (DUMMY — replace with real API call when ready)
    func submitComplaint() {
        guard let category = selectedCategory,
              let issueType = selectedIssueType,
              !descriptionText.trimmingCharacters(in: .whitespaces).isEmpty
        else { return }

        isSubmitting = true

        // ─── DUMMY SUBMIT ────────────────────────────────────────────────────
        // When your real API is ready, replace this Task with:
        //
        // Task {
        //     do {
        //         guard let url = URL(string: "https://freshyzo.com/admin/Customer_App_Api/submit_complaint") else { return }
        //         var request = URLRequest(url: url)
        //         request.httpMethod = "POST"
        //         request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //         let body = ComplaintRequest(
        //             category: category.name,
        //             issueType: issueType.label,
        //             description: descriptionText
        //         )
        //         request.httpBody = try JSONEncoder().encode(body)
        //         let (data, _) = try await URLSession.shared.data(for: request)
        //         let newComplaint = try JSONDecoder().decode(Complaint.self, from: data)
        //         self.complaints.insert(newComplaint, at: 0)
        //         self.isSubmitting = false
        //         self.submitSuccess = true
        //     } catch {
        //         self.isSubmitting = false
        //         self.errorMessage = error.localizedDescription
        //     }
        // }
        // ────────────────────────────────────────────────────────────────────

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy, hh:mm a"
            let dateString = formatter.string(from: Date())

            let newComplaint = Complaint(
                id: UUID().uuidString,
                category: category.name,
                issueType: issueType.label,
                description: self.descriptionText,
                status: .approved,
                createdAt: dateString
            )
            self.complaints.insert(newComplaint, at: 0)
            self.isSubmitting = false
            self.submitSuccess = true
            self.resetSheet()
        }
    }
}
