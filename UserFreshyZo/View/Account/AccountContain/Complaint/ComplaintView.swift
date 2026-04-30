//
//  ComplaintView.swift
//  UserFreshyZo
//
//  Created by Developer on 07/04/26.
//

import SwiftUI

// MARK: - Main Complaint View
struct ComplaintView: View {

    @StateObject private var vm = ComplaintViewModel()
    @Environment(\.dismiss) var dismiss   // 👈 IMPORTANT

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {

                // 👇 Your Custom Navbar
                ComplaintNavBar(onBack: {
                    dismiss()   // 👈 back action
                })

                if vm.showHistory {
                    ComplaintHistoryView(vm: vm)
                } else {
                    ComplaintCategoryListView(vm: vm)
                }
            }
        }
        .navigationBarHidden(true) // ✅ hide default bar
        .sheet(item: $vm.selectedCategory) { category in
            ComplaintBottomSheetView(vm: vm, category: category)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .onAppear {
            vm.fetchComplaints()
        }
    }
}

// MARK: - Header View
struct ComplaintHeaderView: View {
    var body: some View {
        HStack {
            // Back button placeholder (wire to your navigation as needed)
            Button {
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
            }

            Text("Complaints Assistance")
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.white)

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color(hex: "#2e7d52"))
    }
}

// MARK: - Category List View
struct ComplaintCategoryListView: View {

    @ObservedObject var vm: ComplaintViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {

                // Greeting
                VStack(alignment: .leading, spacing: 4) {
                    Text("Hello, User! 👋")
                        .font(.system(size: 18, weight: .medium))
                    Text("Please select a category so we can assist you further.")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
                .padding(.bottom, 16)

                // Category rows
                VStack(spacing: 12) {
                    ForEach(vm.categories) { category in
                        ComplaintCategoryRow(category: category) {
                            vm.resetSheet()
                            vm.selectedCategory = category
                        }
                    }

                    // Previous Complaints row
                    ComplaintCategoryRow(
                        category: ComplaintCategory(
                            id: "history",
                            name: "Previous Complaints",
                            subtitle: "Browse your complaint history",
                            icon: "clock.arrow.circlepath"
                        )
                    ) {
                        vm.showHistory = true
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
    }
}

// MARK: - Single Category Row
struct ComplaintCategoryRow: View {

    let category: ComplaintCategory
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(iconBackground(for: category.id))
                        .frame(width: 42, height: 42)
                    Image(systemName: category.icon)
                        .font(.system(size: 18))
                        .foregroundColor(iconForeground(for: category.id))
                }

                // Text
                VStack(alignment: .leading, spacing: 2) {
                    Text(category.name)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.primary)
                    Text(category.subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            .padding(14)
            .background(Color(.systemBackground))
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color(.separator).opacity(0.4), lineWidth: 0.5)
            )
        }
        .buttonStyle(.plain)
    }

    private func iconBackground(for id: String) -> Color {
        switch id {
        case "1": return Color(hex: "#e8f0fe")
        case "2": return Color(hex: "#fef3e2")
        case "3": return Color(hex: "#e8f5e9")
        case "4": return Color(hex: "#e3f2fd")
        case "5": return Color(hex: "#f3e5f5")
        default:  return Color(hex: "#e0f2f1")
        }
    }

    private func iconForeground(for id: String) -> Color {
        switch id {
        case "1": return Color(hex: "#1a73e8")
        case "2": return Color(hex: "#e65100")
        case "3": return Color(hex: "#2e7d32")
        case "4": return Color(hex: "#0d47a1")
        case "5": return Color(hex: "#7b1fa2")
        default:  return Color(hex: "#00695c")
        }
    }
}

// MARK: - Bottom Sheet View
struct ComplaintBottomSheetView: View {

    @ObservedObject var vm: ComplaintViewModel
    let category: ComplaintCategory

    @Environment(\.dismiss) private var dismiss
    @State private var showDropdown: Bool = false

    private var options: [ComplaintIssueOption] {
        vm.issueOptions(for: category)
    }

    var isSubmitEnabled: Bool {
        vm.selectedIssueType != nil &&
        !vm.descriptionText.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Title
            Text(category.name)
                .font(.system(size: 18, weight: .medium))
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 20)

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {

                    // ── Dropdown ──────────────────────────────────────────
                    VStack(alignment: .leading, spacing: 0) {
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showDropdown.toggle()
                            }
                        } label: {
                            HStack {
                                Text(vm.selectedIssueType?.label ?? "Select issue type")
                                    .font(.system(size: 14))
                                    .foregroundColor(
                                        vm.selectedIssueType == nil ? .secondary : .primary
                                    )
                                Spacer()
                                Image(systemName: showDropdown ? "chevron.up" : "chevron.down")
                                    .font(.system(size: 13))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 13)
                            .background(Color(.systemGroupedBackground))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        vm.selectedIssueType != nil
                                            ? Color(hex: "#2e7d52")
                                            : Color(.separator).opacity(0.5),
                                        lineWidth: 0.8
                                    )
                            )
                        }
                        .buttonStyle(.plain)

                        // Dropdown options
                        if showDropdown {
                            VStack(spacing: 0) {
                                ForEach(options) { option in
                                    Button {
                                        withAnimation {
                                            vm.selectedIssueType = option
                                            showDropdown = false
                                        }
                                    } label: {
                                        HStack {
                                            Text(option.label)
                                                .font(.system(size: 14))
                                                .foregroundColor(.primary)
                                            Spacer()
                                            if vm.selectedIssueType?.id == option.id {
                                                Image(systemName: "checkmark")
                                                    .font(.system(size: 12, weight: .medium))
                                                    .foregroundColor(Color(hex: "#2e7d52"))
                                            }
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 13)
                                    }
                                    .buttonStyle(.plain)

                                    if option.id != options.last?.id {
                                        Divider()
                                            .padding(.leading, 16)
                                    }
                                }
                            }
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.separator).opacity(0.4), lineWidth: 0.5)
                            )
                            .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }

                    // ── Description ───────────────────────────────────────
                    VStack(alignment: .trailing, spacing: 4) {
                        TextEditor(text: $vm.descriptionText)
                            .font(.system(size: 14))
                            .frame(minHeight: 110)
                            .padding(10)
                            .background(Color(.systemGroupedBackground))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.separator).opacity(0.5), lineWidth: 0.8)
                            )
                            .overlay(alignment: .topLeading) {
                                if vm.descriptionText.isEmpty {
                                    Text("Please describe your issue")
                                        .font(.system(size: 14))
                                        .foregroundColor(.secondary.opacity(0.7))
                                        .padding(.top, 18)
                                        .padding(.leading, 14)
                                        .allowsHitTesting(false)
                                }
                            }
                            .onChange(of: vm.descriptionText) { newVal in
                                if newVal.count > 300 {
                                    vm.descriptionText = String(newVal.prefix(300))
                                }
                            }

                        Text("\(vm.descriptionText.count)/300")
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                    }

                    // ── Image Picker ──────────────────────────────────────
                    HStack(spacing: 8) {
                        Image(systemName: "photo")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                        Text("Select image")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(Color(.systemGroupedBackground))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(style: StrokeStyle(lineWidth: 0.8, dash: [5]))
                            .foregroundColor(Color(.separator).opacity(0.6))
                    )

                    // ── Submit Button ─────────────────────────────────────
                    Button {
                        vm.submitComplaint()
                    } label: {
                        ZStack {
                            if vm.isSubmitting {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Submit")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(isSubmitEnabled ? Color(hex: "#2e7d52") : Color(hex: "#9ec4b2"))
                        .cornerRadius(12)
                    }
                    .disabled(!isSubmitEnabled || vm.isSubmitting)
                    .onChange(of: vm.submitSuccess) { success in
                        if success {
                            vm.submitSuccess = false
                            dismiss()
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
        }
        .background(Color(.systemBackground))
    }
}

// MARK: - History View
struct ComplaintHistoryView: View {

    @ObservedObject var vm: ComplaintViewModel

    var body: some View {
        VStack(spacing: 0) {

            // Back button row
            HStack {
                Button {
                    vm.showHistory = false
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .medium))
                        Text("Back")
                            .font(.system(size: 14))
                    }
                    .foregroundColor(Color(hex: "#2e7d52"))
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            Divider()

            if vm.complaints.isEmpty {
                Spacer()
                VStack(spacing: 12) {
                    Image(systemName: "tray")
                        .font(.system(size: 36))
                        .foregroundColor(.secondary.opacity(0.4))
                    Text("No complaints yet")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                }
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(vm.complaints) { complaint in
                            ComplaintHistoryCard(complaint: complaint)
                        }
                    }
                    .padding(16)
                }
            }
        }
    }
}

// MARK: - History Card
struct ComplaintHistoryCard: View {

    let complaint: Complaint

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top) {
                Text(complaint.category)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
                Spacer()
                ComplaintStatusBadge(status: complaint.status)
            }

            Text(complaint.issueType)
                .font(.system(size: 12))
                .foregroundColor(.secondary)

            Text(complaint.description)
                .font(.system(size: 13))
                .foregroundColor(.primary)
                .lineSpacing(3)
                .padding(.top, 2)

            Text(complaint.createdAt)
                .font(.system(size: 11))
                .foregroundColor(.secondary)
                .padding(.top, 2)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(.separator).opacity(0.4), lineWidth: 0.5)
        )
    }
}

// MARK: - Status Badge
struct ComplaintStatusBadge: View {

    let status: ComplaintStatus

    var body: some View {
        Text(status.displayText)
            .font(.system(size: 11, weight: .medium))
            .foregroundColor(foregroundColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(backgroundColor)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(borderColor, lineWidth: 0.8)
            )
    }

    private var backgroundColor: Color {
        switch status {
        case .pending:  return Color(hex: "#fff8e1")
        case .approved: return Color(hex: "#e3f2fd")
        case .resolved: return Color(hex: "#e8f5e9")
        }
    }

    private var foregroundColor: Color {
        switch status {
        case .pending:  return Color(hex: "#f57f17")
        case .approved: return Color(hex: "#1565c0")
        case .resolved: return Color(hex: "#2e7d32")
        }
    }

    private var borderColor: Color {
        switch status {
        case .pending:  return Color(hex: "#f9a825").opacity(0.5)
        case .approved: return Color(hex: "#1976d2").opacity(0.4)
        case .resolved: return Color(hex: "#388e3c").opacity(0.4)
        }
    }
}

// MARK: - Color Extension (reuse or move to Extensions file)
extension Color {
    init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB,
                  red: Double(r) / 255,
                  green: Double(g) / 255,
                  blue: Double(b) / 255,
                  opacity: Double(a) / 255)
    }
}

#Preview {
    ComplaintView()
}
