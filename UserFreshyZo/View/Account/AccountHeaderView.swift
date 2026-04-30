//
//  AccountHeaderView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 28/03/26.
//

import SwiftUI

// MARK: - AccountHeaderView

struct AccountHeaderView: View {
    var body: some View {
        Text("Account")
            .font(.title2.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    AccountHeaderView()
}
