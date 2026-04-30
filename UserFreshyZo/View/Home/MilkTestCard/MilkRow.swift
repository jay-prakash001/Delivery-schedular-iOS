//
//  MilkRow.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 03/03/26.
//

import SwiftUI

struct MilkRow: View {
    
    let no: String
    let name: String
    let range: String
    let value: String
    
    var body: some View {
        let isPad = UIDevice.current.userInterfaceIdiom == .pad

        HStack {
            Text(no)
//                .frame(width: 25, alignment: .leading)
                .frame(width: isPad ? 40 : 25, alignment: .leading)

            
            Text(name)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(range)
//                .frame(width: 80, alignment: .leading)
                .frame(width: isPad ? 120 : 80, alignment: .leading)

            
            Text(value)
//                .frame(width: 60, alignment: .trailing)
                .frame(width: isPad ? 90 : 60, alignment: .trailing)

        }
//        .font(.system(size: 14))
        .font(.system(size: isPad ? 18 : 14))

    }
}

#Preview {
    MilkRow(no: "1", name: "Fat", range: "343.5", value: "24242")
}
