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
    @StateObject private var productViewModel : ProductViewModel = ProductViewModel()
    @StateObject private var checkOutViewModel : CheckOutViewModel = CheckOutViewModel()
    
    @State private var isActive = false
    @State private var scale: CGFloat = 0.5
    @State private var opacity = 0.5
    
    var body: some View {
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        
        
        
        if isActive {
            
            if(authViewModel.skipToMain){
                NavigationStack(path : $mainRouter.navPath){
                    
                    MainTabView()
                        .navigationDestination(for: MainRouter.MainFlow.self){destination in
                            switch destination {
                            case .milkbanneroffer(let banner) : MilkTrialView(banner: banner)
                            case .testreports : LabReportView()
                            case .article (let article) : ArticleView(article: article)
                            case . productdetails(let id ) : ProductDetailView(id : id)
                                //                            case . subscriptionstart(let product, let mediaUrls, let quantity, let offers) : SubscriptionView(product : product, mediaUrls: mediaUrls,quantity : quantity, offers: offers)
                                //
                                //
                                //                            case .allreview : AllReviewView()
                                //                            case .referandearn : RefferalView()
                                //                            case .walletrechargehistory(let rechargeHistory) : WalletRechargeHistoryView(rechargeHistory: rechargeHistory)
                                //                            case .invoice : InvoiceDateRangeView()
                                //                            case .generateinvoice(let startDate, let endDate) : InvoiceView(startDate: startDate, endDate: endDate)
                                //                            case .vacation : VacationView()
                                //                            case .deliveries : Text("Deliveries")
                                //                            case .orders : Text("Orders")
                            default : PremiumUnlockView()
                                
                            }
                            
                        }
                }
                .environmentObject(authViewModel)
                .environmentObject(vm)
                .environmentObject(mainRouter)
                .environmentObject(cartViewModel)
                .environmentObject(checkOutViewModel)
                .environmentObject(productViewModel)
            }else{
                
                ZStack{
                    
                    
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
                                    .navigationDestination(for: MainRouter.MainFlow.self){destination in
                                        switch destination {
                                        case .milkbanneroffer(let banner) : MilkTrialView(banner: banner)
                                        case .testreports : LabReportView()
                                        case .article (let article) : ArticleView(article: article)
                                            
                                        case . productdetails(let id ) : ProductDetailView(id : id)
                                        case . subscriptionstart(let product, let mediaUrls, let quantity, let offers) : SubscriptionView(product : product, mediaUrls: mediaUrls,quantity : quantity, offers: offers)
                                            
                                        case .allreview : AllReviewView()
                                        case .referandearn : RefferalView()
                                        case .walletrechargehistory(let rechargeHistory) : WalletRechargeHistoryView(rechargeHistory: rechargeHistory)
                                        case .invoice : InvoiceDateRangeView()
                                        case .generateinvoice(let startDate, let endDate) : InvoiceView(startDate: startDate, endDate: endDate)
                                        case .vacation : VacationView()
                                        case .deliveries : DeliveriesView()
                                        case .orders : OrderHistoryView()
                                        default : EmptyView()
                                        }
                                        
                                    }
                            }
                            .environmentObject(authViewModel)
                            .environmentObject(mainRouter)
                            .environmentObject(vm)
                            .environmentObject(cartViewModel)
                            .environmentObject(checkOutViewModel)
                            .environmentObject(productViewModel)
                            
                            
                        }
                        
                        
                        if authViewModel.showUnauthorizedAlert{
                            SessionExpiredDialog(){
                                authRouter.navigate(to: .login_phone)
                                authViewModel.isLoggedIn = false
                                
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
                    scale = 1.5
                    opacity = 1.5
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
