//
//  MilkTestReportCard.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 03/03/26.
//

import SwiftUI

struct MilkTestReportCard: View {

    @EnvironmentObject var homeViewModel : HomeViewModel
    
    @EnvironmentObject var mainRouter : MainRouter
    var testReports: [TestReport] {
            homeViewModel.homeRes?.data.testReport ?? []
        }
    var body: some View {
        let isPad = UIDevice.current.userInterfaceIdiom == .pad

        VStack(spacing: 18) {

            // MARK: Title
            Text("FreshyZo provide 100% pure Milk")
                .font(.system(size: isPad ? 24 : 12, weight: .bold))
                .multilineTextAlignment(.center)

            if testReports.isEmpty{
                Text("No test report found")
            }else{
             
                
                Text("Tested : \(testReports[0].date)")
                    .font(.system(size: isPad ? 24 : 12, weight: .bold))
                    .foregroundColor(.secondGreen)
                    .multilineTextAlignment(.center)
                
                // MARK: Table Section
                VStack(spacing: 0) {
                    MilkRow(no: "1.", name: "Fat",         range: "6.0 - 7.0", value: "\(testReports[0].fat)%")
                    MilkRow(no: "2.", name: "SNF",         range: "8.5 - 9.5", value: "\(testReports[0].snf)%")
                    MilkRow(no: "3.", name: "Urea",        range: "-",         value: "\(testReports[0].urea)")
                    MilkRow(no: "4.", name: "Starch",      range: "-",         value: "\(testReports[0].starch)")
                    MilkRow(no: "5.", name: "Acidity",     range: "-",         value: "\(testReports[0].acidity)")
                    MilkRow(no: "6.", name: "Detergent",   range: "-",         value: "\(testReports[0].detergent)")
                    MilkRow(no: "7.", name: "Antibiotics", range: "-",         value: "\(testReports[0].antibiotics)")
                    MilkRow(no: "8.", name: "Caustic Soda",range: "-",         value: "\(testReports[0].causticSoda)")
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
                Text("View today's milk test report")
                    .foregroundColor(.white)
                    .font(.system(size: isPad ? 20 : 15, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(isPad ? 18 : 8)
                    .background(Color(.secondGreen))
                    .cornerRadius(14)
                    .onTapGesture{
                        mainRouter.navigate(to: .testreports)
                    }
                
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
