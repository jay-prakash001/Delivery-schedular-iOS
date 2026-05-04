//
//  DateList.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 02/05/26.
//

import SwiftUI

 struct DateList: View {
        @State private var selectedIndex: Int? = 89
            
            let data: [DateItem] = [
                DateItem(day: "Mon", dayNo: "10", isToday: true,  hasVac: false, hasDelivery: true),
                DateItem(day: "Tue", dayNo: "11", isToday: false, hasVac: true,  hasDelivery: false),
                DateItem(day: "Wed", dayNo: "12", isToday: false, hasVac: false, hasDelivery: true),
                DateItem(day: "Thu", dayNo: "13", isToday: false, hasVac: false, hasDelivery: false),
                DateItem(day: "Fri", dayNo: "14", isToday: false, hasVac: true,  hasDelivery: false),
            ]
            
            var body: some View {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        
                        ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                            
                            DateListItem(
                                isToday: item.isToday,
                                day: item.day,
                                dayNo: item.dayNo,
                                hasVac: item.hasVac,
                                hasDelivery: item.hasDelivery,
                                isSelected: selectedIndex == index
                            ) {
                                selectedIndex = index // ✅ update selection
                            }
                        }
                    }
                    .padding(.horizontal).frame(height: 100, alignment: .center)
                }
        }
}



#Preview {
    DateList()
}
