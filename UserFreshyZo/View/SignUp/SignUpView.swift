//
//  SignUpView.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 27/04/26.
//

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var router: Router
    
    @State private var goToLogin = false
    @State private var goToMainTab = false
    
    var body: some View {
        
        NavigationStack {
            
            VStack(alignment: .center) {
                
                // MARK: Header
                HStack {
                    
                    Button {
                        withAnimation {
                            authViewModel.logout()
                            goToLogin = true
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                            Text("Enter Details")
                        }
                    }
                    .font(.title3)
                    .foregroundStyle(Color(.label))
                    .padding(10)
                    
                    Spacer()
                }
                
                
                Spacer().frame(height: 50)
                
                
                // MARK: Animation
                ZStack {
                    Circle()
                        .fill(.wellcomeSliderImgBg)
                        .frame(width: 300, height: 300)
                    
                    LottieView(name: "empty_cart")
                        .frame(width: 180, height: 180)
                }
                
                
                Spacer().frame(height: 10)
                
                
                // MARK: Phone Row
                HStack {
                    
                    Text(
                        authViewModel.phone.isEmpty
                        ? "+91 xxxxxxxxxx"
                        : authViewModel.phone
                    )
                    
                    Button {
                        withAnimation {
                            authViewModel.logout()
                            goToLogin = true
                        }
                    } label: {
                        Text("Edit Number")
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                }
                
                
                // MARK: Input Fields
                VStack(spacing: 12) {
                    
                    Material3OutLinedTextField(
                        title: "Enter Full Name",
                        text: $authViewModel.fullname
                    )
                    
                    
                    
                    // MARK: Continue Button
                    Button {
                        goToMainTab = true
                    } label: {
                        HStack {
                            Text("Continue")
                                .fontWeight(.semibold)
                            
                            Image(systemName: "arrow.right.circle.fill")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .padding(.top, 10)
                }
                
                
                Spacer()
            }
            .padding(20)
            .navigationBarHidden(true)
//            .navigationTitle("Sign Up")
//            .navigationBarTitleDisplayMode(.inline)
            
            
            // MARK: Navigation
            
            .navigationDestination(isPresented: $goToLogin) {
                LoginView()
                    .environmentObject(authViewModel)
                    .environmentObject(router)
                    .navigationBarBackButtonHidden(true)
            }
            
            .navigationDestination(isPresented: $goToMainTab) {
                MainTabView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    SignUpView()
        .environmentObject(AuthViewModel())
        .environmentObject(Router())
}
