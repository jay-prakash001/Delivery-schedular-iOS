//
//  LabReportView.swift
//  UserFreshyZo
//

import SwiftUI

// MARK: - Main View
struct LabReportView: View {

    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var homeViewModel : HomeViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                ForEach(homeViewModel.homeRes?.data.testReport ?? []){ test in
                    
                    
                    ReportCardView(
                        milkName: test.milkType,
                        testedDate: test.date,
                        rows: [
                            ("1.", "Fat",          "3.5 – 4.3", "\(test.fat)%"),
                            ("2.", "SNF",          "7.5 – 8.5", "\(test.snf)%"),
                            ("3.", "Urea",         "–",         "\(test.urea)"),
                            ("4.", "Starch",       "–",         "\(test.starch)"),
                            ("5.", "Acidity",      "–",         "\(test.acidity)"),
                            ("6.", "Detergent",    "–",         "\(test.detergent)"),
                            ("7.", "Antibiotics",  "–",         "\(test.antibiotics)"),
                            ("8.", "Caustic Soda", "–",         "\(test.causticSoda)"),
                        ]
                    )
                }

//                // ── Cow Milk Report Card ──────────────────────────────────
//                ReportCardView(
//                    milkName: "FreshyZo Cow Milk",
//                    testedDate: "2025-10-27",
//                    rows: [
//                        ("1.", "Fat",          "3.5 – 4.3", "3.8%"),
//                        ("2.", "SNF",          "7.5 – 8.5", "8.7%"),
//                        ("3.", "Urea",         "–",         "Pass"),
//                        ("4.", "Starch",       "–",         "Pass"),
//                        ("5.", "Acidity",      "–",         "Pass"),
//                        ("6.", "Detergent",    "–",         "Pass"),
//                        ("7.", "Antibiotics",  "–",         "Pass"),
//                        ("8.", "Caustic Soda", "–",         "Pass"),
//                    ]
//                )
//
//                // ── Buffalo Milk Report Card ──────────────────────────────
//                ReportCardView(
//                    milkName: "FreshyZo Buffalo Milk",
//                    testedDate: "2025-10-27",
//                    rows: [
//                        ("1.", "Fat",          "6.0 – 7.0", "6.5%"),
//                        ("2.", "SNF",          "8.5 – 9.5", "8.9%"),
//                        ("3.", "Urea",         "–",         "Pass"),
//                        ("4.", "Starch",       "–",         "Pass"),
//                        ("5.", "Acidity",      "–",         "Pass"),
//                        ("6.", "Detergent",    "–",         "Pass"),
//                        ("7.", "Antibiotics",  "–",         "Pass"),
//                        ("8.", "Caustic Soda", "–",         "Pass"),
//                    ]
//                )

                // ── Interpretation Card ───────────────────────────────────
                InterpretationView()
                    .padding(.bottom, 24)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                        .fontWeight(.semibold)
                }
            }
            ToolbarItem(placement: .principal) {
                HStack {
                    Text("FRESHYZO · LAB REPORTS")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "#2E7D32"))
                        .kerning(1.2)
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}




// MARK: - Corner Radius Helper
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        LabReportView()
    }
}
