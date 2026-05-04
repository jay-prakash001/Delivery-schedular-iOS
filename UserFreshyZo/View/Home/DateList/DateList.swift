//
//  DateList.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 02/05/26.
//

import SwiftUI

struct DateList: View {
    @State private var selectedIndex: Int? = 89

    // Receive data from parent
    let data: [CalendarData]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                    if(index == 0){
                        
                    }else{
                    // check for previous and current date month if not same then show // or if current is 01 then only show the month
                    }
                    DateListItem(
                        isToday: index == 0,
                        day: item.day,
                        dayNo: item.dayNum,
                        hasVac: item.hasVacation,
                        hasDelivery: item.hasDelivery,
                        isSelected: selectedIndex == index
                    ) {
                        selectedIndex = index
                    }
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
        }
        .background(.white)
    }
}


func resolveMonth(_ dateString: String) -> String {
    let formatter = DateFormatter()
    
    // Set input format to match your yyyy-mm-dd string
    formatter.dateFormat = "yyyy-MM-dd"
    
    // Convert string to Date object
    guard let date = formatter.date(from: dateString) else { return "" }
    
    // Set output format to "MMMM" for full month name (e.g., "January")
    formatter.dateFormat = "MMMM"
    
    return formatter.string(from: date)
}

// Example usage:
// resolveMonth("2026-05-10") -> "May"

#Preview {
    DateList(data: [])
}
