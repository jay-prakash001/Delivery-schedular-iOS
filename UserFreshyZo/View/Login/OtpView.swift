//
//  OtpView.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 27/04/26.
//

import SwiftUI



struct OtpView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var router: AuthRouter
    @FocusState private var isFieldFocused: Bool // Use a single focus state
    
    var body: some View {
        
        
        VStack(spacing: 0) {
            // MARK: Header
            HStack {
                Button {
                    router.navigateBack()
                    viewModel.logout()
                    viewModel.otpRequested = false
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title3)
                        .foregroundColor(.black)
                }
                Spacer()
                Text("OTP Verification").font(.title3).fontWeight(.bold)
                Spacer()
                Image(systemName: "arrow.left").opacity(0)
            }
            .padding(.horizontal)
            .padding(.vertical, 14)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Verify Phone Number")
                    .font(.system(size: 28, weight: .bold))
                    .padding(.top, 48)
                
                Text("Enter the OTP we've sent to +91\n\(viewModel.phone)")
                    .font(.system(size: 18))
                    .foregroundColor(.black)
                    .padding(.top, 18)
                
                // MARK: OTP Area
                ZStack {
                    // Hidden TextField that captures everything
                    TextField("", text: Binding(
                        get: { viewModel.otp.joined() },
                        set: { newValue in
                            let filtered = newValue.filter { $0.isNumber }
                            if filtered.count <= 6 {
                                // We use your existing updateOTP logic via a loop
                                // to satisfy the "No ViewModel changes" requirement
                                for i in 0..<6 {
                                    if i < filtered.count {
                                        let char = String(filtered[filtered.index(filtered.startIndex, offsetBy: i)])
                                        viewModel.updateOTP(at: i, value: char)
                                    } else {
                                        viewModel.updateOTP(at: i, value: "")
                                    }
                                }
                            }
                        }
                    ))
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .focused($isFieldFocused)
                    .opacity(0.01) // Keep it active but invisible
                    
                    // Visual Boxes
                    HStack(spacing: 12) {
                        ForEach(0..<6, id: \.self) { index in
                            visualOtpBox(index)
                        }
                    }
                }
                .padding(.top, 50)
                .contentShape(Rectangle())
                .onTapGesture { isFieldFocused = true }
                
                HStack(alignment: .center){
                    
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }
                }
                Text(viewModel.resendText)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(viewModel.canResend ? .blue : .gray)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 42)
                    .onTapGesture { viewModel.resendOTP() }
                
                Spacer()
                
                // MARK: Verify Button
                Button {
                    viewModel.verifyOTP()
                } label: {
                    ZStack {
                        if viewModel.isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text("Verify and Proceed")
                                .font(.system(size: 20, weight: .bold))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 64)
                    .background(viewModel.otp.joined().count == 6 ? Color.green : Color.gray.opacity(0.5))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                }
                .disabled(viewModel.otp.joined().count < 6)
                .padding(.bottom, 10)
            }
            .padding(.horizontal, 24)
        }
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            isFieldFocused = true
            viewModel.startTimer()
        }
        .onChange(of: viewModel.isNewCustomer) { oldValue, isNew in
            print("shoud navigate")
                    if isNew {
                        router.navigate(to: .signUpName)
                    }
                }
    }
    
    // Simple display box for the visual part
    @ViewBuilder
    func visualOtpBox(_ index: Int) -> some View {
        let otpArray = viewModel.otp
        let char = otpArray[index]
        let isFocused = viewModel.otp.joined().count == index
        
        Text(char)
            .font(.title3.bold())
            .frame(width: 48, height: 58)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isFocused ? Color.green : Color.clear, lineWidth: 2)
            )
    }
}
