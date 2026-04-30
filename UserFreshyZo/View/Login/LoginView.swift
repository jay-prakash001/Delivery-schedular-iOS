//
//  LoginView.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 25/04/26.
//

import Foundation
import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var router: Router
    
    // Navigation States
    @State private var navigateToMainTab = false
    @State private var navigateToOtp = false
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            // MARK: Top Background Section
            ZStack(alignment: .topTrailing) {
                
                Color(.systemGray6)
                
                Image("products_group")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 560)
                
                // Skip Button
                Button {
                    navigateToMainTab = true
                } label: {
                    Text("Skip")
                        .fontWeight(.semibold)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                }
                .padding(.top, 60)
                .padding(.trailing, 20)
            }
            .frame(height: 560)
            .clipped()
            
            
            // MARK: Bottom Content Section
            VStack(spacing: 20) {
                
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
                .padding(.horizontal)
                
                
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
                    .padding(.horizontal, 40)
                
                Spacer()
            }
            .background(Color.white)
            .padding(.horizontal, 46)
        }
        
        
        // MARK: OTP Navigation Logic
        .onChange(of: authViewModel.otpRequested) { newValue in
            if newValue {
                navigateToOtp = true
                
                DispatchQueue.main.async {
                    authViewModel.otpRequested = false
                }
            }
        }
        
        
        // MARK: Navigation Destinations
        
        // Skip -> MainTabView
        .navigationDestination(isPresented: $navigateToMainTab) {
            MainTabView()
                .navigationBarBackButtonHidden(true)
        }
        
        // OTP Screen
        .navigationDestination(isPresented: $navigateToOtp) {
            OtpView()
                .environmentObject(authViewModel)
        }
        
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    NavigationStack {
        LoginView()
            .environmentObject(AuthViewModel())
            .environmentObject(Router())
    }
}
