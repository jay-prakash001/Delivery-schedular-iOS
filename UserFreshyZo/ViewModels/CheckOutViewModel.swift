import Foundation
import Combine
import UIKit

/// Represents the possible states of the Checkout flow
enum CheckoutState: Equatable {
    case idle
    case loading
    case success(message: String) // Added message for the success dialog
    case error(String)
}

@MainActor // Ensures all UI updates happen on the Main Thread
class CheckOutViewModel: ObservableObject {
    
    @Published var state: CheckoutState = .idle
    
    private let paymentService = PaymentService()
    private let apiBaseURL = "https://www.freshyzo.com/admin/Customer_App_Api_V1"

    // Helper property for View convenience
    var isLoading: Bool { state == .loading }
    var errorMessage: String? {
        if case .error(let message) = state { return message }
        return nil
    }

    func resetState() {
        state = .idle
    }

    func initiateCheckout(amount: String, couponCode: String, productId: String, startsOn: String, trialDays: String) {
        Task {
            state = .loading
            
            do {
                let token = UserDefaults.standard.string(forKey: "auth_token") ?? ""
                let phone = UserDefaults.standard.string(forKey: "userPhone") ?? ""
                
                guard !phone.isEmpty else {
                    state = .error("Phone number not found.")
                    return
                }

                let headers = ["Authorization": token]
                let requestBody = RazorPayOrderReq(mobile_no: phone, amount: amount, coupon_code: couponCode)

                // STEP 1: Create Order
                let response: RazorpayOrderResponse = try await APIService.shared.post(
                    urlString: "\(apiBaseURL)/razorpay_order",
                    headers: headers,
                    body: requestBody
                )
                
                print("razorpay order res \(response)")
                
                if response.status, let data = response.data {
                    presentRazorpaySheet(order: data, productId: productId, startsOn: startsOn, trialDays: trialDays)
                } else {
                    state = .error(response.message)
                }
                
            } catch {
                state = .error("Network error: \(error)")
            }
        }
    }

    private func presentRazorpaySheet(order: RazorpayOrderData, productId: String, startsOn: String, trialDays: String) {
        let phone = UserDefaults.standard.string(forKey: "userPhone") ?? ""
        let name = UserDefaults.standard.string(forKey: "fullName") ?? ""
        
        
        print("User \(name) \(phone)")
        let options: [String: Any] = [
            "amount": order.amount,
            "currency": order.currency,
            "name": "FreshyZo Milk",
            "order_id": order.orderId,
            "prefill": ["name": name, "contact": phone]
        ]
        
        guard let rootVC = UIApplication.topViewController() else {
            state = .error("UI Context Error: Could not present payment screen.")
            return
        }
        
        paymentService.startPayment(apiKey: order.keyId, options: options, from: rootVC) { [weak self] result in
            
            print("razorpay payment result \(result)")

            // Move back to MainActor for state updates
            Task { @MainActor in
                switch result {
                case .success(let paymentID):
                    await self?.verifyPayment(paymentID: paymentID, orderID: order.orderId, productId: productId, startsOn: startsOn, trialDays: trialDays)
                    
                case .failure(let message):
                    self?.state = .error(message)
                    
                
                }
            }
        }
    }
    
    private func verifyPayment(paymentID: String, orderID: String, productId: String, startsOn: String, trialDays: String) async {
        state = .loading
        
        do {
            print("verify trial ")

            let token = UserDefaults.standard.string(forKey: "auth_token") ?? ""
            let headers = ["Authorization": token]
            let body = GetTrialRequest(productId: productId, startOn: startsOn, trialDays: trialDays)
            
            let response: GeneralApiResponse = try await APIService.shared.post(
                urlString: "\(apiBaseURL)/get_trial",
                headers: headers,
                body: body
            )
            
            if response.status {
                        state = .success(message: "Your trial has been activated successfully!")
                    } else {
                        state = .error(response.message)
                    }
                
            print("trial  res \(response)")

        } catch {
            state = .error("Verification failed: \(error.localizedDescription)")
        }
    }
}
