

import Foundation
import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var router: AuthRouter
    
    // Navigation States
    @State private var navigateToMainTab = false
    @State private var navigateToOtp = false
    
    var body: some View {
        // Use a ScrollView or VStack without global horizontal padding
        VStack(spacing: 0) {
            
            // MARK: - Top Background Section (Full Width)
            ZStack(alignment: .topTrailing) {
                Color(.systemGray6)
                
                Image("products_group")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: 560) // Explicit screen width
                    .clipped() // Ensures image doesn't bleed right/left
                
                // Skip Button
                Button {
                    authViewModel.skipToMain = true
                } label: {
                    Text("Skip")
                        .fontWeight(.semibold)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                }
                .padding(.top, 60)
                .padding(.trailing, 20) // Now relative to screen edge
            }
            .frame(height: 560)
            
            // MARK: - Bottom Content Section (Padded)
            VStack(spacing: 10) {
                
                // Logo
                VStack(spacing: 2) {
                    Image("freshyzo_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                    
                    Text("Fresh Matlab FreshyZo")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)
                
                // MARK: Phone TextField
                Material3OutLinedTextField(
                    title: "Enter Phone Number",
                    text: Binding(
                        get: { authViewModel.phone },
                        set: { authViewModel.updatePhone($0) }
                    )
                )
                
                // MARK: Continue Button
                Button {
                    authViewModel.requestOtp()
                } label: {
                    HStack {
                        if authViewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Continue")
                                .fontWeight(.semibold)
                            
                            Image(systemName: "arrow.right.circle.fill")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        authViewModel.isValidPhone
                        ? Color.green
                        : Color.gray.opacity(0.3)
                    )
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(!authViewModel.isValidPhone)
                
                // MARK: Error Message
                if let error = authViewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
                
                // MARK: Terms Text
                Text("By continuing, you agree to our Terms and Privacy Policy")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding(.horizontal, 20) // Padding applied ONLY to text content
            .background(Color.white)
        }
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea(edges: .top)
        .ignoresSafeArea(.keyboard)
        .onChange(of: authViewModel.otpRequested) { newValue in
            if newValue {
                router.navigate(to: .login_otp)
                DispatchQueue.main.async {
                    authViewModel.otpRequested = false
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
            .environmentObject(AuthViewModel())
            .environmentObject(AuthRouter())
    }
}
