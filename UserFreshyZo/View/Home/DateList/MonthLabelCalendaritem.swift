//
//  MonthLabelCalendaritem.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 05/05/26.
//

import SwiftUI

struct MonthLabelCalendaritem: View {
    var month: String = "April"
    
    var body: some View {
        VStack {
            Text(month.uppercased())
                .font(.system(size: 10, weight: .bold, design: .rounded)) // Smaller font for thinness
                .foregroundStyle(.white)
                .fixedSize() // Keeps text from wrapping/truncating
                .rotationEffect(.degrees(-90))
                .frame(width: 20, height: 60) // Force a narrow width
                .background(Color.appGreen)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.1), radius: 3, x: 1, y: 1)
        }
        .frame(maxHeight: 70)
    }
}

#Preview {
    MonthLabelCalendaritem()
}
