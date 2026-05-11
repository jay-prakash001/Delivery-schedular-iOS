import Foundation
import Razorpay
import UIKit

enum PaymentResult {
    case success(paymentID: String)
    case failure(message: String)
}

class PaymentService: NSObject {
    private var razorpay: RazorpayCheckout? // Made optional
    private var completion: ((PaymentResult) -> Void)?
    
    // Empty init - no longer need the key here
    override init() {
        super.init()
    }
    
    func startPayment(
        apiKey: String, // Pass the dynamic key here
        options: [String: Any],
        from controller: UIViewController,
        completion: @escaping (PaymentResult) -> Void
    ) {
        self.completion = completion
        
        // Initialize the SDK with the key provided by the API response
        razorpay = RazorpayCheckout.initWithKey(apiKey, andDelegateWithData: self)
        
        DispatchQueue.main.async {
            self.razorpay?.open(options, displayController: controller)
            print("Payment started with Key: \(apiKey)")
        }
    }
}

// MARK: - Razorpay Delegates
extension PaymentService: RazorpayPaymentCompletionProtocolWithData {
    
    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        print("Payment Success: \(payment_id)")
        completion?(.success(paymentID: payment_id))
        cleanup()
    }
    
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        print("Payment Error \(code): \(str)")
        
        
        completion?(.failure(message: str))
        
        cleanup()
    }
    
    private func cleanup() {
        completion = nil
        razorpay = nil // Release the SDK instance after use
    }
}
