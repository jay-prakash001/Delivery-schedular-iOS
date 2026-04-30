//
//  MilkTestReportCard.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 03/03/26.
//

import SwiftUI

struct MilkTestReportCard: View {

    var body: some View {
        let isPad = UIDevice.current.userInterfaceIdiom == .pad

        VStack(spacing: 18) {

            // MARK: Title
            Text("FreshyZo provide 100% pure Milk")
                .font(.system(size: isPad ? 24 : 18, weight: .bold))
                .multilineTextAlignment(.center)

            // MARK: Table Section
            VStack(spacing: 0) {
                MilkRow(no: "1.", name: "Fat",         range: "6.0 - 7.0", value: "3.8%")
                MilkRow(no: "2.", name: "SNF",         range: "8.5 - 9.5", value: "8.7%")
                MilkRow(no: "3.", name: "Urea",        range: "-",         value: "Pass")
                MilkRow(no: "4.", name: "Starch",      range: "-",         value: "Pass")
                MilkRow(no: "5.", name: "Acidity",     range: "-",         value: "Pass")
                MilkRow(no: "6.", name: "Detergent",   range: "-",         value: "Pass")
                MilkRow(no: "7.", name: "Antibiotics", range: "-",         value: "Pass")
                MilkRow(no: "8.", name: "Caustic Soda",range: "-",         value: "Pass")
            }
            .padding(isPad ? 22 : 16)
            .background(Color.green.opacity(0.08))
            .cornerRadius(16)

            // MARK: Bullet Points
            HStack(alignment: .top, spacing: isPad ? 60 : 40) {
                VStack(alignment: .leading, spacing: 8) {
                    BulletText(text: "Urea free")
                    BulletText(text: "Detergent free")
                }
                VStack(alignment: .leading, spacing: 8) {
                    BulletText(text: "Starch free")
                    BulletText(text: "No antibiotics")
                }
            }

            // MARK: Button
            NavigationLink(destination: LabReportView()) {
                Text("View today's milk test report")
                    .foregroundColor(.white)
                    .font(.system(size: isPad ? 20 : 15, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(isPad ? 18 : 12)
                    .background(Color("AppGreenColor"))
                    .cornerRadius(14)
            }
        }
        .padding(isPad ? 28 : 20)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
    }
}

#Preview {
    NavigationStack {
        MilkTestReportCard()
    }
}
