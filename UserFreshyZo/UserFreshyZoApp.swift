//
//  UserFreshyZoApp.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 21/02/26.
//

import SwiftUI

@main
struct UserFreshyZoApp: App {
    
    @StateObject var cartVM = CartViewModel()
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var router = Router()
    var body: some Scene {
        WindowGroup {
            
//            SplashView()
            NavigationStack {
                SignUpMapView()
                    .environmentObject(AuthViewModel())
            }
                .environmentObject(cartVM)
                .environmentObject(authViewModel)
                .environmentObject(router)
                .preferredColorScheme(.light)
        }
    }
}


