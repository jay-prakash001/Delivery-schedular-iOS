//
//  Complaint.swift
//  UserFreshyZo
//
//  Created by Developer on 07/04/26.
//

import Foundation

// MARK: - Complaint Category
struct ComplaintCategory: Identifiable {
    let id: String
    let name: String
    let subtitle: String
    let icon: String
}

// MARK: - Complaint Issue Type (per category)
struct ComplaintIssueOption: Identifiable {
    let id: String
    let label: String
}

// MARK: - Submitted Complaint (maps to API response)
struct Complaint: Identifiable, Codable {
    let id: String
    let category: String
    let issueType: String
    let description: String
    let status: ComplaintStatus
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id             = "complaint_id"
        case category       = "complaint_category"
        case issueType      = "issue_type"
        case description    = "complaint_description"
        case status         = "complaint_status"
        case createdAt      = "created_at"
    }
}

// MARK: - Complaint Status
enum ComplaintStatus: String, Codable {
    case pending  = "pending"
    case approved = "approved"
    case resolved = "resolved"

    var displayText: String {
        switch self {
        case .pending:  return "Pending"
        case .approved: return "Approved"
        case .resolved: return "Resolved"
        }
    }
}

// MARK: - Submit Request Body (use when real API is ready)
struct ComplaintRequest: Codable {
    let category: String
    let issueType: String
    let description: String

    enum CodingKeys: String, CodingKey {
        case category    = "complaint_category"
        case issueType   = "issue_type"
        case description = "complaint_description"
    }
}
