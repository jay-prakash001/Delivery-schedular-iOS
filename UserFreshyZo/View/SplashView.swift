//
//  SplashView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 03/03/26.
//

import SwiftUI

struct SplashView: View {
    
    @EnvironmentObject private var authViewModel :AuthViewModel
    @EnvironmentObject  var router :Router
    
    @State private var isActive = false
    @State private var scale: CGFloat = 0.5
    @State private var opacity = 0.5
    
    var body: some View {
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        
        if isActive {
            
            if(authViewModel.isLoggedIn){
                if(authViewModel.isNewCustomer){
                    SignUpView().environmentObject(authViewModel).environmentObject(router)
                                        
                }else{
                    MainTabView()
                }
                
            }else{
                                
                WellComeSliderView().environmentObject(authViewModel).environmentObject(router)
            }
            
            
        } else {
            VStack {
                Image("freshyzo_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: isPad ? 260 : 150)
                    .scaleEffect(scale)
                    .opacity(opacity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
            .onAppear {
                
                withAnimation(.bouncy(duration: 1)) {
                    scale = 1.2
                    opacity = 1.2
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
