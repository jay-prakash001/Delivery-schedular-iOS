import SwiftUI

struct RechargeHistoryRow: View {
    
    let item: RechargeHistory
    
    var body: some View {
        
        HStack(spacing: 12) {
            
            // MARK: - Leading Icon
            
            ZStack {
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.green.opacity(0.18),
                                Color.green.opacity(0.08)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 42, height: 42)
                
                Image(systemName: paymentIcon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.green)
            }
            
            // MARK: - Transaction Details
            
            VStack(alignment: .leading, spacing: 4) {
                
                Text("₹\(item.rechargeAmount)")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.black)
                
                HStack(spacing: 4) {
                    
                    Image(systemName: "calendar")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                    
                    Text(item.rechargeDate)
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // MARK: - Payment Mode Badge
            
            HStack(spacing: 4) {
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 10))
                
                Text(item.paymentMode.uppercased())
                    .font(.system(size: 10, weight: .semibold))
            }
            .foregroundColor(.green)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(Color.green.opacity(0.12))
            .cornerRadius(16)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray.opacity(0.08), lineWidth: 1)
        )
        .shadow(
            color: Color.black.opacity(0.03),
            radius: 5,
            x: 0,
            y: 2
        )
    }
    
    // MARK: - Dynamic Payment Icon
    
    var paymentIcon: String {
        
        switch item.paymentMode.lowercased() {
            
        case "upi":
            return "iphone.gen3"
            
        case "card":
            return "creditcard.fill"
            
        case "cash":
            return "banknote.fill"
            
        case "net banking":
            return "building.columns.fill"
            
        default:
            return "wallet.pass.fill"
        }
    }
}
