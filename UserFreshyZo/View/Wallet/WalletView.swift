//
//  SwiftUIView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 24/03/26.
//

import SwiftUI

struct WalletView: View {
    
    @StateObject var vm = WalletViewModel()
    @Environment(\.dismiss) var dismiss
    
    var isNavigated: Bool = false  // false = tab, true = from Account
    
    var body: some View {
        VStack(spacing: 0) {
            WalletHeaderView(onBack: isNavigated ? { dismiss() } : nil)
                .padding()
                .background(Color.white)
            
            ScrollView {
                VStack(spacing: 16) {
                    BalanceCardView(vm: vm)
                    StatsRowView(vm: vm)
                    RechargeSectionView(vm: vm)
                    HistorySectionView()
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
        }.onAppear{
            if vm.walletData == nil{
                vm.getWalleteDetails()
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    WalletView()
}
