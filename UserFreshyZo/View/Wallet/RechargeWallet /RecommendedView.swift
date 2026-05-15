import SwiftUI
import Combine

struct RecommendedView: View {
    @ObservedObject var vm: WalletViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("RECOMMENDED")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.gray)
                .tracking(0.5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    if let wallet = vm.walletData?.walletSummary.recommendedRecharge {
                        ForEach(wallet) { item in
                            // 1. Create a helper constant to check if this item is selected
                            let isSelected = vm.rechargeAmount == String(Int(item.amount))
                            
                            Button {
                                vm.rechargeAmount = String(Int(item.amount))
                            } label: {
                                Text("₹\(Int(item.amount)) / \(item.days) days")
                                    .font(.system(size: 12, weight: .semibold))
                                    // 2. Change text color based on selection
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(isSelected ? Color.lightAppGreen.opacity(0.3) : Color.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            // 4. Change border color
                                            .stroke(isSelected ? .appGreen : Color.gray.opacity(0.25), lineWidth: 1.4)
                                    )
                            }
                            // Smoothly animate the transition between states
                            .animation(.easeInOut(duration: 0.2), value: vm.rechargeAmount)
                        }
                    }
                }
                .padding(.horizontal, 1) // Prevents clipping of the border
            }
        }
    }
}
