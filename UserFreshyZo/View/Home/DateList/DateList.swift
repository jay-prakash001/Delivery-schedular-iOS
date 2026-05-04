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



#Preview {
    DateList(data: [])
}
