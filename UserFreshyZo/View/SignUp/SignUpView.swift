////
////  SignUpView.swift
////  UserFreshyZo
////
////  Created by Rahul Verma on 27/04/26.
////
//
//import SwiftUI
//


import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var router: AuthRouter
    
    var body: some View {
        ZStack {
            // MARK: Background - Soft Gradient
            LinearGradient(colors: [Color.green.opacity(0.05), .white],
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                
                // MARK: Custom Navigation Bar
                headerSection
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .center, spacing: 24) {
                        
                        // MARK: Hero Illustration
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.1))
                                .frame(width: 220, height: 220)
                                .blur(radius: 20)
                            
                            LottieView(name: "empty_cart")
                                .frame(width: 200, height: 200)
                        }
                        .padding(.top, 20)
                        
                        // MARK: Welcome Text
                        VStack(spacing: 8) {
                            Text("Almost there!")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.primary)
                            
                            Text("Tell us your name so we can personalize your experience.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 30)
                        }
                        
                        // MARK: Form Card
                        VStack(spacing: 20) {
                            // Phone Display Row
                            HStack {
                                Image(systemName: "phone.fill")
                                    .foregroundColor(.green)
                                    .font(.footnote)
                                
                                Text(authViewModel.phone.isEmpty ? "+91 xxxxxxxxxx" : authViewModel.phone)
                                    .font(.system(.body, design: .monospaced))
                                    .fontWeight(.medium)
                                
                                Spacer()
                                
                                Button {
                                    handleLogout()
                                } label: {
                                    Text("Change")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            
                            // Name Input
                            Material3OutLinedTextField(
                                title: "Full Name",
                                text: Binding(
                                    get: { authViewModel.fullname },
                                    set: { authViewModel.updateFullName($0) }
                                )
                            )
                            
                            // MARK: Action Button
                            continueButton
                        }
                        .padding(24)
                        .background(Color.white)
                        .cornerRadius(24)
                        .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 5)
                    }
                    .padding(20)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Components
    
    private var headerSection: some View {
        HStack {
            Button {
                handleLogout()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                    .padding(12)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 2)
            }
            
            Text("Create Profile")
                .font(.headline)
                .padding(.leading, 8)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var continueButton: some View {
        Button {
            router.navigate(to: .signUpMap)
        } label: {
            HStack(spacing: 12) {
                Text("Continue")
                    .font(.system(size: 18, weight: .bold))
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 16, weight: .black))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(authViewModel.fullname.count > 2 ? Color.green : Color.gray.opacity(0.4))
            .foregroundColor(.white)
            .cornerRadius(16)
            .shadow(color: Color.green.opacity(authViewModel.fullname.count > 2 ? 0.3 : 0), radius: 8, x: 0, y: 4)
        }
        .disabled(authViewModel.fullname.count <= 2)
    }
    private func handleLogout() {
        withAnimation {
            authViewModel.logout()
            
            // Check if we have at least 2 screens to go back
            if router.navPath.count >= 2 {
                // This removes the last two screens from the navigation stack
                router.navPath.removeLast(2)
            } else if !router.navPath.isEmpty {
                // If only one screen exists, go back one
                router.navPath.removeLast()
            } else {
                // If path is already empty, ensure we are at login
                router.navigate(to: .login_phone)
            }
        }
    }
}
//struct SignUpView: View {
//    
//    @EnvironmentObject var authViewModel: AuthViewModel
//    @EnvironmentObject var router: AuthRouter
//    
//    @State private var goToLogin = false
//    @State private var goToMainTab = false
//    
//    var body: some View {
//        
//            
//            VStack(alignment: .center) {
//                
//                // MARK: Header
//                HStack {
//                    
//                    Button {
//                        withAnimation {
//                            authViewModel.logout()
//                            
//                            if router.navPath.isEmpty {
//                                router.navigate(to: .login_phone)
//                            }else{
//                                router.navigateBack()
//
//                            }
////                            goToLogin = true
//                        }
//                    } label: {
//                        HStack(spacing: 8) {
//                            Image(systemName: "chevron.left")
//                            Text("Enter Details")
//                        }
//                    }
//                    .font(.title3)
//                    .foregroundStyle(Color(.label))
//                    .padding(10)
//                    
//                    Spacer()
//                }
//                
//                
//                Spacer().frame(height: 50)
//                
//                
//                // MARK: Animation
//                ZStack {
//                    Circle()
//                        .fill(.wellcomeSliderImgBg)
//                        .frame(width: 300, height: 300)
//                    
//                    LottieView(name: "empty_cart")
//                        .frame(width: 180, height: 180)
//                }
//                
//                
//                Spacer().frame(height: 10)
//                
//                
//                // MARK: Phone Row
//                HStack {
//                    
//                    Text(
//                        authViewModel.phone.isEmpty
//                        ? "+91 xxxxxxxxxx"
//                        : authViewModel.phone
//                    )
//                    
//                    Button {
//                        withAnimation {
//                            authViewModel.logout()
//                            
//                            if router.navPath.isEmpty {
//                                router.navigate(to: .login_phone)
//                            }else{
//                                router.navigateBack()
//
//                            }                        }
//                    } label: {
//                        Text("Edit Number")
//                            .foregroundColor(.blue)
//                    }
//                    
//                    Spacer()
//                }
//                
//                
//                // MARK: Input Fields
//                VStack(spacing: 12) {
//                    
////                    
//                    
//                    // MARK: Phone TextField
//                    Material3OutLinedTextField(
//                        title: "Enter Full Name",
//                        text: Binding(
//                            get: { authViewModel.fullname },
//                            set: { authViewModel.updateFullName($0) }
//                        )
//                    )
//                    
//
//                    
//                    
//                    // MARK: Continue Button
//                    Button {
//                        
//                        router.navigate(to: .signUpMap)
//                        
//                    } label: {
//                        HStack {
//                            Text("Continue")
//                                .fontWeight(.semibold)
//                            
//                            Image(systemName: "arrow.right.circle.fill")
//                        }
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.green)
//                        .foregroundColor(.white)
//                        .cornerRadius(12)
//                    }
//                    .padding(.top, 10)
//                }
//                
//                
//                Spacer()
//            }
//            .toolbar(.hidden, for: .navigationBar)
//            .ignoresSafeArea(edges: .top)
//            .ignoresSafeArea(.keyboard)
//            .padding(20)
//
//    }
//}
//
//#Preview {
//    SignUpView()
//        .environmentObject(AuthViewModel())
//        .environmentObject(AuthRouter())
//}
