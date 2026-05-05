//
//  HomeCalendarDialog.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 05/05/26.
//

import SwiftUI


struct HomeCalendarDialog: View {
    var calendarData: CalendarData
    var onClick: () -> Void
    
    // 1. Create a state to hold the content height
    @State private var contentHeight: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture { onClick() }
            
            VStack(spacing: 10) {
                Text("Delivery Details")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.top, 10)
                
                
                Text("Remaining Balance : ₹ \(calendarData.remainingBalance)")
                    .font(.system(size: 12, weight: .bold)).foregroundColor(Color(.appGreen))
                        .padding(.top, 10)
                Divider()
                
                VStack {
                    if calendarData.hasVacation {
                        Text("Enjoy Your Vacation").padding()
                    } else if !calendarData.hasDelivery {
                        Text("No Product Delivers Today").padding()
                    } else {
                        // 2. The ScrollView height is now controlled by contentHeight
                        
                        
                        
                        
                        if calendarData.items.isEmpty {
                            Text("No Items")
                        } else {
                            ScrollView {
                                VStack(spacing: 12) { // Increased spacing
                                    ForEach(calendarData.items) { item in
                                        CalendarDataDialogItemView(item: item)
                                    }
                                }
                                .padding(.horizontal, 10) // CRITICAL: Gives space for item shadows
                                .padding(.vertical, 10)
                                .background(GeometryReader { geo in
                                    Color.clear.onAppear { self.contentHeight = geo.size.height }
                                })
                            }
                            .frame(height: min(contentHeight + 10, 250)) // Added a little buffer
                        }
                    }
                }
                Button(action: onClick) {
                    Text("OK")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 40) // Makes the button wider than the text
                        .padding(.vertical, 10)
                        .background(Color.appGreen.opacity(0.8))
                        .cornerRadius(20)
                }
                .padding(.top, 8)    // Gap after the items list
                .padding(.bottom, 10)
                
            }
            .padding(16)
            .frame(maxWidth: 350)
            .background(Color.white)
            .cornerRadius(20)
            .padding(.horizontal,10)
            .shadow(color: .black.opacity(0.15), radius: 20)
        }
    }
}

#Preview {
    HomeCalendarDialog(calendarData: dummyCalendarData){
        
    }
}

let dummyCalendarData = CalendarData(
    date: "2026-05-05",
    day: "Monday",
    dayNum: "05",
    hasDelivery: true,
    hasVacation: false,
    items: [
        CalendarItem(
            image: "https://png.pngtree.com/png-vector/20240709/ourmid/pngtree-glass-milk-bottles-png-image_12969190.png",
            productId: "101",
            productName: "Cow Milk",
            qty: "2",
            type: "Morning"
        ),
        CalendarItem(
            image: "https://example.com/curd.png",
            productId: "102",
            productName: "Curd",
            qty: "1",
            type: "Evening"
        )
    ],
    remainingBalance: 250
)

// MARK: - PreferenceKey to read height from GeometryReader
struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        // Keep the largest height reported
        value = max(value, nextValue())
    }
}
