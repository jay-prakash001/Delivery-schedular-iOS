//
//  ReportCardView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 27/03/26.
//

import SwiftUI

// MARK: - Subview: Report Card
struct ReportCardView: View {
    let milkName: String
    let testedDate: String
    let rows: [(String, String, String, String)] // (no, name, range, result)

    var body: some View {
        VStack(spacing: 0) {

            // Green Header
            VStack(spacing: 4) {
                Text(milkName)
                    .font(.title3).bold()
                    .foregroundColor(.white)
                Text("QUALITY TEST REPORT")
                    .font(.caption).fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.85))
                    .kerning(1.5)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                LinearGradient(
                    colors: [Color(hex: "#2E7D32"), Color(hex: "#43A047")],
                    startPoint: .leading, endPoint: .trailing
                )
            )
            .cornerRadius(16, corners: [.topLeft, .topRight])

            // Column Headers
            HStack {
                Text("SR.")
                    .frame(width: 30, alignment: .leading)
                Text("TEST NAME")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("VALID RANGE")
                    .frame(width: 90, alignment: .center)
                Text("RESULT")
                    .frame(width: 70, alignment: .center)
            }
            .font(.caption).fontWeight(.semibold)
            .foregroundColor(Color(hex: "#2E7D32"))
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.white)

            Divider()

            // Test Rows
            VStack(spacing: 0) {
                ForEach(Array(rows.enumerated()), id: \.offset) { index, row in
                    HStack {
                        Text(row.0)
                            .frame(width: 30, alignment: .leading)
                            .foregroundColor(.secondary)
                        Text(row.1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(row.2)
                            .frame(width: 90, alignment: .center)
                            .foregroundColor(.secondary)
                        Text(row.3)
                            .font(.caption).fontWeight(.semibold)
                            .foregroundColor(Color(hex: "#2E7D32"))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color(hex: "#2E7D32").opacity(0.12))
                            .cornerRadius(20)
                            .frame(width: 70, alignment: .center)
                    }
                    .font(.subheadline)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.white)

                    if index < rows.count - 1 {
                        Divider().padding(.horizontal, 16)
                    }
                }
            }

            // Footer
            VStack(alignment: .leading, spacing: 6) {
                Label("Tested — \(testedDate)", systemImage: "circle.fill")
                    .font(.caption).fontWeight(.semibold)
                    .foregroundColor(.orange)
                Label("Pass: Pure Milk — No adulteration detected.", systemImage: "circle.fill")
                    .font(.caption)
                    .foregroundColor(Color(hex: "#2E7D32"))
                Label("Fail: Adulterated Milk — Contains harmful additives.", systemImage: "circle.fill")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(Color.white)
            .cornerRadius(16, corners: [.bottomLeft, .bottomRight])
        }
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 3)
    }
}



