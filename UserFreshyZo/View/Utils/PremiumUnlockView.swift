//
//  PremiumUnlockView.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 18/05/26.
//


import SwiftUI
import Lottie // Ensure you import Lottie here as well

struct PremiumUnlockView: View { 
    @State private var isProcessingMagic = false
    @EnvironmentObject var authViewModel : AuthViewModel
    @EnvironmentObject var mainRouter: MainRouter
    var body: some View {
        ZStack { 

            
            VStack(spacing: 30) { 
                Spacer() 
                
                // Lottie Animation Container
                // Changed parameter from 'animationName' to 'name' to match your struct definition
                LottieView(name: "register", loopMode: .loop)
                    .frame(width: 240, height: 240)
                
                // Text Content 
                VStack(spacing: 12) { 
                    Text("Unlock Full Access") 
                        .font(.system(size: 32, weight: .bold, design: .rounded)) 
                    
                    Text("Get access to all premium features and exclusive content.")
                        .font(.system(size: 16, weight: .regular))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40) 
                } 
                
                Spacer() 
                
                // Buttons Section 
                VStack(spacing: 16) { 
                    // Main Login / Unlock Button
                    Button(action: {
                        
                        authViewModel.skipToMain = false
                        mainRouter.resetToRoot()
                    }) {
                        HStack { 
                            Image(systemName: "lock.open.fill") .foregroundColor(.white)
                            Text("Login to see all the services") .foregroundColor(.white)
                                .fontWeight(.semibold)
                        } 
                        .foregroundColor(.black) 
                        .frame(maxWidth: .infinity) 
                        .frame(height: 56) 
                        .background( 
                            LinearGradient( 
                                colors: [
                                    Color(.appGreen),
                                    Color(.lightAppGreen)
                                ],
                                startPoint: .topLeading, 
                                endPoint: .bottomTrailing 
                            ) 
                        ) 
                        .cornerRadius(16) 
                        .shadow(color: Color(.thirdGreen).opacity(0.4), radius: 12, x: 0, y: 6)
                    }
               
                } 
                .padding(.horizontal, 24) 
                .padding(.bottom, 20) 
            } 
        } 
    } 
}


// MARK: - Previews
#Preview("Premium Screen") {
    PremiumUnlockView()
}
