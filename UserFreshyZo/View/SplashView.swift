//
//  SplashView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 03/03/26.
//

import SwiftUI

struct SplashView: View {
    
    @EnvironmentObject private var authViewModel :AuthViewModel
    @StateObject var authRouter = AuthRouter()
    @StateObject var mainRouter = MainRouter()
    @StateObject var cartViewModel = CartViewModel()
    @StateObject private var vm = HomeViewModel()

    @State private var isActive = false
    @State private var scale: CGFloat = 0.5
    @State private var opacity = 0.5
    
    var body: some View {
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        
        if isActive {
            
            if(authViewModel.skipToMain){
                NavigationStack(path : $mainRouter.navPath){
                    
                    MainTabView()
                        .environmentObject(authViewModel)
                        .environmentObject(vm)
                        .environmentObject(mainRouter)
                        .environmentObject(cartViewModel)
                        .navigationDestination(for: MainRouter.MainFlow.self){destination in
                            switch destination {
                            case .milkbanneroffer(let banner) : MilkTrialView(banner: banner)
                            case .testreports : LabReportView()
                            default : EmptyView()
                            }
                            
                        }
                }
            }else{
                if(authViewModel.isLoggedIn){
                    if(authViewModel.isNewCustomer) {
                        NavigationStack(path: $authRouter.navPath) {
                            // ✅ Set SignUpView as the ROOT for New Customers
                            SignUpView()
                                .navigationDestination(for: AuthRouter.Auth.self) { destination in
                                    switch destination {
                                    case .login_phone: LoginView()
                                    case .login_otp: OtpView()
                                    case .signUpName: SignUpView()
                                    case .signUpMap: SignUpMapView()
                                    }
                                }
                        }
                        .environmentObject(authViewModel)
                        .environmentObject(authRouter)
                    }else{
                        NavigationStack(path : $mainRouter.navPath){
                            
                            MainTabView()
                                .environmentObject(authViewModel)
                                .environmentObject(mainRouter)
                                .environmentObject(vm)
                                .environmentObject(cartViewModel)
                                .navigationDestination(for: MainRouter.MainFlow.self){destination in
                                    switch destination {
                                    case .milkbanneroffer(let banner) : MilkTrialView(banner: banner)
                                    case .testreports : LabReportView()
                                    default : EmptyView()
                                    }
                                    
                                }
                        }
                        
                    }
                    
                }else{
                    
                    NavigationStack(path : $authRouter.navPath){
                        WellComeSliderView().navigationDestination(for: AuthRouter.Auth.self){
                            destination in
                            switch destination{
                            case .login_phone : LoginView()
                            case .login_otp :OtpView()
                            case .signUpName : SignUpView()
                            case .signUpMap : SignUpMapView()
                            }
                        }
                    }.environmentObject(authViewModel).environmentObject(authRouter)
                }
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
