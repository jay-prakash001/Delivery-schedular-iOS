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
    var isSelected: Bool = false
    var onTap: () -> Void
    
    var body: some View {
        // Set spacing to 0 so the Today bar and the content touch exactly
        HStack{
            
            VStack(spacing: 0) {
                
                // --- TODAY LABEL ---
                // If isToday is false, we keep the frame but make it empty to maintain layout height
                if isToday {
                    Text("Today")
                        .font(.system(size: 8, weight: .regular))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // Fills the 18px height
                        .background(Color(.lightAppGreen).opacity(0.4))
                        .frame(height: 16) // This is the total height of the green bar
                } else {
                    // Invisible placeholder to keep the layout consistent
                    Color.clear.frame(height: 16)
                }

                // --- DATE CONTENT ---
                VStack(spacing: 0) {
                    Spacer(minLength: 0)
                    
                    Text(day)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(isSelected ? Color(.appGreen) : Color(.appOrange))
                    
                    Text(dayNo)
                        .font(.system(size: 14, weight: .bold)) // Clean size for callout
                        .foregroundStyle(isSelected ? Color(.appGreen) : Color.black)
                    
                    Spacer(minLength: 0)
                    
                    // INDICATOR (Fixed height prevents shifting)
                    ZStack {
                        if hasVac {
                            Text("🌴").font(.system(size: 12))
                        } else {
                            Circle()
                                .frame(width: 6, height: 6)
                                .foregroundStyle(
                                    Color(hasDelivery ? .appGreen : .gray.opacity(0.4))
                                )
                        }
                    }
                    .frame(height: 14)
                    
                    Spacer(minLength: 4)
                }
                .frame(maxHeight: .infinity) // Takes the remaining height
            }
            .frame(width: 60, height: 70)
            .background( Color.white)
            .cornerRadius(10)
            .clipped()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        isToday ? Color.black : (isSelected ? Color(.appGreen) : Color.gray.opacity(0.0)),
                        lineWidth: 0.6
                    )
            )
            .onTapGesture {
                onTap()
            }
        }
    }
}

struct DateListItem0: View {
    var isToday: Bool = true
    var day: String = "Mon"
    var dayNo: String = "10"
    var hasVac: Bool = true
    var hasDelivery: Bool = true
    var isSelected: Bool = false
    var onTap: () -> Void
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 1) {
            // "Today" label
            ZStack (alignment : .center){
                Spacer()
                Text("Today")
                    .font(.system(size: 8, weight: .regular))
                Spacer()

            }
            .frame(maxWidth: .infinity)
            .frame(height: 20) // Use a fixed height for the bar instead of huge padding
            .background(Color(.lightAppGreen).opacity(0.4))
            .opacity(isToday ? 1 : 0)

            VStack(spacing: 0) {
                Text(day)
                    .font(.caption2).bold()
                    .foregroundStyle(isSelected ? Color(.appGreen) : Color(.appOrange))
                
                Text(dayNo)
                    .font(.callout).bold()
                    .foregroundStyle(isSelected ? Color(.appGreen) : Color.black)
                
                Spacer(minLength: 0)
                
                if hasVac {
                    Text("🌴").font(.caption)
                } else {
                    Circle()
                    
                        .frame(width: 6, height: 6)
                        .foregroundStyle(
                             Color(hasDelivery ? .appGreen.opacity(0.8) : .gray.opacity(0.4))
                        )
                }
            }
            .padding(.bottom, 6)
        }
        .frame(width: 60, height: 70) // Increased height slightly for better breathing room
        .background(isSelected ? Color(.appGreen).opacity(0.01) : Color.white)
        .cornerRadius(10)
        .clipped() // 1. CRITICAL: This clips the "Today" background to the corner radius
        .overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(
                isToday ? Color.black : (isSelected ? Color(.appGreen) : Color.gray.opacity(0.2)),
                lineWidth: 0.5
            )
        )
        .onTapGesture {
            onTap()
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
