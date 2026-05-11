//import Foundation
//import SwiftUI
//import Combine
//



import Foundation
import SwiftUI
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    
    // MARK: - UI State
    
    @Published var isLoading: Bool = false
    @Published var isLoggedIn: Bool = false
    
    @Published var skipToMain : Bool = false
    
    // MARK: - Login Screen
    
    @Published var phone: String = ""
    @Published var fullname: String = ""
    @Published var address: String = ""
    @Published var lat: String = ""

    @Published var lng: String = ""

    @Published var otpRequested: Bool = false
    @Published var errorMessage: String? = nil
    
    // MARK: - OTP Screen
    
    @Published var otp: [String] = Array(repeating: "", count: 6)
    @Published var secondsRemaining: Int = 57
    @Published var canResend: Bool = false
    @Published var isNewCustomer: Bool = true
    
    
//    @Published var wellComeSlider  = true
    
    private var timer: Timer?
    
    // MARK: - Init
    
    init() {
        isLoggedIn = UserDefaults.standard.string(forKey: "auth_token") != nil
        isNewCustomer = UserDefaults.standard.bool(forKey: "isNewCustomer")
        phone = UserDefaults.standard.string(forKey: "userPhone") ?? ""
        fullname = UserDefaults.standard.string(forKey: "fullName") ?? ""
        
        print("token  \(UserDefaults.standard.string(forKey : "auth_token"))")

    }
    
    deinit {
        timer?.invalidate()
    }
    
    // MARK: - Computed Properties
    
    var isValidPhone: Bool {
        phone.count == 10
    }
    
    var enteredOTP: String {
        otp.joined()
    }
    
    var isOTPComplete: Bool {
        enteredOTP.count == 6
    }
    
    var resendText: String {
        canResend
        ? "Resend OTP"
        : "Resend OTP in 00:\(String(format: "%02d", secondsRemaining))"
    }
    
    // MARK: - Login State
    
    func getLoginState() {
//        isLoggedIn = KeychainHelper.shared.isLoggedIn()
    }
    
    // MARK: - Phone Input
    
    func updatePhone(_ value: String) {
        let digits = value.filter { $0.isNumber }
        phone = String(digits.prefix(10))
    }
    
    func updateFullName(_ value : String){
        fullname = value
        UserDefaults.standard.set(value, forKey:"fullName" )
    }
    
    // MARK: - Request OTP
    
    func requestOtp() {
        
        guard isValidPhone else {
            errorMessage = "Enter valid phone number"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let response: OtpRes = try await APIService.shared.post(
                    urlString: "https://www.freshyzo.com/admin/auth/send_otp",
                    body: GetOtpReq(
                        mobileNo: phone,
                        deviceType: "ios",
                        deviceModel: UIDevice.current.name
                    )
                )
                
                print("OTP Response:", response)
                
                if response.status {
                    otpRequested = true
                    startTimer()
                } else {
                    errorMessage = "Failed to send OTP"
                }
                
            } catch {
                errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }
    }
    
    // MARK: - OTP Input
    
    func updateOTP(at index: Int, value: String) {
        let digit = value.filter { $0.isNumber }
        otp[index] = String(digit.prefix(1))
    }
    
    func clearOTP() {
        otp = Array(repeating: "", count: 6)
    }
    
    
    
    func updateOtpRequested(value :Bool){
        otpRequested = value
    }
    // MARK: - Timer
    // Inside AuthViewModel
    // Replace your startTimer function with this:
    func startTimer() {
            timerTask?.cancel()
            
            // CRITICAL: Reset these values every time the timer starts
            self.secondsRemaining = 57
            self.canResend = false
            
            timerTask = Task {
                while secondsRemaining > 0 {
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    if Task.isCancelled { return }
                    self.secondsRemaining -= 1
                }
                self.canResend = true
            }
        }

    // Add this property to your AuthViewModel:
    private var timerTask: Task<Void, Never>?
    
    func resendOTP() {
        guard canResend else { return }
        clearOTP()
        requestOtp()
    }
    
    // MARK: - Verify OTP
    
    func verifyOTP() {
        
        guard isOTPComplete else { return }
        
        isLoading = true
        errorMessage = nil
        guard isValidPhone else {
            errorMessage = "Enter valid phone number"
            return
        }
        
        
        Task {
            do {
                let response: VerifyOtpRes = try await APIService.shared.post(
                    urlString: "https://www.freshyzo.com/admin/auth/customer_login",
                    body: CustomerLoginReq(mobile_no: phone, otp: enteredOTP)
                )
                
                
                print("OTP Response:", response)
                
                if response.status {
                    if let token = response.data?.token {
                            KeychainHelper.shared.save(key: "auth_token", value: token)
                            print("Token saved successfully")
                        UserDefaults.standard.set(token,forKey: "auth_token")

                        }
                    
                print("Verify otp \(response)")
                    
                    isNewCustomer =  response.message.localizedCaseInsensitiveContains("not a registered customer")
                    
                    UserDefaults.standard.set(isNewCustomer,forKey: "isNewCustomer")
                    
                    UserDefaults.standard.set(phone, forKey: "userPhone")

                        isLoggedIn = true
                    
                    print("islogged in \(isLoggedIn)   newCustomer \(isNewCustomer)")
//                        if let token = response.data?.token {
//                            // Save to UserDefaults (iOS equivalent of SharedPrefs)
//                            UserDefaults.standard.set(token, forKey: "auth_token")
//                            
//                            // Or your Keychain
//                            KeychainHelper.shared.save(key: "auth_token", value: token)
//                        }
                    
                    
                    
                } else {
                    errorMessage = response.message ?? "Something went wrong..."
                    
                }
                
            } catch {
                errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }

    }
    
    
    
    func registerNewCustomer() {
        
        
        
        
        Task{
            
            isLoading = true
            do{
                // 1. Prepare the name parts safely
                let components = fullname.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ")
                let firstName = components.first ?? ""
                let lastName = components.count > 1 ? components.dropFirst().joined(separator: " ") : ""


                let headers = ["Authorization" : UserDefaults.standard.string(forKey: "auth_token") ?? ""]
                print("fullName \(fullname) lat \(lat) lng \(lng) address \(address) headers \(headers)")

                // 2. Use them in your API call
                let response : RegisterNewCustomerRes = try await APIService.shared.post(
                    urlString: "https://www.freshyzo.com/admin/Customer_App_Api_V1/signup",
                    headers: headers,
                    body: RegisterNewCustomerReq(
                        first_name: firstName,
                        last_name: lastName,
                        lat: lat,
                        lng: lng,
                        address: address,
                        mobile_no: phone
                    )
                )
                
                
                print("Sign up \(response)")
                
                if response.status {
                    isNewCustomer = false
                    isLoggedIn = true
                    UserDefaults.standard.set(false, forKey: "isNewCustomer")
                    isLoading = false
                }
                
            }catch {
                isLoading = false
                errorMessage = error.localizedDescription

            }
        }
    }
    // MARK: - Logout
    
    func logout() {
        isLoggedIn = false
        phone = ""
        clearOTP()
        otpRequested = false
        UserDefaults.standard.removeObject( forKey: "auth_token")
        UserDefaults.standard.removeObject( forKey: "isNewCustomer")
        UserDefaults.standard.removeObject( forKey: "fullName")
        UserDefaults.standard.removeObject( forKey: "userPhone")
    }
}
