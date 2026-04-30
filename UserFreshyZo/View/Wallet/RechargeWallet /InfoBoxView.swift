//
//  infoBox.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 25/03/26.
//

import SwiftUI

struct InfoBoxView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            ZStack {
                Circle()
                    .stroke(Color.blue, lineWidth: 1.5)
                    .frame(width: 22, height: 22)
                Text("i")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.blue)
            }
            .padding(.top, 1)

            Text("If your balance is zero or negative, please recharge before 9 PM to ensure your delivery is not missed tomorrow.")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.blue)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .background(Color(red: 0.90, green: 0.97, blue: 0.93))
        .cornerRadius(12)
    }
}


#Preview {
    InfoBoxView()
}
