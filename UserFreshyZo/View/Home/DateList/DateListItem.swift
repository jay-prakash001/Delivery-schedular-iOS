//
//  DateListItem.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 02/05/26.
//

import SwiftUI

struct DateListItem: View {
    var isToday: Bool = true
    var day: String = "Mon"
    var dayNo: String = "10"
    var hasVac: Bool = true
    var hasDelivery: Bool = true
    var isSelected: Bool = false   // ✅ new
    var onTap: () -> Void          // ✅ new
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 2) {
            
            Text("Today")
                .font(.caption)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 4)
                .background(Color(.lightAppGreen).opacity(0.4))
                .opacity(isToday ? 1 : 0)

            Text(day)
                .font(.callout).bold()
                .foregroundStyle(isSelected ? Color(.appGreen) : Color(.appOrange))
                        
            Text(dayNo)
                .font(.title2).bold()
                .padding(2)
                .foregroundStyle(isSelected ? Color(.appGreen) : Color.black)
            
            if hasVac {
                Text("🌴")
                    .font(.title3)
                    .padding(2)
            } else {
                Capsule()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(
                      
                         Color(hasDelivery ? .appGreen.opacity(0.8) : .lightAppGreen.opacity(0.4))
                    )
            }
        }
        .frame(width: 80, height: 100)
        .background(isSelected ? Color(.appGreen).opacity(0.1) : Color.white) // ✅ highlight
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color(.appGreen) : Color.gray, lineWidth: 1)
        )
        .onTapGesture {
            onTap() // ✅ click handler
        }
    }
}

struct DateItem: Identifiable {
    let id = UUID()
    let day: String
    let dayNo: String
    let isToday: Bool
    let hasVac: Bool
    let hasDelivery: Bool
}


#Preview {
    DateListItem(){}
}
