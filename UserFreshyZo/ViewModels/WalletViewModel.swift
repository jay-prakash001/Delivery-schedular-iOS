import Foundation
import Combine

@MainActor // Ensures UI updates happen on the main thread
class WalletViewModel: ObservableObject {
    
    // 1. The Single Source of Truth for the UI
    @Published var state: UiState<WalletData> = .idle
    
    // Form property
    @Published var rechargeAmount: String = ""
    
    // Convenience properties to avoid nested optional unwrapping in the View
    var walletData: WalletData? {
        if case .success(let data) = state { return data }
        return nil
    }

    func getWalleteDetails() {
        // Set state to loading before starting the call
        state = .loading
        
        Task {
            do {
                // Assuming your APIService returns the decoded WalletResponse
                let response: WalletResponse = try await APIService.shared.get(
                    urlString: "https://www.freshyzo.com/admin/Customer_App_Api_V1/wallet_details"
                )
                
                if response.status {
                    state = .success(response.data)
                } else {
                    state = .error(response.message)
                }
                
            } catch let error as APIError { // Assuming you have an APIError enum
                // Handle specific cases like token expiration
                switch error {
        
                default:
                    state = .error("Something went wrong. Please try again.")
                }
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func recharge() {
        guard let amount = Double(rechargeAmount), amount > 0 else { return }
        // Logic for recharge API call would go here,
        // usually updating state to .loading during the process.
    }
}
