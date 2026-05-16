//
//  InvoiceDateRangeView.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 16/05/26.
//

import SwiftUI

// MARK: - Navigation Router Placeholder

// MARK: - Main View
struct InvoiceDateRangeView: View {
    
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @EnvironmentObject var mainRouter: MainRouter
    
    // Rule validation: Ensure End Date is >= Start Date
    private var isDateRangeValid: Bool {
        endDate >= Calendar.current.startOfDay(for: startDate)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            
            // Title
            Text("Select Invoice Date Range")
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Start Date (Allows picking any date up to the chosen end date)
            VStack(alignment: .leading, spacing: 10) {
                Text("Start Date")
                    .font(.headline)
                
                CustomDateSelector(
                    title: "Choose Start Date",
                    selectedDate: $startDate,
                    dateRange: Date.distantPast...endDate
                )
            }
            
            // End Date (Enforces selection strictly from start date onward)
            VStack(alignment: .leading, spacing: 10) {
                Text("End Date")
                    .font(.headline)
                
                CustomDateSelector(
                    title: "Choose End Date",
                    selectedDate: $endDate,
                    dateRange: startDate...Date.distantFuture
                )
            }
            
            // Inline Warning Note if validation fails
            if !isDateRangeValid {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text("End date must be after or equal to the start date.")
                }
                .font(.subheadline)
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, -8)
            }
            
            Spacer()
            
            // Generate Invoice Button
            Button {
                if isDateRangeValid {
                    mainRouter.navigate(to: .generateinvoice(
                        startDate: startDate.toYMDString(),
                        endDate: endDate.toYMDString()
                    ))
                }
            } label: {
                Text("Generate Invoice")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(isDateRangeValid ? Color.green : Color.gray) // Standard fallback if appGreen is custom
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .disabled(!isDateRangeValid)
        }
        .padding()
        .navigationTitle("Invoice")
        .navigationBarTitleDisplayMode(.inline)
        // Auto-adjusts end date forward if user changes start date past it
        .onChange(of: startDate) { _, newStartDate in
            if endDate < newStartDate {
                endDate = newStartDate
            }
        }
    }
}

// MARK: - Reusable Collapsing Date Selector Component
struct CustomDateSelector: View {
    let title: String
    @Binding var selectedDate: Date
    let dateRange: ClosedRange<Date>
    
    @State private var isPickerVisible = true
    
    // Extracted the formatting logic safely away from the layout DSL
    private var cleanTitle: String {
        title.replacingOccurrences(of: "Choose ", with: "")
    }
    
    var body: some View {
        VStack {
            if isPickerVisible {
                DatePicker(
                    title,
                    selection: $selectedDate,
                    in: dateRange,
                    displayedComponents: .date
                )
                .datePickerStyle(.compact)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .onChange(of: selectedDate) { _, _ in
                    withAnimation(.easeInOut) {
                        isPickerVisible = false
                    }
                }
            } else {
                Button {
                    withAnimation(.easeInOut) {
                        isPickerVisible = true
                    }
                } label: {
                    HStack {
                        // Using direct string interpolation formatting to guarantee clean type compilation
                        Text("\(cleanTitle): \(selectedDate)")
                        
                        Spacer()
                        
                        Image(systemName: "calendar")
                    }
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .foregroundColor(.green)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        InvoiceDateRangeView()
            .environmentObject(MainRouter())
    }
}
