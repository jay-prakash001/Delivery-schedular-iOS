//import SwiftUI
//



import SwiftUI


import SwiftUI

struct WalletRechargeHistoryView: View {
    
    var rechargeHistory: [RechargeHistory]?
    
    @State private var selectedSort: SortMetric = .date
    @State private var isAscending: Bool = false
    
    enum SortMetric: String {
        case amount = "Amount"
        case date = "Date"
        case paymentMode = "Payment Mode"
    }
    
    var sortedHistory: [RechargeHistory] {
        guard let history = rechargeHistory else { return [] }
        
        return history.sorted { item1, item2 in
            switch selectedSort {
            case .amount:
                let amt1 = Double(item1.rechargeAmount) ?? 0
                let amt2 = Double(item2.rechargeAmount) ?? 0
                return isAscending ? (amt1 < amt2) : (amt1 > amt2)
                
            case .date:
                return isAscending ? (item1.rechargeDate < item2.rechargeDate) : (item1.rechargeDate > item2.rechargeDate)
                
            case .paymentMode:
                return isAscending ? (item1.paymentMode < item2.paymentMode) : (item1.paymentMode > item2.paymentMode)
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack {
                // MARK: - History List
                if !sortedHistory.isEmpty {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 14) {
                            ForEach(sortedHistory) { item in
                                RechargeHistoryRow(item: item)
                            }
                        }
                        .padding(.top, 10)
                        .padding(.horizontal)
                    }
                } else {
                    Spacer()
                    VStack(spacing: 18) {
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.12))
                                .frame(width: 90, height: 90)
                            
                            Image(systemName: "clock.arrow.circlepath")
                                .font(.system(size: 36))
                                .foregroundColor(.green)
                        }
                        
                        VStack(spacing: 6) {
                            Text("No Transactions Yet")
                                .font(.system(size: 20, weight: .bold))
                            
                            Text("Your wallet recharge history will appear here once you make a recharge.")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 30)
                        }
                    }
                    Spacer()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Recharge History")
        // MARK: - Clean, Compact Toolbar Sort Button
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Section("Direction") {
                        Button { isAscending = false } label: {
                            Label("Descending", systemImage: !isAscending ? "checkmark" : "")
                        }
                        Button { isAscending = true } label: {
                            Label("Ascending", systemImage: isAscending ? "checkmark" : "")
                        }
                    }
                     
                    Section("Sort By") {
                        Button { selectedSort = .amount } label: {
                            Label("Amount", systemImage: selectedSort == .amount ? "largecircle.fill.circle" : "circle")
                        }
                        Button { selectedSort = .date } label: {
                            Label("Date", systemImage: selectedSort == .date ? "largecircle.fill.circle" : "circle")
                        }
                        Button { selectedSort = .paymentMode } label: {
                            Label("Payment Mode", systemImage: selectedSort == .paymentMode ? "largecircle.fill.circle" : "circle")
                        }
                    }
                } label: {
                    // Modern trailing navigation button icon that dynamically shifts based on sort direction
                    Image(systemName: isAscending ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                        .font(.system(size: 18, weight: .medium))
                }
            }
        }
    }
}
struct WalletRechargeHistoryView0: View {
    
    var rechargeHistory: [RechargeHistory]?
    
    // 1. Separate selected metric from sort direction for full control
    @State private var selectedSort: SortMetric = .date
    @State private var isAscending: Bool = false // Default to descending (newest/highest first)
    
    enum SortMetric: String {
        case amount = "Amount"
        case date = "Date"
        case paymentMode = "Payment Mode"
    }
    
    // 2. Clear computed logic handling dual-direction sort
    var sortedHistory: [RechargeHistory] {
        guard let history = rechargeHistory else { return [] }
        
        return history.sorted { item1, item2 in
            switch selectedSort {
                
            case .amount:
                let amt1 = Double(item1.rechargeAmount) ?? 0
                let amt2 = Double(item2.rechargeAmount) ?? 0
                return isAscending ? (amt1 < amt2) : (amt1 > amt2)
                
            case .date:
                // Assuming rechargeDate supports standard comparison operations
                return isAscending ? (item1.rechargeDate < item2.rechargeDate) : (item1.rechargeDate > item2.rechargeDate)
                
            case .paymentMode:
                return isAscending ? (item1.paymentMode < item2.paymentMode) : (item1.paymentMode > item2.paymentMode)
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 18) {
                
                // MARK: - Sort Dropdown Menu
                Menu {
                    Section("Sort Direction") {
                        Button { isAscending = false } label: {
                            Label("Descending", systemImage: !isAscending ? "checkmark" : "")
                        }
                        Button { isAscending = true } label: {
                            Label("Ascending", systemImage: isAscending ? "checkmark" : "")
                        }
                    }
                    
                    Section("Metrics") {
                        Button { selectedSort = .amount } label: {
                            Label("Amount", systemImage: "indianrupeesign.circle")
                        }
                        Button { selectedSort = .date } label: {
                            Label("Date", systemImage: "calendar")
                        }
                        Button { selectedSort = .paymentMode } label: {
                            Label("Payment Mode", systemImage: "creditcard")
                        }
                    }
                    
                } label: {
                    HStack {
                        Spacer()
                        HStack(spacing: 8) {
                            // Dynamic icon indicating direction style
                            Image(systemName: isAscending ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                                .font(.system(size: 14))
                            
                            Text("Sort By:")
                                .font(.system(size: 14, weight: .semibold))
                            
                            // Displays e.g., "Amount (Asc)" or "Date (Desc)"
                            Text("\(selectedSort.rawValue) (\(isAscending ? "Asc" : "Desc"))")
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                        )
                        .shadow(
                            color: Color.black.opacity(0.04),
                            radius: 6,
                            x: 0,
                            y: 2
                        )
                    }
                }
                
                // MARK: - History List
                if !sortedHistory.isEmpty {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 14) {
                            ForEach(sortedHistory) { item in
                                RechargeHistoryRow(item: item)
                            }
                        }
                        .padding(.bottom, 20)
                    }
                } else {
                    Spacer()
                    VStack(spacing: 18) {
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.12))
                                .frame(width: 90, height: 90)
                            
                            Image(systemName: "clock.arrow.circlepath")
                                .font(.system(size: 36))
                                .foregroundColor(.green)
                        }
                        
                        VStack(spacing: 6) {
                            Text("No Transactions Yet")
                                .font(.system(size: 20, weight: .bold))
                            
                            Text("Your wallet recharge history will appear here once you make a recharge.")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 30)
                        }
                    }
                    Spacer()
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        // Fixed compilation bug: navigationTitle expects a raw string parameter, not a Text view instance
        .navigationTitle("Recharge History")
    }
}
//struct WalletRechargeHistoryView: View {
//    
//    var rechargeHistory: [RechargeHistory]?
//    
//    @State private var selectedSort: SortType = .date
//    
//    enum SortType: String {
//        case amount = "Amount"
//        case date = "Date"
//        case paymentMode = "Payment Mode"
//    }
//    
//    var sortedHistory: [RechargeHistory] {
//        
//        guard let history = rechargeHistory else { return [] }
//        
//        switch selectedSort {
//            
//        case .amount:
//            return history.sorted {
//                (Double($0.rechargeAmount) ?? 0) >
//                (Double($1.rechargeAmount) ?? 0)
//            }
//            
//        case .date:
//            return history.sorted {
//                $0.rechargeDate > $1.rechargeDate
//            }
//            
//        case .paymentMode:
//            return history.sorted {
//                $0.paymentMode < $1.paymentMode
//            }
//        }
//    }
//    
//    var body: some View {
//        
//        ZStack {
//            
//            Color(.white)
//                .ignoresSafeArea()
//            
//            VStack(alignment: .leading, spacing: 18) {
//                
//                // MARK: - Header
//                
//                //                VStack(alignment: .leading, spacing: 4) {
//                //
//                //                    Text("Recharge History")
//                //                        .font(.system(size: 28, weight: .bold))
//                //
//                //                    Text("Track all your wallet recharge transactions")
//                //                        .font(.system(size: 14))
//                //                        .foregroundColor(.gray)
//                //                }
//                
//                // MARK: - Sort Button
//                
//                Menu {
//                    
//                    Button {
//                        selectedSort = .amount
//                    } label: {
//                        Label(
//                            "Sort by Amount",
//                            systemImage: "indianrupeesign.circle"
//                        )
//                    }
//                    
//                    Button {
//                        selectedSort = .date
//                    } label: {
//                        Label(
//                            "Sort by Date",
//                            systemImage: "calendar"
//                        )
//                    }
//                    
//                    Button {
//                        selectedSort = .paymentMode
//                    } label: {
//                        Label(
//                            "Sort by Payment Mode",
//                            systemImage: "creditcard"
//                        )
//                    }
//                    
//                } label: {
//                    HStack{
//                        Spacer()
//                        HStack(spacing: 8) {
//                            Image(systemName: "arrow.up.arrow.down.circle.fill")
//                                .font(.system(size: 14))
//                            
//                            Text("Sort By")
//                                .font(.system(size: 14, weight: .semibold))
//                            
//                            Text(selectedSort.rawValue)
//                                .font(.system(size: 13))
//                                .foregroundColor(.gray)
//                        }
//                        .foregroundColor(.black)
//                        .padding(.horizontal, 14)
//                        .padding(.vertical, 10)
//                        .background(Color.white)
//                        .cornerRadius(12)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 12)
//                                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
//                        )
//                        .shadow(
//                            color: Color.black.opacity(0.04),
//                            radius: 6,
//                            x: 0,
//                            y: 2
//                        )
//
//                    }
//                }
//                
//                // MARK: - History List
//                
//                if !sortedHistory.isEmpty {
//                    
//                    ScrollView(showsIndicators: false) {
//                        
//                        VStack(spacing: 14) {
//                            
//                            ForEach(sortedHistory) { item in
//                                
//                                RechargeHistoryRow(item: item)
//                            }
//                        }
//                        .padding(.bottom, 20)
//                    }
//                }
//                else {
//                    
//                    Spacer()
//                    
//                    VStack(spacing: 18) {
//                        
//                        ZStack {
//                            
//                            Circle()
//                                .fill(Color.green.opacity(0.12))
//                                .frame(width: 90, height: 90)
//                            
//                            Image(systemName: "clock.arrow.circlepath")
//                                .font(.system(size: 36))
//                                .foregroundColor(.green)
//                        }
//                        
//                        VStack(spacing: 6) {
//                            
//                            Text("No Transactions Yet")
//                                .font(.system(size: 20, weight: .bold))
//                            
//                            Text("Your wallet recharge history will appear here once you make a recharge.")
//                                .font(.system(size: 14))
//                                .foregroundColor(.gray)
//                                .multilineTextAlignment(.center)
//                                .padding(.horizontal, 30)
//                        }
//                    }
//                    
//                    Spacer()
//                }
//            }
//            .padding()
//        }
//        .navigationBarTitleDisplayMode(.inline)
//        .navigationTitle(
//            Text("Recharge History")
//                .font(.system(size: 28, weight: .bold)))
//    }
//}
