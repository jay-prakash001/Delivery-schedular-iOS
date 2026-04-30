//
//  OtpView.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 27/04/26.
//

import SwiftUI

struct OtpView: View {
    
    @EnvironmentObject  var viewModel: AuthViewModel
    @FocusState private var focusedIndex: Int?
    @EnvironmentObject  var router :Router

    
    var body: some View {
            
            
            VStack(spacing: 0)
            {
                
                // MARK: Header
                
                HStack {
                    Button {
                        // back action
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title3)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    Text("OTP Verification")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Image(systemName: "arrow.left")
                        .opacity(0)
                }
                .padding(.horizontal)
                .padding(.vertical, 14)
                
                Divider()
                
                // MARK: Content
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text("Verify Phone Number")
                        .font(.system(size: 28, weight: .bold))
                        .padding(.top, 48)
                    
                    Text("Enter the OTP we've sent to +91\n\(viewModel.phone)")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                        .padding(.top, 18)
                    
                    // OTP Boxes
                    HStack(spacing: 12) {
                        ForEach(0..<6, id: \.self) { index in
                            otpBox(index)
                        }
                    }
                    .padding(.top, 50)
                    Text(viewModel.resendText)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(viewModel.canResend ? .blue : .gray)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 42)
                        .onTapGesture {
                            viewModel.resendOTP()
                        }
                    
                    Spacer()
                    
                    // Button
                    Button {
                        viewModel.verifyOTP()
                    } label: {
                        ZStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Verify and Proceed")
                                    .font(.system(size: 20, weight: .bold))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 64)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                    }
                    .disabled(!viewModel.isOTPComplete)
                    .opacity(viewModel.isOTPComplete ? 1 : 0.7)
                    .padding(.bottom, 30)
                }
                .padding(.horizontal, 24)
            }
            .background(Color.white)
            .ignoresSafeArea(edges: .bottom)
            .navigationBarBackButtonHidden(true)
            
            .onAppear {
                focusedIndex = 0
                viewModel.startTimer() // Starts the countdown when user arrives
            }
            .navigationDestination(
                isPresented: .constant(viewModel.isLoggedIn)
            ) {
                if viewModel.isNewCustomer {
//                    SignUpView(authViewModel:viewModel).navigationBarBackButtonHidden(false)
//                    Color.clear.onAppear{
//                        router.navigate(to: .signUpName)
//                    }
                } else {
                    MainTabView()
                }
            }
            
        }
     
    // MARK: OTP Box
    
    
    @ViewBuilder
    func otpBox(_ index: Int) -> some View {
        TextField("", text: Binding(
            get: { viewModel.otp[index] },
            set: { newValue in
                // Handle only the last character to prevent multi-character input
                let lastChar = newValue.filter { $0.isNumber }.last.map { String($0) } ?? ""
                viewModel.updateOTP(at: index, value: lastChar)
                
                // Auto-focus next box
                if !lastChar.isEmpty && index < 5 {
                    focusedIndex = index + 1
                }
            })
        )
        .keyboardType(.numberPad) // standard for OTP
        .multilineTextAlignment(.center)
        .font(.title3.bold())
        .frame(width: 48, height: 58)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .focused($focusedIndex, equals: index)
        // Updated iOS 17+ Syntax: (oldValue, newValue)
        .onChange(of: viewModel.otp[index]) { oldValue, newValue in
            if newValue.isEmpty && oldValue.count > 0 {
                // Backspace detected: jump to previous box
                if index > 0 {
                    focusedIndex = index - 1
                }
            }
        }
    }
    
    
    @ViewBuilder
    func otpBox0(_ index: Int) -> some View {
        TextField("", text: Binding(
            get: { viewModel.otp[index] },
            set: { newValue in
                viewModel.updateOTP(at: index, value: newValue)
                
                if !newValue.isEmpty {
                    if index < 5 {
                        focusedIndex = index + 1
                    }
                } else {
                    if index > 0 {
                        focusedIndex = index - 1
                    }
                }
            })
        )
        .keyboardType(.numberPad)
        .multilineTextAlignment(.center)
        .font(.title3.bold())
        .frame(width: 48, height: 58)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .focused($focusedIndex, equals: index)
    }
    
    
}
