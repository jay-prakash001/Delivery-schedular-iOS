//
//  BulletText.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 03/03/26.
//

import SwiftUI

struct BulletText: View {
    
    let text: String
    var body: some View {
        let isPad = UIDevice.current.userInterfaceIdiom == .pad

        HStack(spacing: 8) {
            Circle()
                .fill(Color.gray.opacity(0.6))
//                .frame(width: 6, height: 6)
                .frame(width: isPad ? 8 : 6, height: isPad ? 8 : 6)
            
            Text(text)
//                .font(.system(size: 14))
                .font(.system(size: isPad ? 18 : 14))
        }
    }
}

#Preview {
    BulletText(text: "")
}
